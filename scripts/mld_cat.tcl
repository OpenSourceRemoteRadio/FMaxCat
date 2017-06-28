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
#$quartus_sta $prj_qpf $level $mld_dest_thrsh $grp_thrsh $clk_name $block_name
if { $argc != 7 } {
	puts "Arguments to Fmax_cat.tcl are less than 7"
	puts "Terminating Fmac Cat tool"
	exit 1
}
###############################################################################
# USER INPUTS
###############################################################################
set quartus_sta        [lindex $argv 0]
set prj_qpf            [lindex $argv 1]
# BLOCK / CHIP
set level              [lindex $argv 2] 

set mld_dest_thrsh     [lindex $argv 3] 
set grp_thrsh          [lindex $argv 4]
set clk_name   	       [lindex $argv 5]

# For CHIP, Specifiy the Key word of the block 
set block_name         [lindex $argv 6]

#if { [info exists $clk_name] } {
#} else {
#   set clk_name "*"
#}
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
# List of Files 
###############################################################################

set prj_name            [get_prj_name $prj_qpf] 
set prj_folder          [get_prj_folder $prj_qpf] 
set rpt_qsf             [concat \.\/Fmax_cat\/$prj_name\_$block_name\.qsf]
set rpt_sum           "./Fmax_cat/T_summary.txt"
set rpt_src           "./Fmax_cat/T_src.txt"
set rpt_src_uniq      "./Fmax_cat/T_src_uniq.txt"
set rpt_src_dup       "./Fmax_cat/T_src_dup.txt"
set rpt_src_dest      "./Fmax_cat/T_src_dest.txt"
set rpt_dest          "./Fmax_cat/T_dest.txt"
set rpt_dest_uniq_full     "./Fmax_cat/T_dest_uniq_full.txt"
set rpt_dest_uniq     "./Fmax_cat/T_dest_uniq.txt"
set rpt_dest_full     "./Fmax_cat/T_dest_full.txt"
#set cpright_file      "copyright.txt"

################################################################################
#   COPYRIGHT
################################################################################
proc add_altera_copyright {rpt_file} {

set fp_rpt [open $rpt_file "w"]

 puts $fp_rpt "#=============================================================================="
 puts $fp_rpt "#(c) 2010 Altera Corporation. All rights reserved.                             "
 puts $fp_rpt "#Altera products are protected under numerous U.S. and foreign patents,maskwork"
 puts $fp_rpt "#rights, copyrights and other intellectual property laws.                      "
 puts $fp_rpt "#                                                                              "
 puts $fp_rpt "#This reference design file, and your use thereof, is subject to and governed  "
 puts $fp_rpt "#by the terms and conditions of the applicable Altera Reference Design License "
 puts $fp_rpt "#Agreement (either as signed by you, agreed by you upon download or as a       "
 puts $fp_rpt "#\"click-through\" agreement upon installation andor found at www.altera.com). "
 puts $fp_rpt "#By using this reference design file, you indicate your acceptance of such terms"
 puts $fp_rpt "#and conditions between you and Altera Corporation.  In the event that you do  "
 puts $fp_rpt "#not agree with such terms and conditions, you may not use the reference design"
 puts $fp_rpt "#file and please promptly destroy any copies you have made.                    "
 puts $fp_rpt "#                                                                              "
 puts $fp_rpt "#This reference design file is being provided on an \"as-is\" basis and as an  "
 puts $fp_rpt "#accommodation and therefore all warranties, representations or guarantees of  "
 puts $fp_rpt "#any kind (whether express, implied or statutory) including, without limitation,"
 puts $fp_rpt "#warranties of merchantability, non-infringement, or fitness for a particular  "
 puts $fp_rpt "#purpose, are specifically disclaimed.  By making this reference design file   "
 puts $fp_rpt "#available, Altera expressly does not recommend, suggest or require that this  "
 puts $fp_rpt "#reference design file be used in combination with any other product not       "
 puts $fp_rpt "#provided by Altera.                                                           "
 puts $fp_rpt "#=============================================================================="

close $fp_rpt
}

