class apb_seqs extends uvm_sequence #(apb_xtn);
	`uvm_object_utils(apb_seqs)

	extern function new(string name="apb_seqs");
endclass

function apb_seqs::new(string name="apb_seqs");
	super.new(name);
endfunction
