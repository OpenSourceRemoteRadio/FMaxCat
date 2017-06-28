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

###############################################################
#
# Prerequestists:
#
# Create a text file "file_list.txt" in the current directory 
#   with the list of project locations.
#
###############################################################

#set quartus_sta		"C:/altera/15.1/quartus/bin64/quartus_sta"
#set clk_name 		"u_a10_soc|iopll_dsp|outclk0"
#set file_count 2
set quartus_sta		[lindex $argv 0]	
set clk_name		[lindex $argv 1]
set file_count		[lindex $argv 2]
set seed_path           [lindex $argv 3]
set qpf_file_list       [lindex $argv 4]
set seed_count          [lindex $argv 5]
set hit_count           [lindex $argv 6]
###############################################################

#set curr_dir [pwd]
set curr_dir $seed_path 
set line_count 0

file mkdir Seed_Cat

################################################################
####### Procedure : To get the qpf name
################################################################

proc get_prj_name {prj_qpf} {
   set word_list [split $prj_qpf "/"]
   set prj_name [lindex $word_list end]
   set prj_name [string trimright $prj_name "qpf"]
   set prj_name [string trimright $prj_name "."]
   return $prj_name
}


proc get_folder_name {file_list prj_name} {
puts "in get folder folder loop...."
   set word_list [split $file_list "/"]
   puts "word list : $word_list"
   set file_name [lindex $word_list end]
   puts "file name : $file_name"
   set prj_folder [string trimright $prj_name $file_name]
   return $prj_folder
}



#### to count the number of lines in the file

#set infile [open "$curr_dir/input_prj_path.txt" r]
#while { [gets $infile line] >= 0 } {
#	set line_len [string length $line]
#    if ($line_len >= 0)
#	incr line_count
#}
#close $infile


#set file_count $line_count
puts "----------------------------------------------------------------------"
puts "No. of projects needs to be analyzed : $file_count"
puts "----------------------------------------------------------------------"


set outfile [open "$curr_dir/out_report.csv" "w+"]
set fp_rpt [open $qpf_file_list "r"]
set file_data [read $fp_rpt]
close $fp_rpt

set num 1
set data [split $file_data "\n"]
set data [string trimright $file_data "}"] 
set data [string trimleft $file_data "{"] 
set data [string map {"\\" "/"} $data]


foreach line $data { 
set prj_qpf $line
puts $prj_qpf
set prj_name [get_prj_name $prj_qpf]
puts "prj name : $prj_name" 
set result_dir [get_folder_name $prj_qpf $prj_name]
puts $clk_name
puts "result dir : $result_dir"

project_open -force $prj_qpf -revision $prj_name
create_timing_netlist -model slow
read_sdc
update_timing_netlist
report_timing -from_clock $clk_name -to_clock $clk_name -from * -to * -setup -npaths 50000 -less_than_slack 0 -detail full_path -panel_name {Report Timing} -file "$curr_dir/Seed_Cat/${prj_name}_timing_report_$num.txt" -multi_corner


set domain_list [get_clock_fmax_info]
set domain_list [split $domain_list "{}"]

foreach domain $domain_list {
	set name [lindex $domain 0]
	set fmax [lindex $domain 1]
	set restricted_fmax [lindex $domain 2]
	set new_var [string match $clk_name $name]
	if { $new_var == 1} {
		set targeted_clk $name
		set targeted_fmax $fmax
	}
}

project_close


set fp [open "$curr_dir/Seed_Cat/${prj_name}_timing_report_$num.txt" "r"]
set count 0
while {[gets $fp in]!=-1} {
    incr count
    if {$count==4} {
            break
    }
}
close $fp

#puts "Required Line : $in"
set result [split $in "("]
#puts $result
set result [lindex $result 1]
set result [split $result ")"]
#puts $result
set result [lindex $result 0]
puts $result
#puts "Required word(s) : $result"
#puts "targeted clk name : $targeted_clk"
#puts "targeted fmax : $targeted_fmax"

puts $outfile "$prj_qpf, $targeted_clk, $targeted_fmax, $result"
set num [expr {$num + 1}]
puts "Current num value is: $num"
}

close $outfile

#######
puts "----------------------------------------------------------------------"
puts "All setup Timing reports has been generated successfully....."
#puts "check out_report.csv for fmax summary & Violations"
puts "----------------------------------------------------------------------"
#####################################################################################################################


#file mkdir files_out
set n 1
#puts $n
set sorted_source_nodes "$curr_dir/Seed_Cat/source_out_file_mul.txt"
set fp_rpt_src [open $sorted_source_nodes "w+"]
set sorted_src [open "$curr_dir/Seed_Cat/sorted_source.txt" "w"]


