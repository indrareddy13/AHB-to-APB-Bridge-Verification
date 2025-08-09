module top;

    import uvm_pkg::*;
    import pkg::*;
    bit clk;

    // Generate the clock signal
    always #5 clk = ~clk;

    // Instantiate the interface
    bridge_if vif(clk);

    // DUT instantiation
    rtl_top DUT (
        .Hclk(vif.Hclk),
        .Hresetn(vif.Hresetn),
        .Htrans(vif.Htrans),
        .Hsize(vif.Hsize),
        .Hreadyin(vif.Hreadyin),
        .Hwdata(vif.Hwdata),
        .Haddr(vif.Haddr),
        .Hwrite(vif.Hwrite),
        .Prdata(vif.Prdata),
        .Hrdata(vif.Hrdata),
        .Hresp(vif.Hresp),
        .Hreadyout(vif.Hreadyout),
        .Pselx(vif.Pselx),
        .Pwrite(vif.Pwrite),
        .Penable(vif.Penable),
        .Paddr(vif.Paddr),
        .Pwdata(vif.Pwdata)
    );

    initial begin
	`ifdef VCS
	$fsdbDumpvars(0, top);
	`endif
        // Bind the virtual interface for UVM testbench
        uvm_config_db#(virtual bridge_if)::set(null, "*", "bridge_if", vif);
        
        // Start the UVM test
        run_test("test");
    end

endmodule

