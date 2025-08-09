class v_sequencer extends uvm_sequencer;
	`uvm_component_utils(v_sequencer)

		
	extern function new(string name="v_sequencer",uvm_component parent);
	//extern function void build_phase(uvm_phase phase);
endclass

function v_sequencer::new(string name="v_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction

/*function env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	
endfunction*/
