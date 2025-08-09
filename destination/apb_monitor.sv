class apb_monitor extends ahb_monitor;
	`uvm_component_utils(apb_monitor)

	virtual bridge_if vif;
	apb_agt_config apb_cfg;	

	uvm_analysis_port #(apb_xtn) apb_monitor_port;

	extern function new(string name="apb_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

function apb_monitor::new(string name="apb_monitor",uvm_component parent);
	super.new(name,parent);
	apb_monitor_port=new("apb_monitor_port",this);
endfunction

function void apb_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(apb_agt_config)::get(this,"","apb_agt_config",apb_cfg))
		`uvm_fatal("CONFIG","Failed to get config into Monitor")
endfunction

function void apb_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=apb_cfg.vif;
endfunction

task apb_monitor::run_phase(uvm_phase phase);
	forever begin
		collect_data();
	end
endtask

task apb_monitor::collect_data();
	apb_xtn xtn;
	xtn=apb_xtn::type_id::create("xtn");

	while(vif.apb_mon_cb.Penable!==1)
		@(vif.apb_mon_cb);
	xtn.Paddr=vif.apb_mon_cb.Paddr;
	xtn.Pselx=vif.apb_mon_cb.Pselx;
	xtn.Pwrite=vif.apb_mon_cb.Pwrite;
	xtn.Penable=vif.apb_mon_cb.Penable;

	if(xtn.Pwrite)
		xtn.Pwdata=vif.apb_mon_cb.Pwdata;
	else
		xtn.Prdata=vif.apb_mon_cb.Prdata;
	`uvm_info("APB Monitor",$sformatf("Printing from APB Monitor \n %s",xtn.sprint()),UVM_LOW)

	repeat(1)
		@(vif.apb_mon_cb);
	
	apb_monitor_port.write(xtn);
endtask
