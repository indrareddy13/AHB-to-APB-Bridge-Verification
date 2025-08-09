class env extends uvm_env;
	`uvm_component_utils(env)

	ahb_agt_top ahb_top;
	apb_agt_top apb_top;

	sb sb_h;

	v_sequencer v_seqr;
	
	env_config env_cfg;
	
	extern function new(string name="env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function env::new(string name="env",uvm_component parent);
	super.new(name,parent);
endfunction

function void env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal("CONFIG","Failed to get config in env")
	
	if(env_cfg.has_ahb_agent)begin
		uvm_config_db#(ahb_agt_config)::set(this,"*","ahb_agt_config",env_cfg.ahb_cfg);
		ahb_top=ahb_agt_top::type_id::create("ahb_top",this);
	end

	if(env_cfg.has_apb_agent)begin
		uvm_config_db#(apb_agt_config)::set(this,"*","apb_agt_config",env_cfg.apb_cfg);
		apb_top=apb_agt_top::type_id::create("apb_top",this);
	end

	if(env_cfg.has_scoreboard)
		sb_h=sb::type_id::create("sb_h",this);

	if(env_cfg.has_v_sequencer)
		v_seqr=v_sequencer::type_id::create("v_seqr",this);
	
endfunction


function void env::connect_phase(uvm_phase phase);
	if(env_cfg.has_scoreboard) begin
		ahb_top.ahb.monh.ahb_monitor_port.connect(sb_h.ahb_fifo.analysis_export);
		apb_top.apb.monh.apb_monitor_port.connect(sb_h.apb_fifo.analysis_export);
	end
endfunction

