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

# Parameter Settings
#$quartus_sta $prj_qpf $level $sdc_dest_thrsh $clk_name $block_name
if { $argc != 7 } {
	puts "Arguments to Fmax_Cat_SDC.tcl are less than 7"
	puts "Terminating Fmac Cat SDC tool"
	exit 1
}

###############################################################################
# USER INPUTS
###############################################################################
set quartus_sta        [lindex $argv 0]
set prj_qpf            [lindex $argv 1]
# BLOCK / CHIP
#set level              [lindex $argv 2]  

set level  "BLOCK" 

set sdc_dest_thrsh     [lindex $argv 2] 
set clk_name 	       [lindex $argv 3]


# For CHIP, Specifiy the Key word of the block 
set sdc_file           [lindex $argv 4]
#set  block_name       seed_analyze.sdc
set violations_file    [lindex $argv 5]
set common_violations_file [lindex $argv 6]

#set grp_thrsh          5 

#if { [info exists $clk_name] } {
#} else {
#	set clk_name
#}

proc mcsplit "str splitStr {mc {\x00}}" {
    return [split [string map [list $splitStr $mc] $str] $mc]
}


###############################################################################
# Get Project Name 
###############################################################################

proc get_prj_name {prj_qpf} {
   set word_list [split $prj_qpf "/"]
   set prj_name [lindex $word_list end]
   set prj_name [string trimright $prj_name ".qpf"]
   return $prj_name
}

###############################################################################
# Get Project Folder 
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
# List of Files 
###############################################################################

set prj_name         [get_prj_name $prj_qpf] 
set prj_folder       [get_prj_folder $prj_qpf] 
#set rpt_sdc          [concat \.\/Fmax_cat\/$prj_name\_$block_name\.sdc]
set rpt_sdc          $sdc_file 

set rpt_sum           "./Fmax_cat/T_summary.txt"
set rpt_src           "./Fmax_cat/T_src.txt"
set rpt_src_uniq      "./Fmax_cat/T_src_uniq.txt"
set rpt_src_dup       "./Fmax_cat/T_src_dup.txt"
set rpt_src_dest      "./Fmax_cat/T_src_dest.txt"
set rpt_dest          "./Fmax_cat/T_dest.txt"
set rpt_dest_uniq     "./Fmax_cat/T_dest_uniq.txt"
set rpt_dest_full     "./Fmax_cat/T_dest_full.txt"
set rpt_sdc_tmp       "./Fmax_cat/T_sdc_tmp.txt"
set rpt_sdc_mem       "./Fmax_cat/T_sdc_mem.txt"

###############################################################################
# To Get Current TIme
###############################################################################
proc get_time {} {

set t [clock milliseconds]
set timestamp [format "%s" \
                  [clock format [expr {$t / 1000}] -format %T] \
              ]
return $timestamp
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
#to find the no of source nodes
###############################################################################

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

###############################################################################
# To Remove characters/strings   
###############################################################################
proc remove_string {word} {
	 set word [string trimright $word " "]
   # MPDSP 
   # |Mult<Digit>~macreg<digit>
   if {[string match {*|Mult*macreg*} $word] == 1} {
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "~macreg"]
	 set word [string trimright $word "1234567890"]
   }
   # EC
   # altsyncram1|ram_block2a<digit>~reg<digit>
   if {[string match {*altsyncram*|ram_block2*} $word] == 1} {
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "~reg"]
	 set word [string trimright $word "1234567890"]
   }
   # MEM 
   # altsyncram1|lutrama<digit>~reg<digit>
   if {[string match {*altsyncram*|lutrama*} $word] == 1} {
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "~reg"]
	 set word [string trimright $word "1234567890"]
   }

   if {[string match {*|Mult*8reg*} $word] == 1} {
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "~8reg"]
	 set word [string trimright $word "1234567890"]
   }
   if {[string match {*ram_block*reg*} $word] == 1} {
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "~reg"]
	 set word [string trimright $word "1234567890"]
   }

         set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]
         set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]

	 return $word
}

###############################################################################
# Generation of Block Level QSF file (DUPLICATE ATOM Constraint) 
###############################################################################

proc creating_sdc {src rpt_dest rpt_dest_uniq fp_rpt_sdc_tmp \
	           grp_thrsh src_cnt quartus_sta prj_qpf rpt_dest_full prj_name block_name type sdc_type} {

	puts $fp_rpt_sdc_tmp "set_max_delay -to \[get_keepers \"*$src*\"\]  1.7"
}
###############################################################################
# Project Start Time
###############################################################################

set st_time [get_time ]

################################################################################
# Read Project File
################################################################################

cd $prj_folder 
project_open -force $prj_qpf  -revision $prj_name 
create_timing_netlist -model slow
read_sdc

set fp_rpt_sdc_tmp       [open $rpt_sdc_tmp "w"]

