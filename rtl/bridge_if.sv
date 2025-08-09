interface bridge_if(input bit Hclk);

	bit Hresetn;
	bit [1:0] Htrans;
	bit [2:0] Hsize;
	bit Hreadyin;
	bit [31:0] Hwdata;
	bit [31:0] Haddr;
	bit Hwrite;
	bit [31:0] Prdata;

	bit [31:0] Hrdata;
	bit [1:0] Hresp;
	bit Hreadyout;
	logic [3:0] Pselx;
	logic Pwrite;
	logic Penable;
	logic [31:0] Paddr;
	logic [31:0] Pwdata;

	clocking ahb_drv_cb @(posedge Hclk);
	default input #1 output #1;
		input Hrdata;
		input Hresp;
		input Hreadyout;
		output Hresetn;
		output Hsize;
		output Hreadyin;
		output Hwdata;
		output Htrans;
		output Haddr;
		output Hwrite;
	endclocking

	clocking ahb_mon_cb @(posedge Hclk);
	default input #1 output #1;
		input Hrdata;
		input Hresp;
		input Hreadyout;
		input Hsize;
		input Hreadyin;
		input Hwdata;
		input Htrans;
		input Haddr;
		input Hwrite;
	endclocking
	
	clocking apb_drv_cb @(posedge Hclk);
	default input #1 output #1;
		input Pselx;
		input Pwrite;
		input Penable;
		input Paddr;
		input Pwdata;
		inout Prdata;
	endclocking 
	
	clocking apb_mon_cb @(posedge Hclk);
	default input #1 output #1;
		input Pselx;
		input Pwrite;
		input Penable;
		input Paddr;
		input Pwdata;
		input Prdata;
	endclocking 

	modport AHB_DRV_MP (clocking ahb_drv_cb);
	modport AHB_MON_MP (clocking ahb_mon_cb);
	modport APB_DRV_MP (clocking apb_drv_cb);
	modport APB_MON_MP (clocking apb_mon_cb);
endinterface
