class ahb_agt_top extends uvm_env;
	`uvm_component_utils(ahb_agt_top)

	ahb_agent ahb;
	
	extern function new(string name="ahb_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

function ahb_agt_top::new(string name="ahb_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void ahb_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ahb=ahb_agent::type_id::create("ahb",this);
	
endfunction
