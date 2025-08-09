class env_config extends uvm_object;
	`uvm_object_utils(env_config)

	bit has_ahb_agent=1;
	bit has_apb_agent=1;
	bit has_scoreboard=1;
	bit has_v_sequencer=1;

	ahb_agt_config ahb_cfg;
	apb_agt_config apb_cfg;
	
	extern function new(string name="env_config");
endclass

function env_config::new(string name="env_config");
	super.new(name);
endfunction
