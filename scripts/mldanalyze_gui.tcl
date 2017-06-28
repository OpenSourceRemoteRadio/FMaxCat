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

namespace eval MLDAnalyze_MainControl {
  
namespace export ConfigureTxSysrefMode ConfigureRxSysrefMode GetGuiProperties ConfigurePatternGenerator ConfigurePatternChecker    
  
	 variable QuartusInstallationPath
	 variable QuartusProjectPath
	 variable QSFNumVar
	 #variable QuartusQSFPath 
	 variable QSFNumSelection
	 variable DISABLE_MAXDELAY

proc MLDAnalyze_DashBoard { dash_path tabGroup } {

set ::MLDAnalyze_MainControl::DISABLE_MAXDELAY "true"
#image create photo imgobj -file "bigcat_logo.png" -width 400 -height 400 
#pack [label .myLabel]
#.myLabel configure -image imgobj 
     
#Main control widgets
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
dashboard_set_property ${dash_path} NavigateButton onChoose "::MLDAnalyze_MainControl::QuartusPath $dash_path"

###############################################################################

dashboard_add ${dash_path} QuartusProjectPathLabel label InputData
dashboard_set_property ${dash_path} QuartusProjectPathLabel expandableY false
dashboard_set_property ${dash_path} QuartusProjectPathLabel expandableX false
dashboard_set_property ${dash_path} QuartusProjectPathLabel text "Quartus Project File:"

dashboard_add ${dash_path} QuartusProjectPathTextField textField InputData
dashboard_set_property ${dash_path} QuartusProjectPathTextField expandableY false
dashboard_set_property ${dash_path} QuartusProjectPathTextField expandableX false
dashboard_set_property ${dash_path} QuartusProjectPathTextField editable true
dashboard_set_property ${dash_path} QuartusProjectPathTextField preferredWidth 700
dashboard_set_property ${dash_path} QuartusProjectPathTextField text "F:/Timing_Improvement/8C4T/duc_8c4t_DUT.qpf"
dashboard_set_property ${dash_path} QuartusProjectPathTextField toolTip "Point to the QPF file of the required project"

dashboard_add ${dash_path} NavigateButton1 fileChooserButton InputData
dashboard_set_property ${dash_path} NavigateButton1 expandableX false
dashboard_set_property ${dash_path} NavigateButton1 expandableY false
dashboard_set_property ${dash_path} NavigateButton1 preferredWidth 30
dashboard_set_property ${dash_path} NavigateButton1 text ".."
dashboard_set_property ${dash_path} NavigateButton1 title "Project folder (.qpf file)"
dashboard_set_property ${dash_path} NavigateButton1 mode "files_only"
dashboard_set_property ${dash_path} NavigateButton1 filter [list "QPF FILE (.qpf)" "qpf"] 
dashboard_set_property ${dash_path} NavigateButton1 chooserButtonText "Select"
dashboard_set_property ${dash_path} NavigateButton1 onChoose "::MLDAnalyze_MainControl::ProjectPath $dash_path"

###############################################################################

#Number of constraints
dashboard_add ${dash_path} QSFSelectionGroup group topGroup
dashboard_set_property ${dash_path} QSFSelectionGroup itemsPerRow 4
dashboard_set_property ${dash_path} QSFSelectionGroup expandableX false
dashboard_set_property ${dash_path} QSFSelectionGroup expandableY false
dashboard_set_property ${dash_path} QSFSelectionGroup preferredWidth 1000
dashboard_set_property ${dash_path} QSFSelectionGroup title "Generate Constraints"

dashboard_add ${dash_path} ModuleNumLabel label QSFSelectionGroup
dashboard_set_property ${dash_path} ModuleNumLabel expandableY false
dashboard_set_property ${dash_path} ModuleNumLabel expandableX false
dashboard_set_property ${dash_path} ModuleNumLabel preferredWidth 150
dashboard_set_property ${dash_path} ModuleNumLabel text "Number of modules:"

dashboard_add ${dash_path} QSFNumCombo comboBox QSFSelectionGroup
dashboard_set_property ${dash_path} QSFNumCombo expandableY false
dashboard_set_property ${dash_path} QSFNumCombo expandableX false
dashboard_set_property ${dash_path} QSFNumCombo preferredWidth 70
dashboard_set_property ${dash_path} QSFNumCombo options { "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
dashboard_set_property ${dash_path} QSFNumCombo toolTip "Enter no. of modules for which QSF constraints need to be analyzed (MAX 10)"
dashboard_set_property ${dash_path} QSFNumCombo onChange "::MLDAnalyze_MainControl::EnterQSFInfo $dash_path"

dashboard_add ${dash_path} emptyLabel1 label QSFSelectionGroup
dashboard_set_property ${dash_path} emptyLabel1 expandableX false
dashboard_set_property ${dash_path} emptyLabel1 expandableY false
dashboard_set_property ${dash_path} emptyLabel1 text ""
dashboard_set_property ${dash_path} emptyLabel1 preferredWidth 210

dashboard_add ${dash_path} emptyLabel2 label QSFSelectionGroup
dashboard_set_property ${dash_path} emptyLabel2 expandableX false
dashboard_set_property ${dash_path} emptyLabel2 expandableY false
dashboard_set_property ${dash_path} emptyLabel2 text ""
dashboard_set_property ${dash_path} emptyLabel2 preferredWidth 210



for {set i 0} {$i < 10} {incr i} {

dashboard_add ${dash_path} QuartusQSFPathLabel($i) label QSFSelectionGroup 
dashboard_set_property ${dash_path} QuartusQSFPathLabel($i) expandableY false
dashboard_set_property ${dash_path} QuartusQSFPathLabel($i) expandableX false
dashboard_set_property ${dash_path} QuartusQSFPathLabel($i) visible false
dashboard_set_property ${dash_path} QuartusQSFPathLabel($i) text "MLD QSF path [expr {$i + 1}]:"

dashboard_add ${dash_path} QuartusQSFPathTextField($i) textField QSFSelectionGroup 
dashboard_set_property ${dash_path} QuartusQSFPathTextField($i) expandableY false
dashboard_set_property ${dash_path} QuartusQSFPathTextField($i) expandableX false
dashboard_set_property ${dash_path} QuartusQSFPathTextField($i) editable true
dashboard_set_property ${dash_path} QuartusQSFPathTextField($i) visible  false
dashboard_set_property ${dash_path} QuartusQSFPathTextField($i) preferredWidth 700
dashboard_set_property ${dash_path} QuartusQSFPathTextField($i) text ""
dashboard_set_property ${dash_path} QuartusQSFPathTextField($i) toolTip "Point to the QPF file of the required project"

dashboard_add ${dash_path} QSF_NavigateButton($i) fileChooserButton QSFSelectionGroup 
dashboard_set_property ${dash_path} QSF_NavigateButton($i) expandableX false
dashboard_set_property ${dash_path} QSF_NavigateButton($i) expandableY false
dashboard_set_property ${dash_path} QSF_NavigateButton($i) preferredWidth 30
dashboard_set_property ${dash_path} QSF_NavigateButton($i) visible false
dashboard_set_property ${dash_path} QSF_NavigateButton($i) text ".."
dashboard_set_property ${dash_path} QSF_NavigateButton($i) title "Project folder (.qsf file)"
dashboard_set_property ${dash_path} QSF_NavigateButton($i) mode "files_only"
dashboard_set_property ${dash_path} QSF_NavigateButton($i) filter [list "QSF FILE (.qsf)" "qsf"]
dashboard_set_property ${dash_path} QSF_NavigateButton($i) chooserButtonText "Select"
dashboard_set_property ${dash_path} QSF_NavigateButton($i) onChoose "::MLDAnalyze_MainControl::QSFPath $dash_path $i"

dashboard_add ${dash_path} emptyLabel3 label QSFSelectionGroup
dashboard_set_property ${dash_path} emptyLabel3 expandableX false
dashboard_set_property ${dash_path} emptyLabel3 expandableY false
dashboard_set_property ${dash_path} emptyLabel3 text ""
dashboard_set_property ${dash_path} emptyLabel3 preferredWidth 210
}

dashboard_add ${dash_path} ConfigureButton button QSFSelectionGroup 
dashboard_set_property ${dash_path} ConfigureButton expandableX false
dashboard_set_property ${dash_path} ConfigureButton expandableY false
dashboard_set_property ${dash_path} ConfigureButton text " Analyze & Generate constraints"
dashboard_set_property ${dash_path} ConfigureButton toolTip "Generates the selected constraints for selected modules"
dashboard_set_property ${dash_path} ConfigureButton onClick "::MLDAnalyze_MainControl::GenerateConstraints $dash_path"

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
	set ::MLDAnalyze_MainControl::QuartusInstallationPath [dashboard_get_property ${dash_path} NavigateButton paths]
	set qpath [file nativename $::MLDAnalyze_MainControl::QuartusInstallationPath]
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
	set ::MLDAnalyze_MainControl::QuartusInstallationPath $qpath
	
}

proc ProjectPath {dash_path} {
	set ::MLDAnalyze_MainControl::QuartusProjectPath [dashboard_get_property ${dash_path} NavigateButton1 paths]
	set qpath [file nativename $::MLDAnalyze_MainControl::QuartusProjectPath]
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
	
	dashboard_set_property ${dash_path} QuartusProjectPathTextField text $qpath
	set ::MLDAnalyze_MainControl::QuartusProjectPath $qpath	
}

proc QSFPath {dash_path index} {
	set ::MLDAnalyze_MainControl::QuartusQSF_Path [dashboard_get_property ${dash_path} QSF_NavigateButton($index) paths]
	set qpath [file nativename $::MLDAnalyze_MainControl::QuartusQSF_Path]
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
	
	dashboard_set_property ${dash_path} QuartusQSFPathTextField($index) text $qpath
	#set ::MLDAnalyze_MainControl::QuartusQSFPath($index) $qpath	
}

proc EnterQSFInfo {dash_path} {
	set ::MLD_MainControl::QSFNumSelection [dashboard_get_property ${dash_path} QSFNumCombo selected ]
	dashboard_set_property ${dash_path} MessageWindowTextField text "Enter QSF File Path and finally click on Generate Constraints button"

		for {set i 0} {$i <  $::MLD_MainControl::QSFNumSelection } {incr i} {
			dashboard_set_property ${dash_path} QuartusQSFPathLabel($i) visible true
			dashboard_set_property ${dash_path} QuartusQSFPathTextField($i) visible true
			dashboard_set_property ${dash_path} QSF_NavigateButton($i) visible true
		}

		for {set i  $::MLD_MainControl::QSFNumSelection } {$i < 10} {incr i} {
			dashboard_set_property ${dash_path} QuartusQSFPathLabel($i) visible false
			dashboard_set_property ${dash_path} QuartusQSFPathTextField($i) visible false
			dashboard_set_property ${dash_path} QSF_NavigateButton($i) visible false
		}

}

proc GenerateConstraints {dash_path} {

	dashboard_set_property ${dash_path} MessageWindowTextField text "Constraints Generation started"
	set ::MLDAnalyze_MainControl::QuartusInstallationPath [dashboard_get_property ${dash_path} QuartusInstallPathTextField text ]
	set ::MLDAnalyze_MainControl::QuartusProjectPath [dashboard_get_property ${dash_path} QuartusProjectPathTextField text ]
	set ::MLDAnalyze_MainControl::QSFNumVar [dashboard_get_property ${dash_path} QSFNumCombo selected]
	
	for {set i 0} {$i < 10} {incr i} {
	        set ::MLDAnalyze_MainControl::QuartusQSFPath($i) [dashboard_get_property ${dash_path} QuartusQSFPathTextField($i) text ]
	}
	
set quartus_sta        "$::MLDAnalyze_MainControl::QuartusInstallationPath/quartus_sta"
set prj_qpf            "$::MLDAnalyze_MainControl::QuartusProjectPath"

after 2000
	dashboard_set_property ${dash_path} MessageWindowTextField text "Constraints Generation is running"
		       puts $quartus_sta
		       puts $prj_qpf
		for {set i 0} {$i < ${::MLDAnalyze_MainControl::QSFNumVar}} {incr i} {
		       set qsf_path $::MLDAnalyze_MainControl::QuartusQSFPath($i)
		       puts $qsf_path
		       exec $quartus_sta -t  mldanalyze_cat.tcl $quartus_sta $prj_qpf $qsf_path
		       dashboard_set_property ${dash_path} MessageWindowTextField text "MLDAnalyze constraints for Module [expr $i + 1] have been generated - Constraints generation still in progress !"
		}
	
	dashboard_set_property ${dash_path} MessageWindowTextField text "Constraints Generation Finished -- Check your project path for Fmax_cat folder containing selected constraints"
}

 

}