################################################################################
#

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
# To Add Copyrights 
###############################################################################

proc add_copyright {rpt_file cpright_file} {
    # Add copyright info only when the copyright info available
    if {[file exists $fp_cpright] > 0} {
	set fp_rpt [open $rpt_file "w"]
	set fp_cpright [open $fp_cpright "r"]

	set data [read $fp_cpright]
	set data [split $data "\n"]

	foreach line $data {
	   set cp_data [concat \#$data]
	   puts $fp_rpt $cpright_data 
	}

	close $fp_rpt
	close $fp_cpright
    }
}


###############################################################################
# To Remove characters/strings   
###############################################################################
proc remove_string {word} {

	 set word [string trimright $word " "]
	 set word [string map {~DUPLICATE ""} $word]

#To Group |Mult1~mac|ena[2]
         set word [split $word "~"]
	 set word [lindex $word 0]

 
#reg0
#To Group altsyncram<digit>|lutrama<digit>|ena<digit>
 
    if {[string match {*|lutrama*|ena*} $word] == 1} {
	 set word [string trimright $word "1234567890"]
	 set word [string map {|ena ""} $word]
	 set word [string trimright $word "1234567890"]
	 set word [string map {|lutrama ""} $word]
	 set word [string trimright $word "1234567890"]
	 set word [string map {|altsyncram   ""} $word]
	 set word [string map {|auto_generated   ""} $word]
    }

#reg1
#To Group enaAnd_q[0]|dataa,b,c,d,e,f 
 
    if {[string match {*enaAnd_q*|data*} $word] == 1} {
	 set word [string map {|dataa ""} $word]
	 set word [string map {|datab ""} $word]
	 set word [string map {|datac ""} $word]
	 set word [string map {|datad ""} $word]
	 set word [string map {|datae ""} $word]
	 set word [string map {|dataf ""} $word]
	 set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]
    }
    if {[string match {*enaAnd_q*|combout*} $word] == 1} {
	 set word [string map {|combout ""} $word]
	 set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]
    }

#To Group sticky_ena_q[0]~0|datac
    if {[string match {*sticky_ena_q*|data*} $word] == 1} {
	 set word [string map {|dataa ""} $word]
	 set word [string map {|datab ""} $word]
	 set word [string map {|datac ""} $word]
	 set word [string map {|datad ""} $word]
	 set word [string map {|datae ""} $word]
	 set word [string map {|dataf ""} $word]
	 set word [string map {~0 ""} $word]
	 set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]
    }

#To Group delay_signals[2][2]|ena
 
    if {[string match {*delay_signals\[*\]\[*\]|ena} $word] == 1} {
	 set word [string map {|ena ""} $word]

	 set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]

	 set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]
	 set word [string map {delay_signals ""} $word]
    }


#To Group |lutrama<digit>|portaddr[<digit>]
 
    if {[string match {*|lutrama*|portaaddr\[*\]} $word] == 1} {

	 set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]

	 set word [string map {|portaaddr   ""} $word]
	 set word [string trimright $word "1234567890"]
	 set word [string map {|lutrama   ""} $word]
	 set word [string trimright $word "1234567890"]
	 set word [string map {|altsyncram   ""} $word]
	 set word [string map {|auto_generated   ""} $word]

    }
#To Group |ram_block2a<digit>|ena[<digit>]
#theDPD2_LIB_cunroll_x|thedpd_cunroll_x|CoefficientMemArray_0_imag_x_dmem|auto_generated|altsyncram1|ram_block2a0|ena0
    
    if {[string match {*|ram_block2a*|ena*} $word] == 1} {

	 set word [string trimright $word "1234567890"]
	 set word [string map {|ena   ""} $word]
	 set word [string trimright $word "1234567890"]
	 set word [string map {|ram_block2a   ""} $word]
	 set word [string trimright $word "1234567890"]
	 set word [string map {|altsyncram   ""} $word]
	 set word [string map {|auto_generated   ""} $word]

    }

