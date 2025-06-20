MODULE          = . /usr/share/Modules/init/sh; module load licenses/synopsys licenses/mentor-graphics licenses/cadence
VCS_MODULE      = tools/vcs/T-2022.06-SP2-9
VERDI_MODULE      = tools/verdi/T-2022.06-1


VCS        := vcs
VCS_FLAGS  := -sverilog -v2k_generate -timescale=1ps/1ps +lint=all,noVCDE -full64 -diag timescale +notimingchecks -debug_access+all -kdb
VCS_SIM_OPTION := +lint=all,noVCDE -diag timescale +fsdbfile+sim.fsdb +notimingcheck -gui=verdi

compile: 
	@mkdir -p sim
	cd sim && $(MODULE) $(VCS_MODULE) && $(VCS) $(VCS_FLAGS) $(VCS_DEFINE) -f ../logic/lab1.vc 2>&1 | tee vcs.log


VCS: compile
	@mkdir -p data
	cd sim && $(MODULE) $(VCS_MODULE) $(VERDI_MODULE) && ./simv $(VCS_SIM_OPTIONS) | tee ../data/DCO_$(process).log

VERDI:
	cd sim && $(MODULE) $(VCS_MODULE) $(VERDI_MODULE) && verdi -dbdir simv.daidir
