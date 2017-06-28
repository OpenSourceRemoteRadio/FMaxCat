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

#package require Tk
package require Tcl 8.5



namespace eval SeedAnalyze_MainControl {
  
namespace export ConfigureTxSysrefMode ConfigureRxSysrefMode GetGuiProperties ConfigurePatternGenerator ConfigurePatternChecker    
  
	 variable QuartusInstallationPath
	 variable QuartusProjectPath
	 variable QPFNumVar
	 variable clkVar
	 #variable QuartusQPFPath 
	 variable QPFNumSelection
	 variable DISABLE_MAXDELAY

proc SeedAnalyze_DashBoard { dash_path tabGroup } {

set ::SeedAnalyze_MainControl::DISABLE_MAXDELAY "true"
#image create photo imgobj -file "bigcat_logo.png" -width 400 -height 400 
#pack [label .myLabel]
#.myLabel configure -image imgobj 
     
#Main control widgets
#
#dashboard_add ${dash_path} TitleWindow group self
#dashboard_set_property ${dash_path} TitleWindow expandableX false
#dashboard_set_property ${dash_path} TitleWindow expandableY false
#dashboard_set_property ${dash_path} TitleWindow title ""
#dashboard_set_property ${dash_path} TitleWindow preferredWidth 1000
#dashboard_set_property ${dash_path} TitleWindow itemsPerRow 3


#dashboard_add ${dash_path} TitleWindowTextField textField TitleWindow
#dashboard_set_property ${dash_path} TitleWindowTextField expandableY false
#dashboard_set_property ${dash_path} TitleWindowTextField expandableX false
#dashboard_set_property ${dash_path} TitleWindowTextField text "TEST"
#dashboard_set_property ${dash_path} TitleWindowTextField editable false
#dashboard_set_property ${dash_path} TitleWindowTextField preferredWidth 980
#dashboard_set_property ${dash_path} TitleWindowTextField preferredHeight 30
#
dashboard_add ${dash_path} topGroup group self
dashboard_set_property ${dash_path} topGroup expandableX true
dashboard_set_property ${dash_path} topGroup expandableY true
dashboard_set_property ${dash_path} topGroup itemsPerRow 1
dashboard_set_property ${dash_path} topGroup title "" 

dashboard_add ${dash_path} InputData group topGroup
dashboard_set_property ${dash_path} InputData expandableX false
dashboard_set_property ${dash_path} InputData expandableY false
dashboard_set_property ${dash_path} InputData preferredWidth 1000
dashboard_set_property ${dash_path} InputData title "Input Configuration"
dashboard_set_property ${dash_path} InputData itemsPerRow 3
###############################################################################

dashboard_add ${dash_path} QuartusInstallPath label InputData
dashboard_set_property ${dash_path} QuartusInstallPath expandableY false
dashboard_set_property ${dash_path} QuartusInstallPath expandableX false
dashboard_set_property ${dash_path} QuartusInstallPath preferredWidth 175
dashboard_set_property ${dash_path} QuartusInstallPath text "Quartus installation path:"

dashboard_add ${dash_path} QuartusInstallPathTextField textField InputData
dashboard_set_property ${dash_path} QuartusInstallPathTextField expandableY false
dashboard_set_property ${dash_path} QuartusInstallPathTextField expandableX false
dashboard_set_property ${dash_path} QuartusInstallPathTextField editable true
dashboard_set_property ${dash_path} QuartusInstallPathTextField preferredWidth 700
dashboard_set_property ${dash_path} QuartusInstallPathTextField text "D:/altera/quartus/bin64"
dashboard_set_property ${dash_path} QuartusInstallPathTextField toolTip "Enter Quartus installation location upto bin64/"

dashboard_add ${dash_path} NavigateButton fileChooserButton InputData
dashboard_set_property ${dash_path} NavigateButton expandableX false
dashboard_set_property ${dash_path} NavigateButton expandableY false
dashboard_set_property ${dash_path} NavigateButton preferredWidth 30
dashboard_set_property ${dash_path} NavigateButton text ".."
dashboard_set_property ${dash_path} NavigateButton title "Quartus installation folder"
dashboard_set_property ${dash_path} NavigateButton mode "directories_only"
dashboard_set_property ${dash_path} NavigateButton chooserButtonText "Select"
dashboard_set_property ${dash_path} NavigateButton onChoose "::SeedAnalyze_MainControl::QuartusPath $dash_path"

###############################################################################
dashboard_add ${dash_path} clkLabel label InputData
dashboard_set_property ${dash_path} clkLabel expandableY false
dashboard_set_property ${dash_path} clkLabel expandableX false
dashboard_set_property ${dash_path} clkLabel text "CLK:"

dashboard_add ${dash_path} clkTextField textField InputData
dashboard_set_property ${dash_path} clkTextField expandableY false
dashboard_set_property ${dash_path} clkTextField expandableX false
dashboard_set_property ${dash_path} clkTextField editable true
dashboard_set_property ${dash_path} clkTextField preferredWidth 300
dashboard_set_property ${dash_path} clkTextField text "u_a10_soc|iopll_dsp|outclk0"
dashboard_set_property ${dash_path} clkTextField toolTip "Enter full hierarchy of clock"

###############################################################################

#Number of constraints
dashboard_add ${dash_path} QPFSelectionGroup group topGroup
dashboard_set_property ${dash_path} QPFSelectionGroup itemsPerRow 4
dashboard_set_property ${dash_path} QPFSelectionGroup expandableX false
dashboard_set_property ${dash_path} QPFSelectionGroup expandableY false
dashboard_set_property ${dash_path} QPFSelectionGroup preferredWidth 1000
dashboard_set_property ${dash_path} QPFSelectionGroup title "Generate Timing Reports Comparison"

dashboard_add ${dash_path} ModuleNumLabel label QPFSelectionGroup
dashboard_set_property ${dash_path} ModuleNumLabel expandableY false
dashboard_set_property ${dash_path} ModuleNumLabel expandableX false
dashboard_set_property ${dash_path} ModuleNumLabel preferredWidth 150
dashboard_set_property ${dash_path} ModuleNumLabel text "Number of Projects to be Analyzed:"

dashboard_add ${dash_path} QPFNumCombo comboBox QPFSelectionGroup
dashboard_set_property ${dash_path} QPFNumCombo expandableY false
dashboard_set_property ${dash_path} QPFNumCombo expandableX false
dashboard_set_property ${dash_path} QPFNumCombo preferredWidth 70
dashboard_set_property ${dash_path} QPFNumCombo options { "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
dashboard_set_property ${dash_path} QPFNumCombo toolTip "Enter no. of modules for which QPF constraints need to be analyzed (MAX 10)"
dashboard_set_property ${dash_path} QPFNumCombo onChange "::SeedAnalyze_MainControl::EnterQPFInfo $dash_path"

dashboard_add ${dash_path} emptyLabel1 label QPFSelectionGroup
dashboard_set_property ${dash_path} emptyLabel1 expandableX false
dashboard_set_property ${dash_path} emptyLabel1 expandableY false
dashboard_set_property ${dash_path} emptyLabel1 text ""
dashboard_set_property ${dash_path} emptyLabel1 preferredWidth 210

dashboard_add ${dash_path} emptyLabel2 label QPFSelectionGroup
dashboard_set_property ${dash_path} emptyLabel2 expandableX false
dashboard_set_property ${dash_path} emptyLabel2 expandableY false
dashboard_set_property ${dash_path} emptyLabel2 text ""
dashboard_set_property ${dash_path} emptyLabel2 preferredWidth 210



for {set i 0} {$i < 10} {incr i} {

dashboard_add ${dash_path} QuartusQPFPathLabel($i) label QPFSelectionGroup 
dashboard_set_property ${dash_path} QuartusQPFPathLabel($i) expandableY false
dashboard_set_property ${dash_path} QuartusQPFPathLabel($i) expandableX false
dashboard_set_property ${dash_path} QuartusQPFPathLabel($i) visible false
dashboard_set_property ${dash_path} QuartusQPFPathLabel($i) text "QPF path [expr {$i + 1}]:"

dashboard_add ${dash_path} QuartusQPFPathTextField($i) textField QPFSelectionGroup 
dashboard_set_property ${dash_path} QuartusQPFPathTextField($i) expandableY false
dashboard_set_property ${dash_path} QuartusQPFPathTextField($i) expandableX false
dashboard_set_property ${dash_path} QuartusQPFPathTextField($i) editable true
dashboard_set_property ${dash_path} QuartusQPFPathTextField($i) visible  false
dashboard_set_property ${dash_path} QuartusQPFPathTextField($i) preferredWidth 700
dashboard_set_property ${dash_path} QuartusQPFPathTextField($i) text ""
dashboard_set_property ${dash_path} QuartusQPFPathTextField($i) toolTip "Point to the QPF file of the required project"

dashboard_add ${dash_path} QPF_NavigateButton($i) fileChooserButton QPFSelectionGroup 
dashboard_set_property ${dash_path} QPF_NavigateButton($i) expandableX false
dashboard_set_property ${dash_path} QPF_NavigateButton($i) expandableY false
dashboard_set_property ${dash_path} QPF_NavigateButton($i) preferredWidth 30
dashboard_set_property ${dash_path} QPF_NavigateButton($i) visible false
dashboard_set_property ${dash_path} QPF_NavigateButton($i) text ".."
dashboard_set_property ${dash_path} QPF_NavigateButton($i) title "Project folder (.qsf file)"
dashboard_set_property ${dash_path} QPF_NavigateButton($i) mode "files_only"
dashboard_set_property ${dash_path} QPF_NavigateButton($i) filter [list "QPF FILE (.qpf)" "qpf"]
dashboard_set_property ${dash_path} QPF_NavigateButton($i) chooserButtonText "Select"
dashboard_set_property ${dash_path} QPF_NavigateButton($i) onChoose "::SeedAnalyze_MainControl::QPFPath $dash_path $i"

dashboard_add ${dash_path} emptyLabel3 label QPFSelectionGroup
dashboard_set_property ${dash_path} emptyLabel3 expandableX false
dashboard_set_property ${dash_path} emptyLabel3 expandableY false
dashboard_set_property ${dash_path} emptyLabel3 text ""
dashboard_set_property ${dash_path} emptyLabel3 preferredWidth 210
}

dashboard_add ${dash_path} ConfigureButton button QPFSelectionGroup 
dashboard_set_property ${dash_path} ConfigureButton expandableX false
dashboard_set_property ${dash_path} ConfigureButton expandableY false
dashboard_set_property ${dash_path} ConfigureButton text " Analyze & Generate constraints"
dashboard_set_property ${dash_path} ConfigureButton toolTip "Generates the selected constraints for selected modules"
dashboard_set_property ${dash_path} ConfigureButton onClick "::SeedAnalyze_MainControl::GenerateConstraints $dash_path"

dashboard_add ${dash_path} MessageWindow group topGroup
dashboard_set_property ${dash_path} MessageWindow expandableX false
dashboard_set_property ${dash_path} MessageWindow expandableY false
dashboard_set_property ${dash_path} MessageWindow title "Message/Warning"
dashboard_set_property ${dash_path} MessageWindow preferredWidth 1000
dashboard_set_property ${dash_path} MessageWindow itemsPerRow 3


dashboard_add ${dash_path} MessageWindowTextField textField MessageWindow
dashboard_set_property ${dash_path} MessageWindowTextField expandableY false
dashboard_set_property ${dash_path} MessageWindowTextField expandableX false
dashboard_set_property ${dash_path} MessageWindowTextField text ""
dashboard_set_property ${dash_path} MessageWindowTextField editable false
dashboard_set_property ${dash_path} MessageWindowTextField preferredWidth 980
dashboard_set_property ${dash_path} MessageWindowTextField preferredHeight 30
}


#Syntax: dashboard_get_property ${dash_path} TxIPLocalMultiframeClockPhaseOffsetTextField text]  
#dashboard_get_property ${dash_path} RegWriteReadCombo selected

proc QuartusPath {dash_path} {
	set ::SeedAnalyze_MainControl::QuartusInstallationPath [dashboard_get_property ${dash_path} NavigateButton paths]
	set qpath [file nativename $::SeedAnalyze_MainControl::QuartusInstallationPath]
	set n [string length $qpath]
	for {set i 0} {$i < $n} {incr i} {
			set x [ string index $qpath $i]
			if { [string compare $x "{"] == 0 | [string compare $x "}"] == 0 } {
				set qpath [string replace $qpath $i $i ""]
			}
			if { [string compare $x "\\"] == 0 } {
				set qpath [string replace $qpath $i $i "/"]
			}
		}
	dashboard_set_property ${dash_path} QuartusInstallPathTextField text $qpath
	set ::SeedAnalyze_MainControl::QuartusInstallationPath $qpath
	
}

proc QPFPath {dash_path index} {
	set ::SeedAnalyze_MainControl::QuartusQPF_Path [dashboard_get_property ${dash_path} QPF_NavigateButton($index) paths]
	set qpath [file nativename $::SeedAnalyze_MainControl::QuartusQPF_Path]
	set n [string length $qpath]
	for {set i 0} {$i < $n} {incr i} {
			set x [ string index $qpath $i]
			if { [string compare $x "{"] == 0 | [string compare $x "}"] == 0 } {
				set qpath [string replace $qpath $i $i ""]
			}
			if { [string compare $x "\\"] == 0 } {
				set qpath [string replace $qpath $i $i "/"]
			}
		}
		
		set n [string length $qpath]
		set x_2d [ string index $qpath [expr $n-3] ]
		set x_1d [ string index $qpath [expr $n-2] ]
		set x    [ string index $qpath [expr $n-1] ]
		if { [string compare $x "f"] == 0 & [string compare $x_1d "p"] == 0 & [string compare $x_2d "q"] == 0 } {
			dashboard_set_property ${dash_path} MessageWindowTextField text ""	
		} else {
			dashboard_set_property ${dash_path} MessageWindowTextField text "Please select .qpf file from project folder"	
		}
	
	dashboard_set_property ${dash_path} QuartusQPFPathTextField($index) text $qpath
	#set ::SeedAnalyze_MainControl::QuartusQPFPath($index) $qpath	
}

proc EnterQPFInfo {dash_path} {
	set ::MLD_MainControl::QPFNumSelection [dashboard_get_property ${dash_path} QPFNumCombo selected ]
	dashboard_set_property ${dash_path} MessageWindowTextField text "Enter QPF File Path and finally click on Generate Constraints button"

		for {set i 0} {$i <  $::MLD_MainControl::QPFNumSelection } {incr i} {
			dashboard_set_property ${dash_path} QuartusQPFPathLabel($i) visible true
			dashboard_set_property ${dash_path} QuartusQPFPathTextField($i) visible true
			dashboard_set_property ${dash_path} QPF_NavigateButton($i) visible true
		}

		for {set i  $::MLD_MainControl::QPFNumSelection } {$i < 10} {incr i} {
			dashboard_set_property ${dash_path} QuartusQPFPathLabel($i) visible false
			dashboard_set_property ${dash_path} QuartusQPFPathTextField($i) visible false
			dashboard_set_property ${dash_path} QPF_NavigateButton($i) visible false
		}

}

proc GenerateConstraints {dash_path} {

	dashboard_set_property ${dash_path} MessageWindowTextField text "Constraints Generation started"
	set ::SeedAnalyze_MainControl::QuartusInstallationPath [dashboard_get_property ${dash_path} QuartusInstallPathTextField text ]
	set ::SeedAnalyze_MainControl::clkVar [dashboard_get_property ${dash_path} clkTextField text ]
	set ::SeedAnalyze_MainControl::QPFNumVar [dashboard_get_property ${dash_path} QPFNumCombo selected]
	
	for {set i 0} {$i < 10} {incr i} {
	        set ::SeedAnalyze_MainControl::QuartusQPFPath($i) [dashboard_get_property ${dash_path} QuartusQPFPathTextField($i) text ]
	}
	
set quartus_sta        "$::SeedAnalyze_MainControl::QuartusInstallationPath/quartus_sta"
set clk_name            $::SeedAnalyze_MainControl::clkVar
set no_path            $::SeedAnalyze_MainControl::QPFNumVar

after 2000

        dashboard_set_property ${dash_path} MessageWindowTextField text "Analyze Timing Report is running"
        puts $quartus_sta
        puts $clk_name
	puts $no_path
	set proj_path [open "input_qpf_path.txt" "w+"]
	for {set i 0} {$i < 10} {incr i} {
        set qpf_path($i) $::SeedAnalyze_MainControl::QuartusQPFPath($i)
        
	puts "project path : $qpf_path($i)"
	puts $proj_path $qpf_path($i)
		}
	close $proj_path
	set cur_dir [pwd]
        exec $quartus_sta -t  seedanalyze_cat.tcl $quartus_sta $clk_name $no_path $cur_dir
        dashboard_set_property ${dash_path} MessageWindowTextField text "Comparison Report Generated !"

	
}

 

}
