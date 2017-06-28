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

namespace eval MLD_MainControl {
  
namespace export ConfigureTxSysrefMode ConfigureRxSysrefMode GetGuiProperties ConfigurePatternGenerator ConfigurePatternChecker    
  
	 variable QuartusInstallationPath
	 variable QuartusProjectPath
	 variable ModuleNumSelection
	 variable LevelSelection
	 variable DestThresholdVar
#	 variable SDCDestThresholdVar
	 variable clkVar
	 variable GrpThresholdVar
	 variable ModuleNumVar
	 variable DISABLE_MAXDELAY
	 #variable Blockcheck1
	 #variable Blockcheck2
	 #variable BlockNumVar


proc MLD_DashBoard { dash_path tabGroup } {

set ::MLD_MainControl::DISABLE_MAXDELAY "true"
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
dashboard_set_property ${dash_path} NavigateButton onChoose "::MLD_MainControl::QuartusPath $dash_path"


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
dashboard_set_property ${dash_path} NavigateButton1 onChoose "::MLD_MainControl::ProjectPath $dash_path"

dashboard_add ${dash_path} LevelLabel label InputData
dashboard_set_property ${dash_path} LevelLabel expandableY false
dashboard_set_property ${dash_path} LevelLabel expandableX false
dashboard_set_property ${dash_path} LevelLabel preferredWidth 70
dashboard_set_property ${dash_path} LevelLabel text "Level:"

dashboard_add ${dash_path} LevelCombo comboBox InputData
dashboard_set_property ${dash_path} LevelCombo expandableY false
dashboard_set_property ${dash_path} LevelCombo expandableX false
dashboard_set_property ${dash_path} LevelCombo preferredWidth 70
dashboard_set_property ${dash_path} LevelCombo selected 0
dashboard_set_property ${dash_path} LevelCombo options { "TOP" "BLOCK" }
dashboard_set_property ${dash_path} LevelCombo onChange "::MLD_MainControl::LevelChange $dash_path"

dashboard_add ${dash_path} TxemptyLabel1 label InputData
dashboard_set_property ${dash_path} TxemptyLabel1 expandableX false
dashboard_set_property ${dash_path} TxemptyLabel1 expandableY false
dashboard_set_property ${dash_path} TxemptyLabel1 text ""
dashboard_set_property ${dash_path} TxemptyLabel1 preferredWidth 50


dashboard_add ${dash_path} DestThrsLabel label InputData
dashboard_set_property ${dash_path} DestThrsLabel expandableY false
dashboard_set_property ${dash_path} DestThrsLabel expandableX false
dashboard_set_property ${dash_path} DestThrsLabel text "MLD Destination Threshold:"

dashboard_add ${dash_path} DestThrstTextField textField InputData
dashboard_set_property ${dash_path} DestThrstTextField expandableY false
dashboard_set_property ${dash_path} DestThrstTextField expandableX false
dashboard_set_property ${dash_path} DestThrstTextField editable true
dashboard_set_property ${dash_path} DestThrstTextField preferredWidth 70
dashboard_set_property ${dash_path} DestThrstTextField text "150"
dashboard_set_property ${dash_path} DestThrstTextField toolTip "Destination entities to be grouped in MLD"

dashboard_add ${dash_path} TxemptyLabel2 label InputData
dashboard_set_property ${dash_path} TxemptyLabel2 expandableX false
dashboard_set_property ${dash_path} TxemptyLabel2 expandableY false
dashboard_set_property ${dash_path} TxemptyLabel2 text ""
dashboard_set_property ${dash_path} TxemptyLabel2 preferredWidth 50

dashboard_add ${dash_path} GrpThrstLabel label InputData
dashboard_set_property ${dash_path} GrpThrstLabel expandableY false
dashboard_set_property ${dash_path} GrpThrstLabel expandableX false
dashboard_set_property ${dash_path} GrpThrstLabel text "MLD Group Threshold:"

dashboard_add ${dash_path} GrpThrstTextField textField InputData
dashboard_set_property ${dash_path} GrpThrstTextField expandableY false
dashboard_set_property ${dash_path} GrpThrstTextField expandableX false
dashboard_set_property ${dash_path} GrpThrstTextField editable true
dashboard_set_property ${dash_path} GrpThrstTextField preferredWidth 70
dashboard_set_property ${dash_path} GrpThrstTextField text "10"
dashboard_set_property ${dash_path} GrpThrstTextField toolTip "Threshold for grouping destination thresholds"

dashboard_add ${dash_path} TxemptyLabel3 label InputData
dashboard_set_property ${dash_path} TxemptyLabel3 expandableX false
dashboard_set_property ${dash_path} TxemptyLabel3 expandableY false
dashboard_set_property ${dash_path} TxemptyLabel3 text ""
dashboard_set_property ${dash_path} TxemptyLabel3 preferredWidth 50

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




#Number of constraints
dashboard_add ${dash_path} ConstraintSelectionGroup group topGroup
dashboard_set_property ${dash_path} ConstraintSelectionGroup itemsPerRow 2
dashboard_set_property ${dash_path} ConstraintSelectionGroup expandableX false
dashboard_set_property ${dash_path} ConstraintSelectionGroup expandableY false
dashboard_set_property ${dash_path} ConstraintSelectionGroup preferredWidth 1000
dashboard_set_property ${dash_path} ConstraintSelectionGroup title "Generate Constraints"

dashboard_add ${dash_path} ModuleNumLabel label ConstraintSelectionGroup
dashboard_set_property ${dash_path} ModuleNumLabel expandableY false
dashboard_set_property ${dash_path} ModuleNumLabel expandableX false
dashboard_set_property ${dash_path} ModuleNumLabel preferredWidth 150
dashboard_set_property ${dash_path} ModuleNumLabel text "Number of modules:"

dashboard_add ${dash_path} ModuleNumCombo comboBox ConstraintSelectionGroup
dashboard_set_property ${dash_path} ModuleNumCombo expandableY false
dashboard_set_property ${dash_path} ModuleNumCombo expandableX false
dashboard_set_property ${dash_path} ModuleNumCombo preferredWidth 70
dashboard_set_property ${dash_path} ModuleNumCombo options { "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
#dashboard_set_property ${dash_path} ModuleNumCombo selected 4
dashboard_set_property ${dash_path} ModuleNumCombo toolTip "Enter no. of modules for which constraints are to be generated (MAX 10)"
dashboard_set_property ${dash_path} ModuleNumCombo onChange "::MLD_MainControl::EnterModuleInfo $dash_path"

dashboard_add ${dash_path} emptyLabel1 label ConstraintSelectionGroup
dashboard_set_property ${dash_path} emptyLabel1 expandableX false
dashboard_set_property ${dash_path} emptyLabel1 expandableY false
dashboard_set_property ${dash_path} emptyLabel1 text ""
dashboard_set_property ${dash_path} emptyLabel1 preferredWidth 210

dashboard_add ${dash_path} emptyLabel2 label ConstraintSelectionGroup
dashboard_set_property ${dash_path} emptyLabel2 expandableX false
dashboard_set_property ${dash_path} emptyLabel2 expandableY false
dashboard_set_property ${dash_path} emptyLabel2 text ""
dashboard_set_property ${dash_path} emptyLabel2 preferredWidth 210

for {set i 0} {$i < 10} {incr i} {

dashboard_add ${dash_path} ModuleLabel($i) label ConstraintSelectionGroup
dashboard_set_property ${dash_path} ModuleLabel($i) expandableY false
dashboard_set_property ${dash_path} ModuleLabel($i) expandableX false
dashboard_set_property ${dash_path} ModuleLabel($i) visible false
dashboard_set_property ${dash_path} ModuleLabel($i) text "Module name [expr {$i + 1}]:"


dashboard_add ${dash_path} ModuleTextField($i) textField ConstraintSelectionGroup
dashboard_set_property ${dash_path} ModuleTextField($i) expandableY false
dashboard_set_property ${dash_path} ModuleTextField($i) expandableX false
dashboard_set_property ${dash_path} ModuleTextField($i) editable true
dashboard_set_property ${dash_path} ModuleTextField($i) preferredWidth 200
dashboard_set_property ${dash_path} ModuleTextField($i) visible false
dashboard_set_property ${dash_path} ModuleTextField($i) text ""
dashboard_set_property ${dash_path} ModuleTextField($i) toolTip "Enter module name (eg. LCFR/LDUC/DPD)"

}

dashboard_add ${dash_path} ConfigureButton button ConstraintSelectionGroup
dashboard_set_property ${dash_path} ConfigureButton expandableX false
dashboard_set_property ${dash_path} ConfigureButton expandableY false
dashboard_set_property ${dash_path} ConfigureButton text "Generate constraints"
dashboard_set_property ${dash_path} ConfigureButton toolTip "Generates the selected constraints for selected modules"
dashboard_set_property ${dash_path} ConfigureButton onClick "::MLD_MainControl::GenerateConstraints $dash_path"

dashboard_add ${dash_path} MessageWindow group topGroup
dashboard_set_property ${dash_path} MessageWindow expandableX false
dashboard_set_property ${dash_path} MessageWindow expandableY false
dashboard_set_property ${dash_path} MessageWindow title "Message/Warning"
dashboard_set_property ${dash_path} MessageWindow preferredWidth 1000
dashboard_set_property ${dash_path} MessageWindow itemsPerRow 3

#Message/Warning
#dashboard_add ${dash_path} MessageWindowLabel label MessageWindow
#dashboard_set_property ${dash_path} MessageWindowLabel expandableY false
#dashboard_set_property ${dash_path} MessageWindowLabel expandableX false
#dashboard_set_property ${dash_path} MessageWindowLabel text "Message/Warning:"
#
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
	set ::MLD_MainControl::QuartusInstallationPath [dashboard_get_property ${dash_path} NavigateButton paths]
	set qpath [file nativename $::MLD_MainControl::QuartusInstallationPath]
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
	set ::MLD_MainControl::QuartusInstallationPath $qpath
	
}

proc ProjectPath {dash_path} {
	set ::MLD_MainControl::QuartusProjectPath [dashboard_get_property ${dash_path} NavigateButton1 paths]
	set qpath [file nativename $::MLD_MainControl::QuartusProjectPath]
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
	set ::MLD_MainControl::QuartusProjectPath $qpath	
}


proc LevelChange {dash_path} {
	set ::MLD_MainControl::LevelSelection [dashboard_get_property ${dash_path} LevelCombo selected ]
	if {${::MLD_MainControl::LevelSelection} == 0} {
		#CHIP
		dashboard_set_property ${dash_path} ModuleNumCombo options { "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
		dashboard_set_property ${dash_path} ModuleNumCombo toolTip "Enter no. of modules for which constraints are to be generated (MAX 10)"
		dashboard_set_property ${dash_path} ModuleLabel(0) text "Module name 1"
	} else {
		#set level "BLOCK"
		for {set i 1} {$i < 10} {incr i} {
			dashboard_set_property ${dash_path} ModuleLabel($i) visible false
			dashboard_set_property ${dash_path} ModuleTextField($i) visible false
		}
		dashboard_set_property ${dash_path} ModuleNumCombo options { "0" "1" }
		dashboard_set_property ${dash_path} ModuleNumCombo toolTip "Constraints are generated for entire project"
		dashboard_set_property ${dash_path} ModuleLabel(0) text "Block name"
	}
}



proc EnterModuleInfo {dash_path} {
	set ::MLD_MainControl::ModuleNumSelection [dashboard_get_property ${dash_path} ModuleNumCombo selected ]
	dashboard_set_property ${dash_path} MessageWindowTextField text "Enter names of modules, tick the checkboxes for required constraints and finally click on Generate Constraints button"

		for {set i 0} {$i <  $::MLD_MainControl::ModuleNumSelection } {incr i} {
			dashboard_set_property ${dash_path} ModuleTextField($i) visible true
			dashboard_set_property ${dash_path} ModuleLabel($i) visible true

		}

		for {set i  $::MLD_MainControl::ModuleNumSelection } {$i < 10} {incr i} {
			dashboard_set_property ${dash_path} ModuleTextField($i) visible false
			dashboard_set_property ${dash_path} ModuleLabel($i) visible false

		}

}


proc GenerateConstraints {dash_path} {

	dashboard_set_property ${dash_path} MessageWindowTextField text "Constraints Generation started"
	set ::MLD_MainControl::QuartusInstallationPath [dashboard_get_property ${dash_path} QuartusInstallPathTextField text ]
	set ::MLD_MainControl::QuartusProjectPath [dashboard_get_property ${dash_path} QuartusProjectPathTextField text ]
	set ::MLD_MainControl::LevelSelection [dashboard_get_property ${dash_path} LevelCombo selected ]
	set ::MLD_MainControl::DestThresholdVar [dashboard_get_property ${dash_path} DestThrstTextField text ]
	set ::MLD_MainControl::GrpThresholdVar [dashboard_get_property ${dash_path} GrpThrstTextField text ]
#	set ::MLD_MainControl::SDCDestThresholdVar [dashboard_get_property ${dash_path} SDCDestThrstTextField text ]	
	set ::MLD_MainControl::clkVar [dashboard_get_property ${dash_path} clkTextField text ]	
	set ::MLD_MainControl::ModuleNumVar [dashboard_get_property ${dash_path} ModuleNumCombo selected]
	
	for {set i 0} {$i < 10} {incr i} {
		set ::MLD_MainControl::BlockNumVar($i) [dashboard_get_property ${dash_path} ModuleTextField($i) text]
		#puts "${::MLD_MainControl::BlockNumVar($i)}"
	}
	
set quartus_sta        "$::MLD_MainControl::QuartusInstallationPath/quartus_sta"
#puts "$quartus_sta"
set prj_qpf            "$::MLD_MainControl::QuartusProjectPath"
#puts "$prj_qpf"

# BLOCK / CHIP
	if {${::MLD_MainControl::LevelSelection} == 0} {
		set level "CHIP"
	} else {
		set level "BLOCK"
	}
#puts "$level"
  
# For CHIP, Specifiy the Key word of the block 
set mld_dest_thrsh $::MLD_MainControl::DestThresholdVar
#set sdc_dest_thrsh $::MLD_MainControl::SDCDestThresholdVar
set grp_thrsh $::MLD_MainControl::GrpThresholdVar
set clk_name $::MLD_MainControl::clkVar

#puts "$mld_dest_thrsh"
#puts "$sdc_dest_thrsh"
#puts "$grp_thrsh"
after 2000
	dashboard_set_property ${dash_path} MessageWindowTextField text "Constraints Generation is running"
	if { ${::MLD_MainControl::ModuleNumVar} != 0 } {
		for {set i 0} {$i < ${::MLD_MainControl::ModuleNumVar}} {incr i} {
			set block_name $::MLD_MainControl::BlockNumVar($i)
		       exec $quartus_sta -t  mld_cat.tcl $quartus_sta $prj_qpf $level $mld_dest_thrsh $grp_thrsh $clk_name $block_name
		       dashboard_set_property ${dash_path} MessageWindowTextField text "MLD constraints for Module [expr $i + 1] have been generated - Constraints generation still in progress !"
		}
	} else {
		set block_name $::MLD_MainControl::BlockNumVar(0)
		set MLDchoice $::MLD_MainControl::Blockcheck1($i)
			exec $quartus_sta -t  mld_cat.tcl $quartus_sta $prj_qpf $level $mld_dest_thrsh $grp_thrsh $clk_name $block_name
			dashboard_set_property ${dash_path} MessageWindowTextField text "MLD constraints for Block have been generated"
	}	
	
	dashboard_set_property ${dash_path} MessageWindowTextField text "Constraints Generation Finished -- Check your project path for Fmax_cat folder containing selected constraints"
}

 

}
