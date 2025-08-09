class sb extends uvm_scoreboard;
	`uvm_component_utils(sb)

	ahb_xtn ahb;
	apb_xtn apb;

	uvm_tlm_analysis_fifo #(ahb_xtn) ahb_fifo;
	uvm_tlm_analysis_fifo #(apb_xtn) apb_fifo;

	covergroup ahb_cg;
		HADDR:coverpoint ahb.Haddr {
					bins slave1={[32'h8000_0000:32'h8000_03ff]};
					bins slave2={[32'h8400_0000:32'h8400_03ff]};
					bins slave3={[32'h8800_0000:32'h8800_03ff]};
					bins slave4={[32'h8c00_0000:32'h8c00_03ff]}; }

		HTRANS:coverpoint ahb.Htrans {
					bins non_seq={2};
					bins seq={3}; }

		HSIZE:coverpoint ahb.Hsize {
					bins zero={0};
					bins one={1};
					bins two={2}; }

		HWRITE:coverpoint ahb.Hwrite {
					bins zero={0};
					bins one={1}; }

		AHB_CROSS:cross HADDR,HSIZE,HWRITE,HTRANS;
	endgroup

	covergroup apb_cg;
		PADDR:coverpoint apb.Paddr {
					bins slave1={[32'h8000_0000:32'h8000_03ff]};
					bins slave2={[32'h8400_0000:32'h8400_03ff]};
					bins slave3={[32'h8800_0000:32'h8800_03ff]};
					bins slave4={[32'h8c00_0000:32'h8c00_03ff]}; }

		PENABLE:coverpoint apb.Penable {
					bins zero={0};
					bins one={1}; }

		PSEL:coverpoint apb.Pselx {
					bins zero={4'b0001};
					bins one={4'b0010};
					bins two={4'b0100};
				       	bins three={4'b1000};	}

		PWRITE:coverpoint apb.Pwrite {
					bins zero={0};
					bins one={1}; }

		APB_CROSS:cross PADDR,PENABLE,PSEL,PWRITE;
	endgroup

	//Function new
	function new(string name="sb",uvm_component parent);
		super.new(name,parent);
		ahb_fifo=new("ahb_fifo",this);
		apb_fifo=new("apb_fifo",this);

		ahb_cg=new;
		apb_cg=new;
	endfunction

	//Run phase
	task run_phase(uvm_phase phase);
		forever begin
			fork
				begin
					ahb_fifo.get(ahb);
					ahb.print();
					ahb_cg.sample();
				end

				begin
					apb_fifo.get(apb);
					apb.print();
					apb_cg.sample();
				end
			join

			checking(ahb,apb);//Check method

		end
	endtask

	//compare method
	task compare(int Haddr,Paddr,Hdata,Pdata);
		//Address comparision
		if(Haddr==Paddr)
			$display("Address Compared Successfully");
		else
			$display("Address comparision failed");

		//Data Comparision
		if(Hdata==Pdata)
			$display("Data Compared Successfully");
		else
			$display("Data comparision failed");

	endtask

	//check method
	task checking(ahb_xtn ahb,apb_xtn apb);
		if(ahb.Hwrite)begin
			if(ahb.Hsize==0)begin
				if(ahb.Haddr[1:0]==2'b00)
					compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[7:0],apb.Pwdata);
				if(ahb.Haddr[1:0]==2'b01)
					compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:8],apb.Pwdata);
				if(ahb.Haddr[1:0]==2'b10)
					compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[23:16],apb.Pwdata);
				if(ahb.Haddr[1:0]==2'b11)
					compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:24],apb.Pwdata);
			end

			if(ahb.Hsize==1)begin
				if(ahb.Haddr[1:0]==2'b00)
					compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:0],apb.Pwdata);
				if(ahb.Haddr[1:0]==2'b10)
					compare(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:16],apb.Pwdata);
			end

			if(ahb.Hsize==2)
				compare(ahb.Haddr,apb.Paddr,ahb.Hwdata,apb.Pwdata);
			
		end

		if(ahb.Hwrite==0)begin
			if(ahb.Hsize==0)begin
				if(ahb.Haddr[1:0]==2'b00)
					compare(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata[7:0]);
				if(ahb.Haddr[1:0]==2'b01)
					compare(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata[15:8]);
				if(ahb.Haddr[1:0]==2'b10)
					compare(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata[23:16]);
				if(ahb.Haddr[1:0]==2'b11)
					compare(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata[31:24]);
			end

			if(ahb.Hsize==1)begin
				if(ahb.Haddr[1:0]==2'b00)
					compare(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata[15:0]);
				if(ahb.Haddr[1:0]==2'b10)
					compare(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata[31:16]);
			end

			if(ahb.Hsize==2)
				compare(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata);

		end

	endtask

endclass