while {$n <= $file_count} {
	#puts $n
	try {
	    set input_file [open "$curr_dir/Seed_Cat/${prj_name}_timing_report_$n.txt" "r"]
	} trap {POSIX EISDIR} {} {
	    puts "failed to open seed$n.txt: its a directory"
	    incr n
	    continue
	} trap {POSIX ENOENT} {} {
	    puts "failed to open seed$n.txt: it doesnt exist"
	    incr n
	    continue
	}
	set file_out [open "$curr_dir/Seed_Cat/temp_file_$n.txt" "w+"]
	set input_file_data [read $input_file]
	close $input_file
	
	
	#### To extract the source node alone
	
	set line_cnt 0
	set sum_data_spt [split $input_file_data "\n"]
	
	# Finding the start Point
	foreach line $sum_data_spt {
	    set line_cnt [expr {$line_cnt + 1}]
	  if {[string first Slack $line] == -1} {
	  } else {
	    break
	  }
	}
	
	set start_val [expr {$line_cnt + 1}] 
	set line_cnt 0
	set word_cnt 0
	
	# Writing Source Node
	foreach line $sum_data_spt {
	  set line_cnt [expr {$line_cnt + 1}]
	  if {$line_cnt > $start_val}  {
	     if {[string first "------------" $line] == -1} {
	     } else {
	       break
	     }
	    set word_list [split $line ";"]
	    set word [lindex $word_list 2]
	    set word [string trim $word " "]
	    set word [string trimright $word "DUPLICATE"]
	    set word [string trimright $word "DUPLICATE"]
	    set word [string trimright $word "~"]
	    set word [string trimright $word "]"]
	    set word [string trimright $word "1234567890"]
	    set word [string trimright $word "\["]
	    set word [string trimright $word "]"]
	    set word [string trimright $word "1234567890"]
	    set word [string trimright $word "\["]
	    puts $fp_rpt_src $word
	    puts $file_out $word
	
	  }
	}
	close $file_out
	incr n
}
#puts "first while loop ended"

close $fp_rpt_src

###############################################################
# Creating a sorted file
###############################################################
set read_out [open "$curr_dir/Seed_Cat/source_out_file_mul.txt" "r"]
set read_out_data [read $read_out]
close $read_out

set words [split $read_out_data "\n"]
set word_new [lsort -unique $words]
foreach line $word_new {

puts $sorted_src $line
}
close $sorted_src
#puts "sorted file created"

#################################
#to find the no of source nodes
#################################

proc no_dest_path {src rd_file} {
	try {
            set fp_rd_file [open $rd_file "r"]
	} trap {POSIX EISDIR} {} {
	    puts "failed to open $rd_file:  its a directory"
	    return 0
	} trap {POSIX ENOENT} {} {
	    puts "failed to open $rd_file: it doesnt exist"
	    return 0
	}
     set dest_data  [read $fp_rd_file]
     set dest_data  [split $dest_data "\n"]
     set dest_cnt 0

     foreach line $dest_data {
	 if {[string first $src $line] == -1} {
	 } else {
	   set dest_cnt [ expr {$dest_cnt + 1}]
	 }
     }
     close $fp_rd_file
     return $dest_cnt
}







set x 1
#set final [open "$curr_dir/Seed_Cat/final_report.csv" "w+"]
set final [open "$curr_dir/Detailed_Violation_Report.csv" "w+"]
set all_violations [open "$curr_dir/All_Violations.txt" "w+"]
set common_violations [open "$curr_dir/Common_Violations.txt" "w+"]
set tmp_sorted [open "$curr_dir/Seed_Cat/sorted_source.txt" "r"]

set tmp_sorted_data [read $tmp_sorted]

set temp_first_line "Common Source_Nodes"
for {set d 1} {$d <= $file_count} {incr d} {
puts "d value : $d"
set temp_data "Build_$d"
set temp_first_line "$temp_first_line,$temp_data"
}
puts $final $temp_first_line


foreach line $tmp_sorted_data {
	set seed_hit ""
	#set flag 0
	set seed_hit_count 0
	set num_hits 0

	for {set i 1} {$i <= $file_count} {incr i} {
	        set {val_$i} 0 
                set tmp_file "$curr_dir/Seed_Cat/temp_file_$i.txt"
		set temp_dest_cnt [no_dest_path $line $tmp_file]
	        set seed_hit "$seed_hit,$temp_dest_cnt"
		# To find the number of seeds the faiing path occurs
		if {$temp_dest_cnt > 0} {
		  set seed_hit_count [expr {$seed_hit_count + 1}]
		  # set flag 1
		 } 
		# TO store maximum number of failing paths
		if {$temp_dest_cnt > $num_hits} {
		   set num_hits $temp_dest_cnt
		}

          }
		puts $final "$line$seed_hit"
		puts $all_violations "$line"

		if {($seed_hit_count >= $seed_count) || ($num_hits > $hit_count)} {
		
			    if {[string match {*\[*\]} $line] == 1} {
	                        set line [string trimright $line "]"]
	                        set line [string trimright $line "1234567890"]
	                        set line [string trimright $line "\["]
                              }
                           if {[string match {*\[*\]} $line] == 1} {
	                       set line [string trimright $line "]"]
              	               set line [string trimright $line "1234567890"]
                      	       set line [string trimright $line "\["]
                              }

	                      set line [string trimright $line "_"]

		puts $common_violations "$line"
		}

}

close $final
close $all_violations
close $common_violations
close $tmp_sorted


puts "----------------------------------------------------------------------"
puts " Final_Report.csv created successfully... "
puts "----------------------------------------------------------------------"