#To Group |ram_block2a<digit>|portaddr[<digit>]
#ram_block2a<digit>~reg0 
    if {[string match {*|ram_block2a*|portaaddr\[*\]} $word] == 1} {

	 set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]

	 set word [string map {|portaaddr   ""} $word]
	 set word [string trimright $word "1234567890"]
	 set word [string map {|ram_block2a   ""} $word]
	 set word [string trimright $word "1234567890"]
	 set word [string map {|altsyncram   ""} $word]
	 set word [string map {|auto_generated   ""} $word]
    }


    #if {[string match {*|Mult*} $word] == 1} {

	 #set word [string trimright $word "1234567890"]
	 #set word [string map {Mult   ""} $word]

    #}

    # to Remove [digit][digit]
    if {[string match {*\[*\]} $word] == 1} {
	 set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]
    }
    if {[string match {*\[*\]} $word] == 1} {
	 set word [string trimright $word "]"]
	 set word [string trimright $word "1234567890"]
	 set word [string trimright $word "\["]
    }

	 set word [string trimright $word "_"]

	 return $word
}


###############################################################################
#     TO check the string in another string
###############################################################################

proc string_match {pattern line} {
	set node_list [split $pattern "|"]
	set line_list [split $line "|"]
	foreach node $node_list {
	  set index [lsearch -all $line_list $node]
	  if {$index < 0 } {
		  return 0
	  }
	}
	return 1

}

###############################################################################
# To Get list of First node which is connected to a source
###############################################################################

