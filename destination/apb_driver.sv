class apb_driver extends uvm_driver #(apb_xtn);
	`uvm_component_utils(apb_driver)
	
	virtual bridge_if vif;
	apb_agt_config apb_cfg;

	apb_xtn xtn;
	
	extern function new(string name="apb_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(apb_xtn xtn);
endclass

function apb_driver::new(string name="apb_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void apb_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(apb_agt_config)::get(this,"","apb_agt_config",apb_cfg))
		`uvm_fatal("CONFIG","Failed to get config into driver")

	xtn=apb_xtn::type_id::create("xtn");
endfunction

function void apb_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=apb_cfg.vif;
endfunction

task apb_driver::run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		send_to_dut(xtn);
	end
endtask

task apb_driver::send_to_dut(apb_xtn xtn);

	
	while(vif.apb_drv_cb.Pselx==='h0 || vif.apb_drv_cb.Pselx=='hx)// || vif.apb_drv_cb.Pselx!==4 || vif.apb_drv_cb.Pselx!==8)
		@(vif.apb_drv_cb);
	
	xtn.Pwrite=vif.apb_drv_cb.Pwrite;

	if(vif.apb_drv_cb.Pwrite==0)
		vif.apb_drv_cb.Prdata<=$random; // use this alternative for following
		//$display(xtn.Prdata);
	/*if(vif.apb_drv_cb.Pwrite==0)
	begin
		while(vif.apb_drv_cb.Penable!==1)
			@(vif.apb_drv_cb);
		vif.apb_drv_cb.Prdata<=$random;*/

		//`uvm_info("APB DRIVER",$sformatf("Printing from APB Driver \n %s",xtn.sprint()),UVM_LOW)
	
	//xtn.print();
	//end

	xtn.Prdata=vif.apb_drv_cb.Prdata;
	//$display("in apb driver after randomization");
	`uvm_info("APB Driver",$sformatf("Printing from APB Driver \n %s",xtn.sprint()),UVM_LOW)
		
		repeat(2)
			@(vif.apb_drv_cb);


	
endtask
