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

###############################################################################
# USER INPUTS
###############################################################################
#set quartus_install_path        [lindex $argv 0]
#set quartus_project_path        [lindex $argv 1]
#set quartus_exec_path		[lindex $argv 2] 
#set parallelization             [lindex $argv 3] 
##number of seeds to be run
#set num_of_seeds		[lindex $argv 4] 
#set start                       [lindex $argv 5]
##order in which seed sweeep will run
##array set seed_order			[lindex $argv 5]
#
#array set seed_order { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
#if {$start == true} {
#StartSeedSweep
#}

proc findfile { dir fname } {
    if {
        [llength [set x [glob -nocomplain -dir $dir $fname]]]
    } {
        return [lindex $x 0]
    } else {
        foreach i [glob -nocomplain -type d -dir $dir *] {
            if {
                $i != $dir &&
                [llength [set x [findfile $i $fname]]]
            } {
                return $x
            }
        }
    }
}
proc QuartusExecution {Quartus_path prj rev seedn } {
	#Syntax: quartus_sh --clean [-c <revision_name>] <project>
	exec $Quartus_path/quartus_sh --clean -c * $prj
	puts "Quartus has cleaned the project for seed $seedn"
	exec $Quartus_path/quartus_map --read_settings_files=on --write_settings_files=off $prj -c $rev 
	puts "Quartus Analysis & Synthesis is completed successfully for seed $seedn"
	exec $Quartus_path/quartus_fit --read_settings_files=off --write_settings_files=off $prj -c $rev --seed=$seedn
	puts "Quartus Fitter is completed successfully for seed $seedn"
	exec $Quartus_path/quartus_asm --read_settings_files=off --write_settings_files=off $prj -c $rev
	puts "Quartus Assembler is completed successfully for seed $seedn"
	exec $Quartus_path/quartus_sta $prj -c $rev
	puts "Quartus Timing Analysis is completed successfully for seed $seedn"
	exec $Quartus_path/quartus_eda $prj -c $rev
}

proc QuartusParallelExecution1 {Quartus_path Prj_path prj rev seedn} {
	if { $::tcl_platform(platform) == "windows" } {
		set fp [open "quartus_execution.bat" w+]
		puts $fp "cd $Prj_path"
		puts $fp "$Quartus_path/quartus_sh --clean -c * $prj"
		puts $fp "$Quartus_path/quartus_map --read_settings_files=on --write_settings_files=off $prj -c $rev "
		puts $fp "$Quartus_path/quartus_fit --read_settings_files=off --write_settings_files=off $prj -c $rev --seed=$seedn"
		puts $fp "$Quartus_path/quartus_asm --read_settings_files=off --write_settings_files=off $prj -c $rev"
		puts $fp "$Quartus_path/quartus_sta $prj -c $rev"
		puts $fp "$Quartus_path/quartus_eda $prj -c $rev"
		puts $fp "mkdir STA_COMPLETED"
		close $fp
		exec cmd.exe /c quartus_execution.bat > log.txt &
	} elseif { $::tcl_platform(platform) == "unix" } {
		set fp [open "quartus_execution.sh" w+]
		puts $fp "cd $Prj_path"
		puts $fp "$Quartus_path/quartus_sh --clean -c \\* $prj"
		puts $fp "$Quartus_path/quartus_map --read_settings_files=on --write_settings_files=off $prj -c $rev "
		puts $fp "$Quartus_path/quartus_fit --read_settings_files=off --write_settings_files=off $prj -c $rev --seed=$seedn"
		puts $fp "$Quartus_path/quartus_asm --read_settings_files=off --write_settings_files=off $prj -c $rev"
		puts $fp "$Quartus_path/quartus_sta $prj -c $rev"
		puts $fp "$Quartus_path/quartus_eda $prj -c $rev"
		puts $fp "mkdir STA_COMPLETED"
		close $fp
		exec bash quartus_execution.sh &
	}
}

