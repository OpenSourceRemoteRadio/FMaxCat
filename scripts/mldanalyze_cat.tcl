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

set quartus_sta        [lindex $argv 0]
set prj_qpf            [lindex $argv 1]
set prj_qsf            [lindex $argv 2]

#
#GLOBAL VARIABLE


###############################################################################
# Extract Project Name 
###############################################################################

proc get_prj_name {prj_qpf} {
   set word_list [split $prj_qpf "/"]
   set prj_name [lindex $word_list end]
   set prj_name [string trimright $prj_name ".qpf"]
   return $prj_name
}

###############################################################################
# Extract Project Folder 
###############################################################################

proc get_prj_folder {prj_qpf} {
   # remove any space
   set prj_qpf_t [string trim $prj_qpf " "]
   # List
   set word_list [split $prj_qpf_t "/"]
   #Deleting the last from the list
   set prj_folder [lreplace $word_list end end]
   #Insert / 
   set prj_folder [join $prj_folder "/"] 
   return $prj_folder
}

###############################################################################
# Extract QSF Name 
###############################################################################

proc get_qsf_name {prj_qsf} {
   set word_list [split $prj_qsf "/"]
   set prj_qsf_name [lindex $word_list end]
   set prj_qsf_name [string trimright $prj_qsf_name ".qsf"]
   return $prj_qsf_name
}

###############################################################################
# To Get number of lines in a File 
###############################################################################
proc linecount {file} {
  set i 0
  set fid [open $file r]
  while {[gets $fid line] > -1} {incr i}
  close $fid
  return $i
}

###############################################################################
# To Get Fanout of a Src from Timing Report 
###############################################################################

proc get_src_fanout {rd_file} {
	set fp_rd_rpt [open $rd_file "r"]
	set data   [read $fp_rd_rpt]
	set data   [split $data "\n"]
	set flag_cnt 0
	set flag 0
	set fanout 5555
	 foreach line1 $data {
	     if {$flag_cnt == 1} {
	        set word_list [split $line1 ";"]
		set word [lindex $word_list 5]
	        set fanout $word	
		#set flag 0
		#set flag_cnt 0
            }
	     if {$flag == 1} {
		set flag_cnt [expr {$flag_cnt + 1}]
	     }

	     if {[string first "data path" $line1] == -1} {
	     } else {
	       set flag 1
	     }
	 }
	 close $fp_rd_rpt
	 return $fanout	

}

###############################################################################
# Extract MLD NAME 
###############################################################################
proc get_mld_name {line} {

#set data [split $line " "]
set data  [regexp -all -inline {\S+} $line]
puts $data
set data [lindex $data 3]
return $data

}

###############################################################################
# Extract src NAME 
###############################################################################
proc get_src_name {line} {

#set data [split $line " "]
set data  [regexp -all -inline {\S+} $line]
set data [lindex $data 5]
return $data

}

###############################################################################
#  Check MLD Exists 
###############################################################################
proc chk_mld_exist {mld_name rpt_dest_full} {
	set mld [concat "\*$mld_name\*"]
        set rpt_fail [report_timing -from $mld -to * -setup -npaths 1 -detail full_path -panel_name {Report Timing} -file $rpt_dest_full]
        #set rpt_fail [report_timing -from $mld -to * -setup -npaths 1 -detail full_path -panel_name {Report Timing}]
	puts "RPT_FAIL"
	puts $mld_name
	set rpt_fail [split $rpt_fail " "]
	set rpt_fail [lindex $rpt_fail 0]
	puts $rpt_fail
	return $rpt_fail
}
###############################################################################
# GET FANOUT 
###############################################################################
proc get_fanout {src_name rpt_dest} {
	puts $src_name
	set src_name [string trim $src_name "\""]
	puts $src_name
        report_timing -from $src_name -to * -setup -npaths 1 -detail full_path -panel_name {Report Timing} -file $rpt_dest
	after 1000 
	set fanout [get_src_fanout $rpt_dest]
	return $fanout

}
###############################################################################
# MAX FANOUT 
###############################################################################
proc get_max_fanout {fanout} {
	if {$fanout > 50} {
		return 10
	} elseif {$fanout > 10 } {
		return 5
	} else {
		return 1
	}
}

