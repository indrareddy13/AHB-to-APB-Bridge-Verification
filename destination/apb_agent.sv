class apb_agent extends uvm_agent;
	`uvm_component_utils(apb_agent)

	apb_driver drvh;
	apb_sequencer seqr;
	apb_monitor monh;

	apb_agt_config apb_cfg;
	
	extern function new(string name="apb_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	//extern function void connect_phase(uvm_phase phase);
endclass

function apb_agent::new(string name="apb_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void apb_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(apb_agt_config)::get(this,"","apb_agt_config",apb_cfg))
		`uvm_fatal("CONFIG","Failed to get config in apb_agent")
	monh=apb_monitor::type_id::create("monh",this);
	if(apb_cfg.is_active==UVM_ACTIVE) begin
		drvh=apb_driver::type_id::create("drvh",this);
		seqr=apb_sequencer::type_id::create("seqr",this);
	end
endfunction

/*function void apb_agent::connect_phase(uvm_phase phase);
	if(apb_cfg.is_active==UVM_ACTIVE)
		drvh.seq_item_port.connect(seqr.seq_item_export);
endfunction*/
