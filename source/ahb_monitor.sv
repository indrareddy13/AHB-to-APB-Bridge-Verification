class ahb_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_monitor)

	virtual bridge_if vif;
	ahb_agt_config ahb_cfg;

	uvm_analysis_port #(ahb_xtn) ahb_monitor_port;
	
	extern function new(string name="ahb_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

function ahb_monitor::new(string name="ahb_monitor",uvm_component parent);
	super.new(name,parent);
	ahb_monitor_port=new("ahb_monitor_port",this);
endfunction

function void ahb_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(ahb_agt_config)::get(this,"","ahb_agt_config",ahb_cfg))
		`uvm_fatal("CONFIG","Failed to get config into Monitor")
endfunction

function void ahb_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=ahb_cfg.vif;
endfunction

task ahb_monitor::run_phase(uvm_phase phase);
	super.run_phase(phase);
	@(vif.ahb_mon_cb);
	
	forever begin
		collect_data();
	end
endtask

task ahb_monitor::collect_data();
	ahb_xtn xtn;
	xtn=ahb_xtn::type_id::create("xtn");
	
	//@(vif.ahb_mon_cb);
	
	while(vif.ahb_mon_cb.Hreadyout==0)
		@(vif.ahb_mon_cb);

	while(vif.ahb_mon_cb.Htrans!==2'b10 && vif.ahb_mon_cb.Htrans!==2'b11)
		@(vif.ahb_mon_cb);
	
	xtn.Haddr=vif.ahb_mon_cb.Haddr;
	xtn.Hsize=vif.ahb_mon_cb.Hsize;
	xtn.Htrans=vif.ahb_mon_cb.Htrans;
	xtn.Hwrite=vif.ahb_mon_cb.Hwrite;	
	xtn.Hreadyin=vif.ahb_mon_cb.Hreadyin;

	@(vif.ahb_mon_cb);

	while(vif.ahb_mon_cb.Hreadyout==0)
		@(vif.ahb_mon_cb);

	if(xtn.Hwrite)
		xtn.Hwdata=vif.ahb_mon_cb.Hwdata;
	else
		xtn.Hrdata=vif.ahb_mon_cb.Hrdata;
	
	`uvm_info("AHB MONITOR",$sformatf("Printing from AHB MONITOR \n %s",xtn.sprint()),UVM_LOW)

	ahb_monitor_port.write(xtn);
endtask