proc get_immediate_node {rd_file wr_file} {
	set fp_rd_rpt [open $rd_file "r"]
	set fp_wr_rpt [open $wr_file "w"]
	set data   [read $fp_rd_rpt]
	set data   [split $data "\n"]
	set flag_cnt 0
	set flag 0
	 foreach line1 $data {
	     if {$flag_cnt == 2} {
	        set word_list [split $line1 ";"]
		set word [lindex $word_list 8]
		################################
                set word [remove_string $word]
		################################
	  	puts $fp_wr_rpt $word
		set flag 0
		set flag_cnt 0

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
	 close $fp_wr_rpt
}
###############################################################################
#  Return No of hits of the given string in the file 
###############################################################################
proc countstrings {data search} {
    set l [string length $search]
    set count 0
    while {[set i [string first $search $data]]>=0} {
        incr count
        incr i $l
        set data [string range $data $i end]
    }
    return $count
}
###############################################################################
#  To search the given string in a file and return the count value
#  This function is used to count the number of destination for the given 
#  Source Node  
###############################################################################

proc no_dest_path {src rd_file} {
     set fp_rd_file [open $rd_file "r"]
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
# Generation of Manual Logic Duplication Constraint ( DUPLICATE ATOM ) 
###############################################################################

proc creating_qsf {src rpt_dest rpt_dest_uniq rpt_dest_uniq_full fp_rpt_qsf \
	           grp_thrsh src_cnt quartus_sta prj_qpf rpt_dest_full prj_name block_name} {

        report_timing -from $src -to * -setup -npaths 10000 -detail full_path -panel_name {Report Timing} -file $rpt_dest_full 
	get_immediate_node $rpt_dest_full $rpt_dest 

	set fp_rpt_dest [open $rpt_dest "r"]
	set fp_rpt_dest_uniq_full [open $rpt_dest_uniq_full "w"]

        set dest_data [read $fp_rpt_dest]	
	set dest_data [split $dest_data "\n"]
	set dest_data [lsort -unique $dest_data]

	foreach line $dest_data {
		set line [string trim $line " "]
		puts $fp_rpt_dest_uniq_full "|$line|"
	}
	close $fp_rpt_dest_uniq_full
	close $fp_rpt_dest

      # To get the common instance Name in destination Path 
	
        set T_dest_uniq_line_cnt [linecount $rpt_dest_uniq_full]
	set T_dest_uniq_line_cnt [expr {$T_dest_uniq_line_cnt - 2}]  

	set fp_rpt_dest_uniq_full [open $rpt_dest_uniq_full "r"]
        set dest_data1 [read $fp_rpt_dest_uniq_full]	

	set dest_data_tmp [split $dest_data1 "|"]
        set dest_data_tmp [string map {"\}" " "} $dest_data_tmp]
	set dest_data_tmp [string map {"\{" "\n"} $dest_data_tmp]
	set dest_data_tmp [lsort $dest_data_tmp]

	set flag 0
	set count 0
	#set arr_cnt 1
	set node_arr {}



	foreach line $dest_data_tmp {
                set line [string trim $line " "]
		if { [string length $line] > 0 } {
		   if {$flag == 1} {
		      if {$line == $duplicate_line} {
			  set count [expr {$count + 1}]
		      } else {
			  if {$count > 1} {
			    set duplicate_line [string trim $duplicate_line " "]
			    #lappend node_arr $duplicate_line
			    #set arr_cnt [expr {$arr_cnt + 1}]
			  }
			  if {$count > $T_dest_uniq_line_cnt } {
			    lappend node_arr $duplicate_line
			  }

		          set duplicate_line $line
		          set count 1
		      }
		   } else {
		      set flag 1
		      set duplicate_line $line
		      set count 1
		   }

		}
	}
	if {$count > 1} {
            lappend node_arr $duplicate_line
        }


	close $fp_rpt_dest_uniq_full

	set fp_rpt_dest_uniq [open $rpt_dest_uniq "w"]

	foreach line $dest_data {
		set node $line
		set node_tmp $line
		foreach rm_node $node_arr {
                       set node [string trim $node " "]
			set node [split $node "|"]
			set index [lsearch -all $node $rm_node]
			# to remove more than one instance with the same name
			foreach indx $index {
			  set node [lreplace $node $indx $indx ""]
		       }
			set node [join $node "|"]
		}
		set node [string trimright $node "|"] 
		set node [string trimleft $node "|"] 
	        set node [regsub -all {(\|+)} $node "|"]	
		puts $fp_rpt_dest_uniq "$node"
	}

	close $fp_rpt_dest_uniq

        # grp_flag is used to avoid duplicate atom if it is able to form only one group 
	#set grp_flag 0
        set fp_rpt_dest      [open $rpt_dest "r"]
	set fp_rpt_dest_uniq [open $rpt_dest_uniq "r"]

	set dest_data        [read  $fp_rpt_dest]
	set dest_data        [split $dest_data "\n"]
	set dest_uniq_data   [read  $fp_rpt_dest_uniq]
	set dest_uniq_data   [split $dest_uniq_data "\n"]


	set counter 0
	set dup_cnt 0
	if {$T_dest_uniq_line_cnt  > 0 } {
	foreach line $dest_uniq_data {
          if { [string length $line] > 0 } {
		set dup_cnt [expr {$dup_cnt + 1}]
		set counter 0
		foreach line1 $dest_data {
		   if {[string_match $line $line1] > 0} {
		        set counter [expr {$counter + 1}]
		   }
		}

		if  {$counter > $grp_thrsh} {
		         
			#if {$grp_flag > 0 } {
			#puts $fp_rpt_qsf "set_instance_assignment -name \
			#DUPLICATE_ATOM $dup_name  -from \"$src\" -to \"*$dest_node*\""
			#}

			#set grp_flag 1

			set dup_name [concat $block_name\_$src_cnt\_$dup_cnt\_DUP] 
			set dest_node [string trim $line " "]
			set dest_node [string map {"|" "*|*"} $dest_node]


	                set last_chr [string index $dest_node end]
	                if { [lsearch {0 1 2 3 4 5 6 7 8 9} $last_chr] > -1 } {
                         set dest_node [concat $dest_node\|]
	                } 

			puts $fp_rpt_qsf "set_instance_assignment -name \
			DUPLICATE_ATOM $dup_name  -from \"$src\" -to \"*$dest_node*\""
		}
	   }
	}

	close $fp_rpt_dest
	close $fp_rpt_dest_uniq
      }
}
###############################################################################
# Project Start Time
###############################################################################

set st_time [get_time ]

################################################################################
# Read Project File
################################################################################

cd $prj_folder 
#exec $quartus_sta -s
project_open -force $prj_qpf  -revision $prj_name 
create_timing_netlist -model slow
read_sdc


################################################################################
# Report All Registers with Source and Desintation Nodes 
# Number of paths per endpoint [10]
################################################################################

if {$level == "CHIP"} {
#report_timing -from_clock  $clk_name  -to_clock  $clk_name  -from "\*$block_name\*" -to * -setup -npaths 200000 -nworst 10 -detail summary -panel_name {Report Timing} -file $rpt_sum 
report_timing -from_clock  $clk_name  -to_clock  $clk_name  -from "\*$block_name\*" -to * -setup -npaths 300000 -detail summary -panel_name {Report Timing} -file $rpt_sum 
} else {
#report_timing -from_clock  $clk_name  -to_clock  $clk_name  -from * -to * -setup -npaths 200000 -nworst 10 -detail summary -panel_name {Report Timing} -file $rpt_sum 
report_timing -from_clock  $clk_name  -to_clock  $clk_name  -from * -to * -setup -npaths 300000 -detail summary -panel_name {Report Timing} -file $rpt_sum 
}



################################################################################
#  Extracting Source Node Alone
################################################################################
set fp_rpt_sum [open $rpt_sum "r"]
set fp_rpt_src [open $rpt_src "w"]

set sum_data [read $fp_rpt_sum]

close $fp_rpt_sum

set line_cnt 0
set sum_data_spt [split $sum_data "\n"]

# Finding the start Point
foreach line $sum_data_spt {
    set line_cnt [expr {$line_cnt + 1}]
  if {[string first Slack $line] == -1} {
  } else {
    break
  }
}

set start_val $line_cnt
set line_cnt 0
set word_cnt 0
# Writing Source Node
foreach line $sum_data_spt {
  set line_cnt [expr {$line_cnt + 1}]
  if {$line_cnt > $start_val} {
    set word_list [split $line ";"]
    set word [lindex $word_list 2]
    set word [string trim $word " "]
    set word [string map {~DUPLICATE ""} $word]
    puts $fp_rpt_src $word
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

foreach line $src_data_spt {
   if { [string length $line] > 0 } {
    if {$flag == 1} {
      if {$line == $duplicate_line} {
	      set count [expr {$count + 1}]
      } else {
         if {([string first "DUPLICATE" $duplicate_line] == -1) && ([string first "~" $duplicate_line] == -1) \
	  && ([string first "regmap" $duplicate_line] == -1) } {
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
  if {[string first "DUPLICATE" $duplicate_line] == -1} {
     puts $fp_rpt_src_uniq "$duplicate_line;$count"
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

set fp_rpt_src [open $rpt_src "r"]
set src_data [read $fp_rpt_src]
close $fp_rpt_src
set src_data [split $src_data "\n"]

set src_uniq_data_spt [split $src_uniq_data "\n"]

set src_cnt 0
set src_proc_cnt 0


###############################################################################
#  CALLING COPYRIGHT FUNCTION
###############################################################################
 
add_altera_copyright $rpt_qsf 

###############################################################################

set fp_rpt_qsf       [open $rpt_qsf "a"]

 foreach line $src_uniq_data_spt {

  set src_cnt [expr {$src_cnt + 1}]
	 
   if { [string length $line] > 0 } {

    set src_proc_cnt [ expr {$src_proc_cnt + 1}]

    puts "Processing $src_proc_cnt / $T_src_node \n "

    set word_list [split $line ";"]
    set s_node [lindex $word_list 0]
    set num_dest_path [lindex $word_list 1]
	
	  if {$num_dest_path > $mld_dest_thrsh} {
	     puts "Updating QSF File"
	     creating_qsf $s_node $rpt_dest $rpt_dest_uniq $rpt_dest_uniq_full\
	                  $fp_rpt_qsf $grp_thrsh $src_cnt  $quartus_sta $prj_qpf \
			  $rpt_dest_full $prj_name $block_name
	  } else {
	  }
   }
   #if {$src_cnt == 3631} {
   #	   break
   #}
  }

close $fp_rpt_qsf
   
################################################################################

project_close

set end_time [get_time ]

puts "\n Project Start Time $st_time Finish Time $end_time"



