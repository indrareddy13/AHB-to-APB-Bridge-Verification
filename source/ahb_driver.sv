class ahb_driver extends uvm_driver #(ahb_xtn);
	`uvm_component_utils(ahb_driver)

	virtual bridge_if vif;
	ahb_agt_config ahb_cfg;
	
	ahb_xtn xtn;

	extern function new(string name="ahb_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive_item(ahb_xtn xtn);
endclass

function ahb_driver::new(string name="ahb_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void ahb_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(ahb_agt_config)::get(this,"","ahb_agt_config",ahb_cfg))
		`uvm_fatal("CONFIG","Failed to get config into driver")
endfunction

function void ahb_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=ahb_cfg.vif;
endfunction

task ahb_driver::run_phase(uvm_phase phase);
//	super.run_phase(phase);
	//@(vif.ahb_drv_cb);
	vif.ahb_drv_cb.Hresetn<=0;
	@(vif.ahb_drv_cb);
	vif.ahb_drv_cb.Hresetn<=1;
	@(vif.ahb_drv_cb);
	//while(1) begin
	forever begin
		seq_item_port.get_next_item(xtn);
		drive_item(xtn);
		seq_item_port.item_done();
	end
endtask

task ahb_driver::drive_item(ahb_xtn xtn);
	

	while(vif.ahb_drv_cb.Hreadyout!==1)
		@(vif.ahb_drv_cb);

	vif.ahb_drv_cb.Haddr<=xtn.Haddr;
	vif.ahb_drv_cb.Hsize<=xtn.Hsize;
	vif.ahb_drv_cb.Htrans<=xtn.Htrans;
	vif.ahb_drv_cb.Hwrite<=xtn.Hwrite;

	vif.ahb_drv_cb.Hreadyin<=1'b1;

	@(vif.ahb_drv_cb);

	while(vif.ahb_drv_cb.Hreadyout==0)
		@(vif.ahb_drv_cb);

	if(xtn.Hwrite)
		vif.ahb_drv_cb.Hwdata<=xtn.Hwdata;
	else
		vif.ahb_drv_cb.Hwdata<=32'b0;
	
	//$display("Data sent into Vif Successfully");
	/*repeat(1)
		@(vif.ahb_drv_cb);*/
	`uvm_info("AHB DRIVER",$sformatf("Printing from AHB Driver \n %s",xtn.sprint()),UVM_LOW)
endtask
