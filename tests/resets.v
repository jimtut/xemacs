// Verilog HDL for denali_lru, resets _behavioral


// ************************************************************************
// ***************************  MODULE RESETS  ****************************
// ************************************************************************

`timescale 100ps / 100ps
module resets(
	CLOCK,
	pci_addr[31:0],
	pci_adio[31:0],
	pci_base_hit[7:0],
	pci_s_cbe[3:0],
	pci_s_xwrdn,
	pci_s_data,
	pci_ready,
	pci_data_vld,
	N_PROGRAM_IN,
	N_PROGRAM_OUT_GLOBAL_RESET,
	N_LDC,
	N_JP0_RST,
	N_JP1_RST,
	N_BE_RAVEN_RST,
	N_JP_RST_REQ,
	N_EMU0_RST_REQ,
	N_EMU1_RST_REQ,
	UART_RST,
	N_FE_RST_OUT,
	N_BE_RST_OUT,
	N_FE_EXP_RST,
	N_FE_MIRROR_RST,
	N_BE_MIRROR_RST
);

// PORT DECLARATIONS   ****************************************************

input	CLOCK;					// designed for 33 MHZ clock
input	N_JP_RST_REQ;				// JP Reset Request (QREQ)
input	N_EMU0_RST_REQ;			// Emulator #0 Reset Request
input	N_EMU1_RST_REQ;			// Emulator #1 Reset Request
input	N_PROGRAM_IN;				// do I really need this?
output	N_PROGRAM_OUT_GLOBAL_RESET;	// resets LRU (and thus entire board)
output	N_LDC;					// Low During Configure
output	N_JP0_RST;				// JP0 Reset
output	N_JP1_RST;				// JP1 Reset
output	N_BE_RAVEN_RST;			// BE Raven Reset
output	UART_RST;					// UART Reset
output	N_FE_RST_OUT;				// FE Reset (Interphase or 875)
output	N_BE_RST_OUT;				// BE Reset (Interphase or 875)
output	N_FE_EXP_RST;				// PCI Expansion Slot Reset
output	N_FE_MIRROR_RST;			// FE Mirror Reset (895)
output	N_BE_MIRROR_RST;			// BE Mirror Reset (895)

inout	[31:0] pci_adio;			// PCI Data
input	[31:0] pci_addr;			// PCI Address
input	[7:0] pci_base_hit;			// Base Hit
input	[3:0] pci_s_cbe;			// PCI CBE
input	pci_s_wrdn;				// PCI Write/Read
input	pci_s_data;				// PCI Slave Data Phase
input	pci_data_vld;				// PCI Data Valid
output	pci_ready;				// PCI Ready (creates TRDY)


// PARAMETERS  ************************************************************

parameter delay=70;		// 70 = 7ns


// REGISTERS  **********************************************************

// Inputs:

// Outputs:
reg n_jp1_rst_bit;
reg n_uart_rst_bit;
reg N_BE_RAVEN_RST;
reg N_FE_RST_OUT, N_BE_RST_OUT, N_FE_EXP_RST;
reg N_FE_MIRROR_RST, N_BE_MIRROR_RST;

// Misc:
reg [31:0] pci_adio_reg;
reg decode_word04;
reg pci_ready;
reg jp_req_disable;

wire n_global_reset_oe;
wire read_word04, write_word04;


// ASSIGNS  ***************************************************************

// 'decode_word04' decodes a hit to address 0004
// 'read_word04' and 'write_word04' simply qualify that decode with
// the read/write signal 'pci_s_wrdn'.
assign #delay read_word04 = decode_word04 & !pci_s_wrdn;
assign #delay write_word04 = decode_word04 & pci_s_wrdn & pci_data_vld;

// Put our data out on the 'pci_adio' bus when 'read_word04' is asserted.
assign #delay pci_adio[31:0] = read_word04 ? pci_adio_reg[31:0] : 32'bz;

// The UART reset is active HIGH, so this bit needs to be inverted.
// This line handles the "write" case; the "read" is handled below.
assign #delay UART_RST = !n_uart_rst_bit;


// RESETS  ****************************************************************

/*	The PCI Core will be held in reset during configuration by feeding back
	this 'N_LDC' output to the 'RST_N' input (which feeds the Startup module
	in the Core).  After configuration, we want this signal to go HIGH to
	pull the Core (and the whole FPGA) out of reset.
*/
FDPE FDPE_LDC (.Q(N_LDC), .D(1'b1), .C(CLOCK), .CE(1'b1), .PRE(1'b1));

/*	The following JP/EMU reset request strategy is
	from Chris Arcidiacano's "REDD" LRU FPGA.   Kent Costa
	has expressed some concern that the N_JP_RST_REQ might still
	create N_PROGRAM_OUT_GLOBAL_RESETs when we're in EMU mode
	(but it shouldn't!)

	If we EVER get an Emulator Reset Request, 'jp_req_disable' will disable
	any more JP Reset Requests (until you power off, of course!)

	Question: why is 'jp_req_disable' assigned "synchronously", but
	'n_global_reset_oe' is assigned "asynchronously"????
*/

always @ (posedge CLOCK)
	jp_req_disable <= #delay !N_EMU0_RST_REQ | !N_EMU1_RST_REQ | jp_req_disable;

assign n_global_reset_oe = jp_req_disable | N_JP_RST_REQ;
	// That's equivalent to "!(!jp_req_disable & !N_JP_RST_REQ)",
	// so you can see that the OE is enabled (active-low) when there's a
	// JP Reset Request and 'jp_req_disable' hasn't been set.

OFDT_F OFDT_GRST (.D(N_JP_RST_REQ), .C(CLOCK), .T(n_global_reset_oe),
	.O(N_PROGRAM_OUT_GLOBAL_RESET));
OFD_F OFD_JP0RST (.D(N_EMU0_RST_REQ), .C(CLOCK), .Q(N_JP0_RST));
OFD_F OFD_JP1RST (.D((N_EMU1_RST_REQ & n_jp1_rst_bit)), .C(CLOCK),
	.Q(N_JP1_RST));

// INTERNAL REGISTERS  ****************************************************

always @(posedge CLOCK)
begin
// DECODES:
	decode_word04 <= #delay (!pci_addr[15] & !pci_addr[8]
			& !pci_addr[5] & pci_addr[2] & pci_base_hit[0])
			| (pci_s_data & decode_word04);

	pci_ready <= #delay read_word04;

// Reads:
	if (read_word04)
		if (!pci_s_cbe[0])	// this is addr x04
			pci_adio_reg[7:0] <= #delay {n_jp1_rst_bit, N_BE_RAVEN_RST,
				!UART_RST, N_FE_EXP_RST, N_FE_RST_OUT, N_BE_RST_OUT,
				N_FE_MIRROR_RST, N_BE_MIRROR_RST};
		// Notice that the UART_RST is active high, but the value
		// that is read from (and written to) this register is active low,
		// so that's why we need to negate 'UART_RST' above.

// Writes:
	if (write_word04)
		if (!pci_s_cbe[0])	// this is addr x04
			{n_jp1_rst_bit, N_BE_RAVEN_RST, n_uart_rst_bit, N_FE_EXP_RST,
				N_FE_RST_OUT, N_BE_RST_OUT, N_FE_MIRROR_RST,
				N_BE_MIRROR_RST} <= #delay pci_adio[7:0];
end

endmodule

