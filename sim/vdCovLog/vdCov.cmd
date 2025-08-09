verdiWindowResize -win $_vdCoverage_1 "318" "82" "900" "700"
gui_set_pref_value -category {coveragesetting} -key {geninfodumping} -value 1
gui_exclusion -set_force true
gui_assert_mode -mode flat
gui_class_mode -mode hier
gui_column_config -id   -list  covtblCcexList  -col  C  -show 
gui_column_config -id   -list  covtblCcexList  -col  C  -on   -show 
gui_column_config -id   -list  covtblCcexList  -col  X  -on   -show 
gui_excl_mgr_flat_list -on  0
gui_covdetail_select -id  CovDetail.1   -name   Line
verdiWindowWorkMode -win $_vdCoverage_1 -coverageAnalysis
gui_open_cov  -hier mem_cov4.vdb -testdir {} -test {mem_cov4/test} -merge MergedTest -db_max_tests 10 -fsm transition
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
gui_list_select -id CoverageTable.1 -list covtblFGroupsList { /pkg::sb::apb_cg   }
gui_list_expand -id  CoverageTable.1   -list {covtblFGroupsList} /pkg::sb::apb_cg
gui_list_expand -id CoverageTable.1   /pkg::sb::apb_cg
gui_list_action -id  CoverageTable.1 -list {covtblFGroupsList} /pkg::sb::apb_cg  -column {Group} 
gui_list_select -id CovDetail.1 -list covergroup { pkg::sb::apb_cg.PADDR  pkg::sb::apb_cg.PENABLE   } -type { {Cover Group} {Cover Group}  }
gui_list_action -id  CovDetail.1 -list {covergroup} pkg::sb::apb_cg.PENABLE  -type {Cover Group}
vdCovExit -noprompt
