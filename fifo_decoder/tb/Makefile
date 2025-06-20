MODULE = . /usr/share/Modules/init/sh; module use /usr/cots/modulefiles; module load licenses/cadence;
XCELIUM_MODULE   = tools/xcelium/23.03
VERISIUM_MODULE   = tools/verisium/23.03
VERDI_MODULE  = tools/verdi/T-2022.06-1

export VERISIUM_DEBUG_ROOT=/usr/cots/cadence/VERISIUMDEBUG2303
compile:
	$(MODULE) $(XCELIUM_MODULE) && xrun -sv -lwdgen -access r -input probe.tcl -gui -verisium +incdir+/h/gfaech01/EE25_Veerilog/fifo_decoder/tb -top tb ./tb.sv -l ./simulation.log
debug:
	$(MODULE) $(XCELIUM_MODULE) $(VERISIUM_MODULE) && verisium -lwd ./xcelium.d/worklib/tb/sv/debug_db/tb/tb.dsn &