###############################################################################
# GEN MAX FANOUT 
###############################################################################
proc gen_max_fanout {rpt_fanout src_name max_fanout } {
	set fp_wr_rpt [open $rpt_fanout "a"]

         set src_name [string trimright $src_name "\""]
         set src_name [string trimright $src_name "]"]
	 set src_name [string trimright $src_name "1234567890"]
	 set src_name [string trimright $src_name "\["]
	 set src_name [concat "$src_name\*"] 
	 set src_name [concat "$src_name\""] 

        if {$max_fanout == 5555} {
	puts $fp_wr_rpt "# set_instance_assignment -name MAX_FANOUT $max_fanout -to $src_name"
	} else {
	puts $fp_wr_rpt "set_instance_assignment -name MAX_FANOUT $max_fanout -to $src_name"
        }


	close $fp_wr_rpt
}

###############################################################################


set prj_name            [get_prj_name $prj_qpf] 
set prj_folder          [get_prj_folder $prj_qpf] 
set prj_qsf_name        [get_qsf_name $prj_qsf] 
set rpt_fanout          [concat \.\/Fmax_cat\/$prj_qsf_name\_fanout.qsf]
set rpt_mld             [concat \.\/Fmax_cat\/$prj_qsf_name\_mld.qsf]
set rpt_dest            "./Fmax_cat/T_dest.txt"
set rpt_dest_full       "./Fmax_cat/T_dest_full.txt"


###############################################################################
# Open Quartus Project  
###############################################################################
puts $prj_folder
puts $prj_qsf_name
cd $prj_folder 
#exec $quartus_sta -s
project_open -force $prj_qpf  -revision $prj_name 
create_timing_netlist -model slow

###############################################################################
# Open QSF FILE
###############################################################################

set fp_rpt_qsf [open $prj_qsf "r"]
set fp_rpt_mld [open $rpt_mld "w"]
set data       [read $fp_rpt_qsf]
set data       [split $data "\n"]
set dbg_cnt 0

set fp_wr_rpt [open $rpt_fanout "w"]
close $fp_wr_rpt

set arr_fanout(1) "TEST"
foreach line $data {

      set dbg_cnt [expr {$dbg_cnt + 1}] 

      if { [string length $line] > 0 } {
	puts $line
	 set line [string trimleft $line " "]
	 if {[string first "\#" $line] == -1} {
	     set mld_name  [get_mld_name $line]
	     set src_name  [get_src_name $line]
	     set mld_exist [chk_mld_exist $mld_name $rpt_dest_full]

             puts $mld_name

	     if {$mld_exist == 0} {
	         set fanout  [get_fanout $src_name $rpt_dest]
	         if {$fanout == 5555} {
	            set max_fanout $fanout
	            gen_max_fanout $rpt_fanout $src_name $max_fanout 
                 } else {
	            set max_fanout   [get_max_fanout $fanout]
	            gen_max_fanout $rpt_fanout $src_name $max_fanout 
                 }
	     } else {
		puts $fp_rpt_mld $line
	     }

	  } else {
		  puts "NO ACTION"
	  }

      }

      #if {$dbg_cnt == 34} {
      #	      break 
      #     }

}

close $fp_rpt_mld


# SORT FANOUT CONSTRAINTS

set fp_rd_rpt [open $rpt_fanout "r"]
set data      [read $fp_rd_rpt]
set data      [split $data "\n"]
set data      [lsort -unique $data]
close $fp_rd_rpt

set fp_wr_rpt [open $rpt_fanout "w"]

foreach line $data {
	puts $fp_wr_rpt $line
}


close $fp_wr_rpt

close $fp_rpt_qsf
project_close