for {set j 0} {$j < 2} {incr j} {

if { $j == 0} {
   set src_type "sdc_src"
} else {
   set src_type "sdc_dest"
}

for {set i 0} {$i < 3} {incr i} {

if { $i == 0} {
   set sdc_type "MPDSP"
} elseif {$i == 1} {
   set sdc_type "EC"
} else {
   set sdc_type "MEM"
}

if { $sdc_type == "MPDSP"} {
set type              "*Mult*"
} elseif { $sdc_type == "EC"}  {
set type              "*ram_block*"
} elseif { $sdc_type == "MEM"}  {
set type              "*altsyncram*lutrama*"
}

################################################################################
# Report All Registers with Source and Desintation Nodes 
# Number of paths per endpoint [10]
################################################################################

if {$level == "CHIP"} {
	if {$src_type == "sdc_dest"} {
             #report_timing -from_clock  $clk_name  -to_clock  $clk_name  -from "\*$block_name\*" -to $type -setup -npaths 200000 -detail summary -panel_name {Report Timing} -file $rpt_sum 
             report_timing -from_clock  $clk_name  -to_clock  $clk_name  -from "*" -to $type -setup -npaths 200000 -detail summary -panel_name {Report Timing} -file $rpt_sum 
        } else {
             #report_timing -from_clock  $clk_name  -to_clock  $clk_name  -from  $type  -to "\*$block_name\*" -setup -npaths 200000 -detail summary -panel_name {Report Timing} -file $rpt_sum 
             report_timing -from_clock  $clk_name  -to_clock  $clk_name  -from  $type  -to "*" -setup -npaths 200000 -detail summary -panel_name {Report Timing} -file $rpt_sum 
	}
} else {
	if {$src_type == "sdc_dest"} {
            report_timing -from_clock  $clk_name  -to_clock  $clk_name  -from * -to $type -setup -npaths 200000 -detail summary -panel_name {Report Timing} -file $rpt_sum 
        } else {
            report_timing -from_clock  $clk_name  -to_clock  $clk_name  -from $type -to * -setup -npaths 200000 -detail summary -panel_name {Report Timing} -file $rpt_sum 
	}
}



################################################################################
#  Extracting Source/Destination Node 
################################################################################
set fp_rpt_sum [open $rpt_sum "r"]
set fp_rpt_src [open $rpt_src "w"]

set sum_data [read $fp_rpt_sum]

close $fp_rpt_sum

set line_cnt 0
set sum_data_spt [split $sum_data "\n"]

# Finding the start Point
foreach line $sum_data_spt {
   if { [string length $line] > 0 } {
      set line_cnt [expr {$line_cnt + 1}]
      if {[string first Slack $line] == -1} {
      } else {
        break
      }
   }
}

set start_val $line_cnt
set line_cnt 0
set word_cnt 0
# Writing Source Node
foreach line $sum_data_spt {
   if { [string length $line] > 0 } {
       set line_cnt [expr {$line_cnt + 1}]
       if {$line_cnt > $start_val} {
          set word_list [split $line ";"]

	  if {$src_type == "sdc_dest"} {
             #if { $sdc_type == "MPDSP"} {
             set word [lindex $word_list 2]
             #} else {
             #set word [lindex $word_list 3]
	     #}
          } else {
             #if { $sdc_type == "MPDSP"} {
             set word [lindex $word_list 3]
             #} else {
             #set word [lindex $word_list 2]
	     #}
          }

          set word [string trim $word " "]
          set line [string trimright $line "~DUPLICATE"]
	  #set word [remove_string $word ]
          puts $fp_rpt_src $word
       }
   }
}
close $fp_rpt_src

################################################################################
# Removing Duplicate Node
################################################################################

set fp_rpt_src [open $rpt_src "r"]
set fp_rpt_src_uniq [open $rpt_src_uniq "w"]

set src_data [read $fp_rpt_src]
close $fp_rpt_src

set src_data_spt [split $src_data "\n"]
set src_data_spt [lsort $src_data_spt]
set flag 0
set count 0
#set src_data_uniq [lsort -unique $src_data_spt]
set duplicate_line ""
foreach line $src_data_spt {
   if { [string length $line] > 0 } {
    if {$flag == 1} {
      #set line [string trimright $line "~DUPLICATE"]
      if {$line == $duplicate_line} {
	      set count [expr {$count + 1}]
      } else {
         if {[string first "DUPLICATE" $duplicate_line] == -1} {
           puts $fp_rpt_src_uniq "$duplicate_line;$count"
         }
	 set duplicate_line $line
	 set count 1 
      }
    } else {
      set flag  1
      set count  1
      set duplicate_line $line
    }
   }
}

# To Write the Last Line
 if { [string length $duplicate_line] > 0 } {
  if {[string first "DUPLICATE" $duplicate_line] == -1} {
     puts $fp_rpt_src_uniq "$duplicate_line;$count"
  }
  }

close $fp_rpt_src_uniq

################################################################################
# Total Number of Source Node 
################################################################################

set T_src_node [linecount $rpt_src_uniq]



################################################################################
# Check the number of endpoints per source node and generate duplicate atom   
################################################################################

set fp_rpt_src_uniq [open $rpt_src_uniq "r"]
set src_uniq_data [read $fp_rpt_src_uniq]
close $fp_rpt_src_uniq

set src_uniq_data_spt [split $src_uniq_data "\n"]

#set fp_rpt_src_dup [open $rpt_src_dup "w"] 
set src_cnt 0
set src_proc_cnt 0



 foreach line $src_uniq_data_spt {

  set src_cnt [expr {$src_cnt + 1}]
	 
   if { [string length $line] > 0 } {

    set src_proc_cnt [ expr {$src_proc_cnt + 1}]

    puts "Processing $src_proc_cnt / $T_src_node \n "

    set line [string trim $line " "]

    set word_list [split $line ";"]
    set src_node [lindex $word_list 0]

    set num_dest_path [lindex $word_list 1]
	
	  if {$num_dest_path > $sdc_dest_thrsh} {
	  puts "Updating SDC File"
	  puts $src_node
	  #regsub -all {(delayr[0-9]+)} $src_node "delayr*" src_node
	  #regsub -all {(redist[0-9]+)} $src_node "redist*" src_node
	  #regsub -all {(altera_syncram_....)} $src_node "altera_syncram*" src_node
	  #regsub -all {(altsyncram_....)} $src_node "altsyncram*" src_node
	  #regsub -all {(real)} $src_node "*" src_node
	  #regsub -all {(imag)} $src_node "*" src_node
	  #regsub -all {[0-9]+\|} $src_node "*" src_node
	  #regsub -all {[0-9]+:} $src_node "*" src_node
	  #regsub -all {[0-9]+_} $src_node "*" src_node

	  #set src_node [string map {"**" "*"} $src_node]

          #puts $src_node
	  #
	 set src_node [string trimright $src_node "]"]
	 set src_node [string trimright $src_node "1234567890"]
	 set src_node [string trimright $src_node "\["]
         set src_node [string trimright $src_node "]"]
	 set src_node [string trimright $src_node "1234567890"]
	 set src_node [string trimright $src_node "\["]
	  
	  # Remove Mult from SDC constraint.. string "Mult" is always followed by "~"

        if { [string length $src_node] > 0 } {
	 if {[string first "altsyncram" $src_node] == -1 && [string first "~" $src_node] == -1  &&  [string first "Mult" $src_node] == -1 } {	
	  if {$src_type == "sdc_dest"} {
	       puts $fp_rpt_sdc_tmp "set_max_delay -from \[get_keepers \"*$src_node*\"\]  1.7"
          } else {
	       puts $fp_rpt_sdc_tmp "set_max_delay -to \[get_keepers \"*$src_node*\"\]  1.7"
          }
         }
       }

     } 
   }
   #if {$src_cnt == 555} {
   #  	   break
   #}
  }

}

}

