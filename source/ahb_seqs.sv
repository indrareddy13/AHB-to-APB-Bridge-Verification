//ahb Sequence -> Base sequence

class ahb_seqs extends uvm_sequence #(ahb_xtn);
	`uvm_object_utils(ahb_seqs)

	//Following signals are using in increment or wrapping classes
	bit[2:0]hsize;
	bit[2:0]hburst;
	bit[31:0]haddr;
	bit[9:0]len;
	bit hwrite;

	//bit[1:0]htrans;

	extern function new(string name="ahb_seqs");
	//extern task body();
endclass

function ahb_seqs::new(string name="ahb_seqs");
	super.new(name);
endfunction

/*task ahb_seqs::body();
	begin
		req=ahb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		//`uvm_info("SOURCE_SEQUENCE - BASE SEQUENCE","Randomized data generated",UVM_LOW)
		//req.print;
		finish_item(req);
	end
endtask*/

// ************************************************************************************************************************************************************

// Single Transfer
class single_transfer extends ahb_seqs;
	`uvm_object_utils(single_transfer)

	extern function new(string name="single_transfer");
	extern task body();
endclass

function single_transfer::new(string name="single_transfer");
	super.new(name);
endfunction

task single_transfer::body();
	repeat(100) begin
		req=ahb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {Htrans==2'b10;});
		//`uvm_info("SOURCE_SEQUENCE - SINGLE TRANSFER","Randomized data generated",UVM_LOW)
		//req.print;
		finish_item(req);
	end
endtask

//Above code is for Single transfer, 1 byte jump and location will be random because Htrans = 2'b10, it means non sequential address / random address
// ************************************************************************************************************************************************************

// increment Transfer
class increment_transfer extends ahb_seqs;
	`uvm_object_utils(increment_transfer)

	extern function new(string name="increment_transfer");
	extern task body();
endclass

function increment_transfer::new(string name="increment_transfer");
	super.new(name);
endfunction

task increment_transfer::body();
	repeat(100) begin
		req=ahb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {Htrans==2'b10;
						Hburst inside{1,3,5,7};}); //To generate non sequence(Htrans==2'b10) & for increment transfers(Hburst inside{1,3,5,7})
		`uvm_info("SOURCE_SEQUENCE - INCREMENT TRANSFER","Randomized data generated",UVM_LOW)
		finish_item(req);

		haddr=req.Haddr;
		hsize=req.Hsize;
		hwrite=req.Hwrite;
		hburst=req.Hburst;
		len=req.length; //we are going to do randomization again so we need to preserve control signals and other except address signal. Because address signal sholud need to increments every time when we do randomization

		for(int i=1;i<len;i++)begin
			//req=ahb_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {Hsize==hsize;
							Hwrite==hwrite;
							Hburst==hburst;
							Htrans==2'b11;
							Haddr==haddr+(2**Hsize);}); //increment
			finish_item(req);			
			haddr=req.Haddr; //Haddr will be update everytime but remaining should be 0
		end

		//req.print;//To print
	end
endtask

//Increment will works as one by one jumps, Suppose location is 20, and 2 bytes then next location is 22, 24, 26 and so on depends on Hburst, length


// ************************************************************************************************************************************************************

// Wrapping Transfer
class wrapping_transfer extends ahb_seqs;
	`uvm_object_utils(wrapping_transfer)

	bit[31:0]starting_address;
	bit[31:0]boundary_address;

	extern function new(string name="wrapping_transfer");
	extern task body();
endclass

function wrapping_transfer::new(string name="wrapping_transfer");
	super.new(name);
endfunction

task wrapping_transfer::body();
	repeat(100) begin
		req=ahb_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {Htrans==2'b10;
						Hburst inside{2,4,6};});
		`uvm_info("SOURCE_SEQUENCE - WRAPPING TRANSFER","Randomized data generated",UVM_LOW)
		finish_item(req);
		
		haddr=req.Haddr;
		hsize=req.Hsize;
		hburst=req.Hsize;
		hwrite=req.Hwrite;
		len=req.length;

		//starting address
		starting_address=(haddr/((2**hsize)*len))*((2**hsize)*len);
		$display("Starting address = %0h",starting_address);

		//Boundary address
		boundary_address=starting_address+((2**hsize)*len);
		$display("Boundary address = %0h",boundary_address);
		
		//To wrapback to starting
		haddr=req.Haddr+(2**hsize);
		for(int i=1;i<len;i++)begin
			if(haddr>=boundary_address)
				haddr=starting_address;
			start_item(req);
			assert(req.randomize() with {Hsize==hsize;
							Hwrite==hwrite;
							Hburst==hburst;
							Htrans==2'b11;
							Haddr==haddr;});
			finish_item(req);
			
			haddr=req.Haddr+(2**hsize);
		end
		//req.print;
		
	end
endtask

//Wrapping needs to find both starting and boundary address, Initially it's Non sequential Htrans so it'll we a random address. Later it will increment upto boundary address and according to condition it'll wrap back.
// ************************************************************************************************************************************************************