proc StartSeedSweep { quartus_install_path quartus_project_path quartus_exec_path parallelization num_of_seeds } {
set seed_order "1 2 3 4 5 6 7 8 9 10" 
	puts "Seed Sweep is starting"
	#dashboard_set_property ${dash_path} SSMessageWindowTextField text "Seed Sweep is starting"
	#set quartus_install_path [dashboard_get_property ${dash_path} SSQuartusInstallPathTextField text]
	#set quartus_project_path [dashboard_get_property ${dash_path} SSQuartusProjectPathTextField text]
	#set quartus_exec_path [dashboard_get_property ${dash_path} ExecutionPathTextField text]
	#set ::SeedSweep_MainControl::SSTargetClk [dashboard_get_property ${dash_path} SSclkTextField text]
	#set parallelization [dashboard_get_property ${dash_path} ParallelExecutionCombo selected]
	#set num_of_seeds [dashboard_get_property ${dash_path} SeedNumCombo selected]

	if { $parallelization == 1 } {
		puts "single run"
		for {set i 0} {$i < $num_of_seeds } {incr i} {
			
			set seedi [lindex $seed_order $i]
			#set seed_calc [expr (${seedi}+1)]
			set seed_calc $seedi
			puts $seed_calc
			puts "Quartus compilation is going to start for seed $seed_calc"

			file delete -force ${quartus_exec_path}/seed$seed_calc
			file copy -force ${quartus_project_path} ${quartus_exec_path}/seed$seed_calc
			puts "Copied"
			set prj_name_path [findfile ${quartus_exec_path}/seed$seed_calc *.qpf]
			set rev_name_path [findfile ${quartus_exec_path}/seed$seed_calc *.qsf]
			puts $prj_name_path
			puts $rev_name_path
			set prj_name_ext [file tail $prj_name_path]
			set rev_name_ext [file tail $rev_name_path]
			puts $prj_name_ext
			puts $rev_name_ext
			set prj_name [string trimright $prj_name_ext ".qpf"]
			#set rev_name [string trimright $rev_name_ext ".qsf"]
			set rev_name $prj_name
			puts $prj_name
			puts $rev_name
			cd ${quartus_exec_path}/seed$seed_calc
			puts [pwd]
			QuartusExecution ${quartus_install_path} $prj_name $rev_name $seed_calc 
			puts "Quartus compilation is successfully completed for seed $seed_calc"
		}
	} elseif { $parallelization == 2 } {
		puts "2 parallel runs"
		for {set i 0} {$i < $num_of_seeds} {incr i 2} {

		set seedi [lindex $seed_order $i]
		#set seed_calc_1 [expr (${seedi}+1)]
		set seed_calc_1 $seedi
		puts $seed_calc_1
		puts "Quartus compilation is going to start for seed $seed_calc_1"
		file delete -force ${quartus_exec_path}/seed$seed_calc_1
		file copy -force ${quartus_project_path} $quartus_exec_path/seed$seed_calc_1
		set prj_name_path_1 [findfile ${quartus_exec_path}/seed$seed_calc_1 *.qpf]
		set rev_name_path_1 [findfile ${quartus_exec_path}/seed$seed_calc_1 *.qsf]
		puts $prj_name_path_1
		puts $rev_name_path_1
		set prj_name_ext_1 [file tail $prj_name_path_1]
		set rev_name_ext_1 [file tail $rev_name_path_1]
		puts $prj_name_ext_1
		puts $rev_name_ext_1
		set prj_name_1 [string trimright $prj_name_ext_1 ".qpf"]
		#set rev_name_1 [string trimright $rev_name_ext_1 ".qsf"]
		set rev_name_1 $prj_name_1
		puts $prj_name_1
		puts $rev_name_1
		set prj_path1 ${quartus_exec_path}/seed$seed_calc_1
		cd ${quartus_exec_path}/seed$seed_calc_1
		puts [pwd]	
		set curr_path [pwd]
		set chk_completion [concat "$curr_path//STA_COMPLETED"]
	
		QuartusParallelExecution1 ${quartus_install_path} $prj_path1 $prj_name_1 $rev_name_1 $seed_calc_1
		#dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is successfully completed for seed $seed_calc_1"		
	

		#set seedi [lindex $seed_order $i]
		set seed_calc_2 [expr (${seedi} + 1)]
		puts $seed_calc_2
		after 1000
		puts "Quartus compilation is going to start for seed $seed_calc_2"

		file delete -force ${quartus_exec_path}/seed$seed_calc_2
		file copy -force ${quartus_project_path} ${quartus_exec_path}/seed$seed_calc_2
		set prj_name_path_2 [findfile ${quartus_exec_path}/seed$seed_calc_2 *.qpf]
		set rev_name_path_2 [findfile ${quartus_exec_path}/seed$seed_calc_2 *.qsf]
		puts $prj_name_path_2
		puts $rev_name_path_2
		set prj_name_ext_2 [file tail $prj_name_path_2]
		set rev_name_ext_2 [file tail $rev_name_path_2]
		puts $prj_name_ext_2
		puts $rev_name_ext_2
		set prj_name_2 [string trimright $prj_name_ext_2 ".qpf"]
		#set rev_name_2 [string trimright $rev_name_ext_2 ".qsf"]
		set rev_name_2 $prj_name_2
		puts $prj_name_2
		puts $rev_name_2
		set prj_path2 ${quartus_exec_path}/seed$seed_calc_2
		cd ${quartus_exec_path}/seed$seed_calc_2
		puts [pwd]	

		#QuartusParallelExecution2 ${quartus_install_path} $prj_path2 $prj_name_2 $rev_name_2 $seed_calc_2
		QuartusExecution ${quartus_install_path} $prj_name_2 $rev_name_2 $seed_calc_2 
		puts "Quartus compilation is successfully completed for seed $seed_calc_2"
             
		set Q_completed 0

		while {$Q_completed < 1} {
		  set Q_completed [file exists $chk_completion]
		  after 1000
		}
                
		}
	} elseif { $parallelization == 3 } {
		puts "3 parallel runs"
		for {set i 0} {$i < $num_of_seeds} {incr i 3} {

		set seedi [lindex $seed_order $i]
		set seed_calc_1 $seedi
		puts $seed_calc_1
		puts "Quartus compilation is going to start for seed $seed_calc_1"
		file delete -force ${quartus_exec_path}/seed$seed_calc_1
		file copy -force ${quartus_project_path} ${quartus_exec_path}/seed$seed_calc_1
		puts ${quartus_exec_path}/seed$seed_calc_1
		set prj_name_path_1 [findfile ${quartus_exec_path}/seed$seed_calc_1 *.qpf]
		set rev_name_path_1 [findfile ${quartus_exec_path}/seed$seed_calc_1 *.qsf]
		puts $prj_name_path_1
		puts $rev_name_path_1
		set prj_name_ext_1 [file tail $prj_name_path_1]
		set rev_name_ext_1 [file tail $rev_name_path_1]
		puts $prj_name_ext_1
		puts $rev_name_ext_1
		set prj_name_1 [string trimright $prj_name_ext_1 ".qpf"]
		#set rev_name_1 [string trimright $rev_name_ext_1 ".qsf"]
		set rev_name_1 $prj_name_1
		puts $prj_name_1
		puts $rev_name_1
		set prj_path1 ${quartus_exec_path}/seed$seed_calc_1
		cd ${quartus_exec_path}/seed$seed_calc_1
		puts [pwd]	
		set curr_path_1 [pwd]
		set chk_completion_1 [concat "$curr_path_1//STA_COMPLETED"]
	
		QuartusParallelExecution1 ${quartus_install_path} $prj_path1 $prj_name_1 $rev_name_1 $seed_calc_1
		#dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is successfully completed for seed $seed_calc_1"		
		
		#2nd seed
		#set seedi [lindex $seed_order $i]
		set seed_calc_2 [expr (${seedi} + 1)]
		puts $seed_calc_2
		after 1000
		puts "Quartus compilation is going to start for seed $seed_calc_2"
		file delete -force ${quartus_exec_path}/seed$seed_calc_2
		file copy -force ${quartus_project_path} ${quartus_exec_path}/seed$seed_calc_2
		set prj_name_path_2 [findfile ${quartus_exec_path}/seed$seed_calc_2 *.qpf]
		set rev_name_path_2 [findfile ${quartus_exec_path}/seed$seed_calc_2 *.qsf]
		puts $prj_name_path_2
		puts $rev_name_path_2
		set prj_name_ext_2 [file tail $prj_name_path_2]
		set rev_name_ext_2 [file tail $rev_name_path_2]
		puts $prj_name_ext_2
		puts $rev_name_ext_2
		set prj_name_2 [string trimright $prj_name_ext_2 ".qpf"]
		#set rev_name_2 [string trimright $rev_name_ext_2 ".qsf"]
		set rev_name_2 $prj_name_2
		puts $prj_name_2
		puts $rev_name_2
		set prj_path2 ${quartus_exec_path}/seed$seed_calc_2
		cd ${quartus_exec_path}/seed$seed_calc_2
		puts [pwd]	
		set curr_path_2 [pwd]
		set chk_completion_2 [concat "$curr_path_2//STA_COMPLETED"]
	
		QuartusParallelExecution1 ${quartus_install_path} $prj_path2 $prj_name_2 $rev_name_2 $seed_calc_2
		
		#3rd seed
		#set seedi [lindex $seed_order $i]
		set seed_calc_3  [expr (${seedi} + 2)]
		puts $seed_calc_3
		after 1000
		puts "Quartus compilation is going to start for seed $seed_calc_3"

		file delete -force ${quartus_exec_path}/seed$seed_calc_3
		file copy -force ${quartus_project_path} ${quartus_exec_path}/seed$seed_calc_3
		set prj_name_path_3 [findfile ${quartus_exec_path}/seed$seed_calc_3 *.qpf]
		set rev_name_path_3 [findfile ${quartus_exec_path}/seed$seed_calc_3 *.qsf]
		puts $prj_name_path_3
		puts $rev_name_path_3
		set prj_name_ext_3 [file tail $prj_name_path_3]
		set rev_name_ext_3 [file tail $rev_name_path_3]
		puts $prj_name_ext_3
		puts $rev_name_ext_3
		set prj_name_3 [string trimright $prj_name_ext_3 ".qpf"]
		#set rev_name_3 [string trimright $rev_name_ext_3 ".qsf"]
		set rev_name_3 $prj_name_3
		puts $prj_name_3
		puts $rev_name_3
		set prj_path2 ${quartus_exec_path}/seed$seed_calc_3
		cd ${quartus_exec_path}/seed$seed_calc_3
		puts [pwd]	

		#QuartusParallelExecution2 ${quartus_install_path} $prj_path2 $prj_name_3 $rev_name_3 $seed_calc_3
		QuartusExecution ${quartus_install_path} $prj_name_3 $rev_name_3 $seed_calc_3 
		puts "Quartus compilation is successfully completed for seed $seed_calc_3"		

		set Q_completed_1 0
		set Q_completed_2 0

		while {$Q_completed_1 < 1 || $Q_completed_2 < 1} {
		  set Q_completed_1 [file exists $chk_completion_1]
		  set Q_completed_2 [file exists $chk_completion_2]
		  after 1000
		}

		}
	}

}
