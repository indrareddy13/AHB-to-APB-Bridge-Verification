class ahb_xtn extends uvm_sequence_item;
	`uvm_object_utils(ahb_xtn)

	bit Hresetn;
	rand bit[31:0]Haddr;
	rand bit[31:0]Hwdata;
	rand bit[2:0]Hsize;
	rand bit[2:0]Hburst;
	rand bit [1:0]Htrans;
	rand bit Hwrite;

	rand bit[9:0]length;
	
	bit[31:0]Hrdata;
	bit Hresp;
	bit Hreadyin;
	bit Hreadyout;

	//constraints
	constraint ADDR {Haddr inside { [32'h8000_0000:32'h8000_03ff],
					[32'h8400_0000:32'h8400_03ff],
					[32'h8800_0000:32'h8800_03ff],
					[32'h8c00_0000:32'h8c00_03ff]};}

	constraint ALIGN {(Hsize==1)->(Haddr%2)==0;
				(Hsize==2)->(Haddr%4)==0;}

	constraint SIZE {Hsize inside{0,1,2};}

	constraint BOUNDARY {{Haddr%1024}+(length*(2**Hsize))<=1023;}

	constraint LENGTH {(Hburst==0)->length==1;
				(Hburst==2)->length==4;
				(Hburst==3)->length==4;
				(Hburst==4)->length==8;
				(Hburst==5)->length==8;
				(Hburst==6)->length==16;
				(Hburst==7)->length==16;}

	extern function new(string name="ahb_xtn");
	extern function void do_print(uvm_printer printer);
endclass

function ahb_xtn::new(string name="ahb_xtn");
	super.new(name);
endfunction

function void ahb_xtn::do_print (uvm_printer printer);
	printer.print_field("Haddr",this.Haddr,32,UVM_HEX);
	printer.print_field("Hwdata",this.Hwdata,32,UVM_HEX);
	printer.print_field("Hsize",this.Hsize,3,UVM_HEX);
	//printer.print_field("Hburst",this.Hburst,3,UVM_HEX);
	printer.print_field("Htrans",this.Htrans,2,UVM_HEX);
	printer.print_field("Hwrite",this.Hwrite,1,UVM_HEX);
	//printer.print_field("length",this.length,10,UVM_DEC);
	printer.print_field("Hrdata",this.Hrdata,32,UVM_HEX);
	//printer.print_field("Hresp",this.Hresp,1,UVM_BIN);
	//printer.print_field("Hreadyin",this.Hreadyin,1,UVM_BIN);
	//printer.print_field("Hreadyout",this.Hreadyout,1,UVM_BIN);
endfunction
