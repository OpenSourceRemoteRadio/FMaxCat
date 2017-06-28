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

namespace eval FloorCat_MainControl {
  
namespace export ConfigureTxSysrefMode ConfigureRxSysrefMode GetGuiProperties ConfigurePatternGenerator ConfigurePatternChecker    
  
	 variable QuartusInstallationPath
	 variable QuartusProjectPath
	 variable CSVFilePath
	 #variable QuartusQPFPath 
	 #variable DISABLE_MAXDELAY

proc FloorCat_DashBoard { dash_path tabGroup } {

#set ::FloorCat_MainControl::DISABLE_MAXDELAY "true"
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
dashboard_set_property ${dash_path} NavigateButton onChoose "::FloorCat_MainControl::QuartusPath $dash_path"

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
dashboard_set_property ${dash_path} NavigateButton1 onChoose "::FloorCat_MainControl::ProjectPath $dash_path"

###############################################################################
dashboard_add ${dash_path} CSVFilePathLabel label InputData
dashboard_set_property ${dash_path} CSVFilePathLabel expandableY false
dashboard_set_property ${dash_path} CSVFilePathLabel expandableX false
dashboard_set_property ${dash_path} CSVFilePathLabel text "Input CSV File:"

dashboard_add ${dash_path} CSVFilePathTextField textField InputData
dashboard_set_property ${dash_path} CSVFilePathTextField expandableY false
dashboard_set_property ${dash_path} CSVFilePathTextField expandableX false
dashboard_set_property ${dash_path} CSVFilePathTextField editable true
dashboard_set_property ${dash_path} CSVFilePathTextField preferredWidth 700
dashboard_set_property ${dash_path} CSVFilePathTextField text "F:/FloorCat_Input.csv"
dashboard_set_property ${dash_path} CSVFilePathTextField toolTip "Point to the csv file"

dashboard_add ${dash_path} NavigateButton2 fileChooserButton InputData
dashboard_set_property ${dash_path} NavigateButton2 expandableX false
dashboard_set_property ${dash_path} NavigateButton2 expandableY false
dashboard_set_property ${dash_path} NavigateButton2 preferredWidth 30
dashboard_set_property ${dash_path} NavigateButton2 text ".."
dashboard_set_property ${dash_path} NavigateButton2 title "Project folder (.csv file)"
dashboard_set_property ${dash_path} NavigateButton2 mode "files_only"
dashboard_set_property ${dash_path} NavigateButton2 filter [list "CSV FILE (.csv)" "csv"]
dashboard_set_property ${dash_path} NavigateButton2 chooserButtonText "Select"
dashboard_set_property ${dash_path} NavigateButton2 onChoose "::FloorCat_MainControl::CSVPath $dash_path"


###############################################################################


dashboard_add ${dash_path} QPFSelectionGroup group topGroup
dashboard_set_property ${dash_path} QPFSelectionGroup itemsPerRow 4
dashboard_set_property ${dash_path} QPFSelectionGroup expandableX false
dashboard_set_property ${dash_path} QPFSelectionGroup expandableY false
dashboard_set_property ${dash_path} QPFSelectionGroup preferredWidth 1000
dashboard_set_property ${dash_path} QPFSelectionGroup title "Generate Floorplanning Constraints"



dashboard_add ${dash_path} ConfigureButton button QPFSelectionGroup 
dashboard_set_property ${dash_path} ConfigureButton expandableX false
dashboard_set_property ${dash_path} ConfigureButton expandableY false
dashboard_set_property ${dash_path} ConfigureButton text " Generate FloorPlan constraints"
dashboard_set_property ${dash_path} ConfigureButton toolTip "Generates the FloorPlan constraints for input modules given"
dashboard_set_property ${dash_path} ConfigureButton onClick "::FloorCat_MainControl::GenerateConstraints $dash_path"

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
#############################################################################################################################################
#Syntax: dashboard_get_property ${dash_path} TxIPLocalMultiframeClockPhaseOffsetTextField text]  
#dashboard_get_property ${dash_path} RegWriteReadCombo selected

proc QuartusPath {dash_path} {
	set ::FloorCat_MainControl::QuartusInstallationPath [dashboard_get_property ${dash_path} NavigateButton paths]
	set qpath [file nativename $::FloorCat_MainControl::QuartusInstallationPath]
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
	set ::FloorCat_MainControl::QuartusInstallationPath $qpath
	
}


proc ProjectPath {dash_path} {
	set ::FloorCat_MainControl::QuartusProjectPath [dashboard_get_property ${dash_path} NavigateButton1 paths]
	set qpath [file nativename $::FloorCat_MainControl::QuartusProjectPath]
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
	set ::FloorCat_MainControl::QuartusProjectPath $qpath

}

proc CSVPath {dash_path} {
	set ::FloorCat_MainControl::CSVFilePath [dashboard_get_property ${dash_path} NavigateButton2 paths]
	set qpath [file nativename $::FloorCat_MainControl::CSVFilePath]
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
			dashboard_set_property ${dash_path} MessageWindowTextField text "Please select .csv file from project folder"	
		}
	
	dashboard_set_property ${dash_path} CSVFilePathTextField text $qpath
	set ::FloorCat_MainControl::CSVFilePath $qpath

}

proc GenerateConstraints {dash_path} {

	dashboard_set_property ${dash_path} MessageWindowTextField text "Constraints Generation started"
	set ::FloorCat_MainControl::QuartusInstallationPath [dashboard_get_property ${dash_path} QuartusInstallPathTextField text ]
	set ::FloorCat_MainControl::QuartusProjectPath [dashboard_get_property ${dash_path} QuartusProjectPathTextField text ]
	set ::FloorCat_MainControl::CSVFilePath [dashboard_get_property ${dash_path} CSVFilePathTextField text ]
	
	
set quartus_sta        "$::FloorCat_MainControl::QuartusInstallationPath/quartus_sta"
set prj_qpf		$::FloorCat_MainControl::QuartusProjectPath
set csv_input		$::FloorCat_MainControl::CSVFilePath

after 2000

        dashboard_set_property ${dash_path} MessageWindowTextField text "Generating Floorplan Constraints . . ."
        puts $quartus_sta
        puts $prj_qpf
        exec $quartus_sta -t  floor_cat.tcl $quartus_sta $prj_qpf $csv_input 
        dashboard_set_property ${dash_path} MessageWindowTextField text "FloorPlan Constraints Generated !"
	
}

 

}
