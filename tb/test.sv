class test extends uvm_test;
	`uvm_component_utils(test)
	
	env env_h;
	
	env_config env_cfg;
	ahb_agt_config ahb_cfg;
	apb_agt_config apb_cfg;

	bit has_ahb_agent=1;
	bit has_apb_agent=1;
	
	//ahb_seqs seqs;

	extern function new(string name="test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	//extern task run_phase(uvm_phase phase);
endclass

function test::new(string name="test",uvm_component parent);
	super.new(name,parent);
	//seqs=wrapping_transfer::type_id::create("seqs");
endfunction

function void test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	env_cfg=env_config::type_id::create("env_cfg");

	if(has_ahb_agent)
		ahb_cfg=ahb_agt_config::type_id::create("ahb_cfg");
	
	if(has_apb_agent)
		apb_cfg=apb_agt_config::type_id::create("apb_cfg");
	
	if(has_ahb_agent)begin
		if(!uvm_config_db#(virtual bridge_if)::get(this,"","bridge_if",ahb_cfg.vif))
			`uvm_fatal("INTERFACE CONFIG","Failed to get interface config")
		env_cfg.ahb_cfg=ahb_cfg;
	end
	
	if(has_apb_agent)begin
		if(!uvm_config_db#(virtual bridge_if)::get(this,"","bridge_if",apb_cfg.vif))
			`uvm_fatal("INTERFACE CONFIG","Failed to get interface config")
		env_cfg.apb_cfg=apb_cfg;
	end

	uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);
	env_h=env::type_id::create("env_h",this);
	
endfunction

function void test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology;
endfunction

/*task test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqs.start(env_h.ahb_top.ahb.seqr);
	phase.drop_objection(this);
endtask*/

// ***************************************************************************************

class single_test extends test;
	`uvm_component_utils(single_test)

	single_transfer seqs;

	extern function new(string name="single_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function single_test::new(string name="single_test",uvm_component parent);
	super.new(name,parent);
	seqs=single_transfer::type_id::create("seqs");
endfunction

function void single_test::build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction

task single_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqs.start(env_h.ahb_top.ahb.seqr);
	#55;
	phase.drop_objection(this);
endtask
// ***********************************************************************************
class increment_test extends test;
	`uvm_component_utils(increment_test)

	increment_transfer seqs;

	extern function new(string name="increment_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function increment_test::new(string name="increment_test",uvm_component parent);
	super.new(name,parent);
	seqs=increment_transfer::type_id::create("seqs");
endfunction

function void increment_test::build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction

task increment_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqs.start(env_h.ahb_top.ahb.seqr);
	#50;
	phase.drop_objection(this);
endtask

// ***********************************************************************************
class wrap_test extends test;
	`uvm_component_utils(wrap_test)

	wrapping_transfer seqs;

	extern function new(string name="wrap_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function wrap_test::new(string name="wrap_test",uvm_component parent);
	super.new(name,parent);
	seqs=wrapping_transfer::type_id::create("seqs");
endfunction

function void wrap_test::build_phase(uvm_phase phase);
	super.build_phase(phase);

endfunction

task wrap_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seqs.start(env_h.ahb_top.ahb.seqr);
	#50;
	phase.drop_objection(this);
endtask