close $fp_rpt_sdc_tmp

set end_time [get_time ]
project_close

set fp_rpt_sdc_tmp  [open $rpt_sdc_tmp "r"]
set fp_rpt_mem_tmp  [open $rpt_sdc_mem "w"]

set sdc_data [read $fp_rpt_sdc_tmp]
set sdc_data [split $sdc_data "\n"]
set sdc_data [lsort -unique $sdc_data]

foreach line $sdc_data {
	puts $fp_rpt_mem_tmp $line
}

close $fp_rpt_sdc_tmp
close $fp_rpt_mem_tmp




set fp_rpt_sdc      [open $rpt_sdc "w"]
set fp_rpt_v        [open $violations_file "r"]

set v_src [read $fp_rpt_v]
set v_src [split $v_src "\n"]
set v_src [lsort -unique $v_src]


puts $fp_rpt_sdc "#MEMORY VIOLATIONS"

#set tmp [pwd]
#puts  $fp_rpt_sdc $tmp 
foreach line $v_src {

	set hit_value 0
	#set hit_value [no_dest_path $line $violations_file] 
	set hit_value [no_dest_path $line $rpt_sdc_mem] 

	if {$hit_value > 0} {
	set sdc_const [concat "set_max_delay \-from   \[get_keepers \"\*$line\*\"\] 1.7"] 
	puts $fp_rpt_sdc $sdc_const
       }
}


set fp_rpt_common_violations [open $common_violations_file "r"]
set common_violations_data [read $fp_rpt_common_violations]
set common_violations_data [split $common_violations_data  "\n"]
set common_violations_data [lsort -unique $common_violations_data]

puts $fp_rpt_sdc "#COMMON VIOLATIONS"

foreach line $common_violations_data {
	if { [string length $line] > 0} {
	set sdc_const [concat "set_max_delay \-from   \[get_keepers \"\*$line\*\"\] 1.7"] 
	puts $fp_rpt_sdc $sdc_const
        }
}


puts $fp_rpt_sdc "#END"



close $fp_rpt_sdc
close $fp_rpt_v


puts "\n Project Start Time $st_time Finish Time $end_time"
