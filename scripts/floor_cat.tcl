 #################################################################################### 
#   
#  Copyright (c) 2017, BigCat Wireless Pvt Ltd
#  All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#  
#      * Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.
# 
#      * Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
# 
#      * Neither the name of the copyright holder nor the names of its contributors
#        may be used to endorse or promote products derived from this software
#        without specific prior written permission.
#  
#  
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#  
####################################################################################

#########################################################################################################
#### Input Parameters
#########################################################################################################

#set quartus_sta        "C:/altera/15.1/quartus/bin64/quartus_sta"
#set prj_qpf 		"E:/Local_kiln/Hepta_A10_8C8T8R/floor_cat.tcl/M_0000_0001_Base/a10_soc.qpf"

set quartus_sta		[lindex $argv 0]
set prj_qpf		[lindex $argv 1]
set csv_input		[lindex $argv 2]
#########################################################################################################

set curr_dir [pwd]

#########################################################################################################
#### to count the number of lines in the file
#########################################################################################################

set infile [open "$csv_input" r]
while { [gets $infile line] >= 0 } {
    incr line_count
}
close $infile

set num_lines $line_count
puts "----------------------------------------------------------------------"
puts "No. of nodes needs to be analyzed : $num_lines"
puts "----------------------------------------------------------------------"


#########################################################################################################
# Extract Project Name 
#########################################################################################################

proc get_prj_name {prj_qpf} {
   set word_list [split $prj_qpf "/"]
   set prj_name [lindex $word_list end]
   set prj_name [string trimright $prj_name ".qpf"]
   return $prj_name
}

set prj_name [get_prj_name $prj_qpf]
puts "prj_name : $prj_name"

set open_file [open "$curr_dir/FloorCat_input.csv" "r"]
set open_file_data [read $open_file]
close $open_file

set out_file [open "$curr_dir/FloorCat_out.qsf" "w"]
close $out_file

set count 1

project_open -force $prj_qpf -revision $prj_name
create_timing_netlist -model slow
read_sdc
update_timing_netlist

set data [split $open_file_data "\n"]
foreach line $data {
if {$count <= $num_lines} {
	set rpt_path_new ""
	set split_line [split $line ","]
	set fp_region [lindex $split_line 0]
	set array_len [llength $split_line]
	set count [expr {$count + 1}]
	for {set i 1} {$i < $array_len} {incr i} {
		set str_1 [lindex $split_line $i]
		set rpt_path_new [concat $rpt_path_new $str_1]
		}
	set rpt_path_new [string map {" "  "*:"} $rpt_path_new]
	set rpt_tmg_path [string trim $rpt_path_new " "]
	set rpt_tmg_path [concat "*:" $rpt_tmg_path "*"]
	set rpt_tmg_path [string map {" "  ""} $rpt_tmg_path]
	set key_word_new [split $rpt_tmg_path "*"]
	set key_word_new [string trim $key_word_new "{}"]
	set key_word [lindex $key_word_new end]


report_timing -from_clock { * } -to_clock { * } -from $rpt_tmg_path -to * -setup -npaths 1 -detail summary -panel_name {Report Timing Summary} -file "$curr_dir/timing_rpt.txt" -multi_corner


set fp [open "$curr_dir/timing_rpt.txt" "r"]
set cnt 0
while {[gets $fp in]!=-1} {
    incr cnt
    if {$cnt==6} {
            break
    }
}
close $fp
puts "------------------------------------------------------------------------------------------------------------------"
set len_req_key_word [string length $key_word]
set in [split $in ";"]
set in [lindex $in 2]
set d [string last $key_word $in]
set final_path_len [expr {$d + $len_req_key_word}]
set final_path [string range $in 0 $final_path_len-1]
set final_path [string trim $final_path " "]

set output_file [open "$curr_dir/FloorCat_out.qsf" "a+"]
puts $output_file "set_instance_assignment -name LL_MEMBER_OF $fp_region -to \"$final_path\" -section_id $fp_region"
puts "set_instance_assignment -name LL_MEMBER_OF $fp_region -to \"$final_path\" -section_id $fp_region"
puts "------------------------------------------------------------------------------------------------------------------"
close $output_file

}
}
project_close

