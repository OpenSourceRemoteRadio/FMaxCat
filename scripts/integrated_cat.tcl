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

namespace eval Integrated_MainControl {
  
namespace export ConfigureTxSysrefMode ConfigureRxSysrefMode GetGuiProperties ConfigurePatternGenerator ConfigurePatternChecker    
  
	 variable QuartusInstallationPath
	 variable QuartusProjectPath
	 variable ModuleNumSelection
	 variable LevelSelection
	 variable DestThresholdVar
	 variable clkVar
	 variable GrpThresholdVar
	 variable ModuleNumVar
	 variable DISABLE_MAXDELAY
	 variable FloorPlanPath 


proc Integrated_DashBoard { dash_path tabGroup } {

set ::Integrated_MainControl::DISABLE_MAXDELAY "true"

set ::Integrated_MainControl::MLD_CHK false 
set ::Integrated_MainControl::MAX_CHK false 
set ::Integrated_MainControl::FP_CHK false 
set ::Integrated_MainControl::Seed_CHK false 
set ::Integrated_MainControl::Max_Seed_CHK false 
set ::Integrated_MainControl::Seed_Analyze_CHK false 

#image create photo imgobj -file "bigcat_logo.png" -width 400 -height 400 
#pack [label .myLabel]
#.myLabel configure -image imgobj 
     
#Main control widgets
dashboard_add ${dash_path} topGroup group self
dashboard_set_property ${dash_path} topGroup expandableX true
dashboard_set_property ${dash_path} topGroup expandableY true
dashboard_set_property ${dash_path} topGroup itemsPerRow 1
dashboard_set_property ${dash_path} topGroup title "" 

dashboard_add ${dash_path} logo group topGroup
dashboard_set_property ${dash_path} logo expandableX false
dashboard_set_property ${dash_path} logo expandableY false
dashboard_set_property ${dash_path} logo preferredWidth 1500
dashboard_set_property ${dash_path} logo title ""
dashboard_set_property ${dash_path} logo itemsPerRow 4
dashboard_set_property ${dash_path} logo visible true 

dashboard_add ${dash_path} bcw_dummy label logo
dashboard_set_property ${dash_path} bcw_dummy  expandableY false
dashboard_set_property ${dash_path} bcw_dummy  expandableX false
dashboard_set_property ${dash_path} bcw_dummy  preferredWidth 600
dashboard_set_property ${dash_path} bcw_dummy  text ""
dashboard_set_property ${dash_path} bcw_dummy  visible true 

dashboard_add ${dash_path} bcw_dummy1 label logo
dashboard_set_property ${dash_path} bcw_dummy1  expandableY false
dashboard_set_property ${dash_path} bcw_dummy1  expandableX false
dashboard_set_property ${dash_path} bcw_dummy1  preferredWidth 600
dashboard_set_property ${dash_path} bcw_dummy1  text ""
dashboard_set_property ${dash_path} bcw_dummy1  visible true

dashboard_add ${dash_path} bcw_dummy2 label logo
dashboard_set_property ${dash_path} bcw_dummy2  expandableY false
dashboard_set_property ${dash_path} bcw_dummy2  expandableX false
dashboard_set_property ${dash_path} bcw_dummy2  preferredWidth 600
dashboard_set_property ${dash_path} bcw_dummy2  text ""
dashboard_set_property ${dash_path} bcw_dummy2  visible true

set curr_dir [pwd]
dashboard_add ${dash_path} bcw_logo bitmap logo
dashboard_set_property ${dash_path} bcw_logo  expandableY true
dashboard_set_property ${dash_path} bcw_logo  expandableX true
dashboard_set_property ${dash_path} bcw_logo  maxWidth 400 
dashboard_set_property ${dash_path} bcw_logo  maxHeight 200
dashboard_set_property ${dash_path} bcw_logo  visible true
dashboard_set_property ${dash_path} bcw_logo  baseDirectory "$curr_dir"
dashboard_set_property ${dash_path} bcw_logo  path "bigcat_logo.gif"
#dashboard_set_property ${dash_path} bcw_logo  path "intel_logo.gif"

###############################################################################
#                  INPUT CONFIGURATION 
###############################################################################
dashboard_add ${dash_path} InputData group topGroup
dashboard_set_property ${dash_path} InputData expandableX false
dashboard_set_property ${dash_path} InputData expandableY false
dashboard_set_property ${dash_path} InputData preferredWidth 900
dashboard_set_property ${dash_path} InputData title "Input Configuration"
dashboard_set_property ${dash_path} InputData itemsPerRow 3
dashboard_set_property ${dash_path} InputData visible true 

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
#dashboard_set_property ${dash_path} QuartusInstallPathTextField text "D:/altera/quartus/bin64"
dashboard_set_property ${dash_path} QuartusInstallPathTextField text "D:/altera/15.1.185_std/quartus/bin64"
dashboard_set_property ${dash_path} QuartusInstallPathTextField toolTip "Enter Quartus installation location upto bin64/"

dashboard_add ${dash_path} NavigateButton fileChooserButton InputData
dashboard_set_property ${dash_path} NavigateButton expandableX false
dashboard_set_property ${dash_path} NavigateButton expandableY false
dashboard_set_property ${dash_path} NavigateButton preferredWidth 30
dashboard_set_property ${dash_path} NavigateButton text ".."
dashboard_set_property ${dash_path} NavigateButton title "Quartus installation folder"
dashboard_set_property ${dash_path} NavigateButton mode "directories_only"
dashboard_set_property ${dash_path} NavigateButton chooserButtonText "Select"
dashboard_set_property ${dash_path} NavigateButton onChoose "::Integrated_MainControl::QuartusPath $dash_path"


dashboard_add ${dash_path} QuartusProjectPathLabel label InputData
dashboard_set_property ${dash_path} QuartusProjectPathLabel expandableY false
dashboard_set_property ${dash_path} QuartusProjectPathLabel expandableX false
dashboard_set_property ${dash_path} QuartusProjectPathLabel text "Quartus Project File:"

dashboard_add ${dash_path} QuartusProjectPathTextField textField InputData
dashboard_set_property ${dash_path} QuartusProjectPathTextField expandableY false
dashboard_set_property ${dash_path} QuartusProjectPathTextField expandableX false
dashboard_set_property ${dash_path} QuartusProjectPathTextField editable true
dashboard_set_property ${dash_path} QuartusProjectPathTextField preferredWidth 700
#dashboard_set_property ${dash_path} QuartusProjectPathTextField text "F:/Timing_Improvement/8C4T/duc_8c4t_DUT.qpf"
dashboard_set_property ${dash_path} QuartusProjectPathTextField text "E:/seed_sweep/ddc_1x8_DDC_restored/ddc_1x8_DDC_restored/ddc_1x8_DDC.qpf"
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
dashboard_set_property ${dash_path} NavigateButton1 onChoose "::Integrated_MainControl::ProjectPath $dash_path"

dashboard_add ${dash_path} QuartusSDCPathLabel label InputData
dashboard_set_property ${dash_path} QuartusSDCPathLabel expandableY false
dashboard_set_property ${dash_path} QuartusSDCPathLabel expandableX false
dashboard_set_property ${dash_path} QuartusSDCPathLabel text "Quartus SDC File:"

dashboard_add ${dash_path} QuartusSDCPathTextField textField InputData
dashboard_set_property ${dash_path} QuartusSDCPathTextField expandableY false
dashboard_set_property ${dash_path} QuartusSDCPathTextField expandableX false
dashboard_set_property ${dash_path} QuartusSDCPathTextField editable true
dashboard_set_property ${dash_path} QuartusSDCPathTextField preferredWidth 700
#dashboard_set_property ${dash_path} QuartusSDCPathTextField text "F:/Timing_Improvement/8C4T/duc_8c4t_DUT.sdc"
dashboard_set_property ${dash_path} QuartusSDCPathTextField text "E:/seed_sweep/ddc_1x8_DDC_restored/ddc_1x8_DDC_restored/rtl/ddc_1x8/ddc_1x8_DDC.sdc"
dashboard_set_property ${dash_path} QuartusSDCPathTextField toolTip "Point to the main SDC file of the required project"

dashboard_add ${dash_path} SDC_NavigateButton fileChooserButton InputData
dashboard_set_property ${dash_path} SDC_NavigateButton expandableX false
dashboard_set_property ${dash_path} SDC_NavigateButton expandableY false
dashboard_set_property ${dash_path} SDC_NavigateButton preferredWidth 30
dashboard_set_property ${dash_path} SDC_NavigateButton text ".."
dashboard_set_property ${dash_path} SDC_NavigateButton title "Project folder (.sdc file)"
dashboard_set_property ${dash_path} SDC_NavigateButton mode "files_only"
dashboard_set_property ${dash_path} SDC_NavigateButton filter [list "SDC FILE (.sdc)" "sdc"]
dashboard_set_property ${dash_path} SDC_NavigateButton chooserButtonText "Select"
dashboard_set_property ${dash_path} SDC_NavigateButton onChoose "::Integrated_MainControl::SDCPath $dash_path"



dashboard_add ${dash_path} clkLabel label InputData
dashboard_set_property ${dash_path} clkLabel expandableY false
dashboard_set_property ${dash_path} clkLabel expandableX false
dashboard_set_property ${dash_path} clkLabel preferredWidth 200
dashboard_set_property ${dash_path} clkLabel text "CLK:"

dashboard_add ${dash_path} clkTextField textField InputData
dashboard_set_property ${dash_path} clkTextField expandableY false
dashboard_set_property ${dash_path} clkTextField expandableX false
dashboard_set_property ${dash_path} clkTextField editable true
dashboard_set_property ${dash_path} clkTextField preferredWidth 200
#dashboard_set_property ${dash_path} clkTextField text "u_a10_soc|iopll_dsp|outclk0"
dashboard_set_property ${dash_path} clkTextField text "clk"
dashboard_set_property ${dash_path} clkTextField toolTip "Enter full hierarchy of clock(as it appears in timing report) on which timing is to be closed"






###############################################################################
#                   SEED RUN 
###############################################################################


#Number of constraints
dashboard_add ${dash_path} ST_GRP  group topGroup
dashboard_set_property ${dash_path} ST_GRP itemsPerRow 4
dashboard_set_property ${dash_path} ST_GRP expandableX false
dashboard_set_property ${dash_path} ST_GRP expandableY false
dashboard_set_property ${dash_path} ST_GRP preferredWidth 800
dashboard_set_property ${dash_path} ST_GRP title "FLOW "

##################STEP1##########################################
dashboard_add ${dash_path} ST_Step1 label ST_GRP 
dashboard_set_property ${dash_path} ST_Step1 expandableY false
dashboard_set_property ${dash_path} ST_Step1 expandableX false
dashboard_set_property ${dash_path} ST_Step1 preferredWidth 200
dashboard_set_property ${dash_path} ST_Step1 text "STEP 1:"

dashboard_add ${dash_path} ST_Basecheck1 checkBox ST_GRP 
dashboard_set_property ${dash_path} ST_Basecheck1 expandableY false
dashboard_set_property ${dash_path} ST_Basecheck1 expandableX false
dashboard_set_property ${dash_path} ST_Basecheck1 preferredWidth 200 
dashboard_set_property ${dash_path} ST_Basecheck1 visible true
dashboard_set_property ${dash_path} ST_Basecheck1 text "Base Run"
dashboard_set_property ${dash_path} ST_Basecheck1 checked false
dashboard_set_property ${dash_path} ST_Basecheck1 toolTip "Click, if the project to be analyzed has not been compiled"

dashboard_add ${dash_path} ST_MLDcheck1 checkBox ST_GRP 
dashboard_set_property ${dash_path} ST_MLDcheck1 expandableY false
dashboard_set_property ${dash_path} ST_MLDcheck1 expandableX false
dashboard_set_property ${dash_path} ST_MLDcheck1 preferredWidth 200 
dashboard_set_property ${dash_path} ST_MLDcheck1 visible true
dashboard_set_property ${dash_path} ST_MLDcheck1 text "MLD constraints"
dashboard_set_property ${dash_path} ST_MLDcheck1 checked false
dashboard_set_property ${dash_path} ST_MLDcheck1 onClick "::Integrated_MainControl::MLD_Input $dash_path"
dashboard_set_property ${dash_path} ST_MLDcheck1 toolTip "Click to generate Manual Logic duplication constraints for nodes with high fanouts"


dashboard_add ${dash_path} ST_MAXcheck1 checkBox ST_GRP 
dashboard_set_property ${dash_path} ST_MAXcheck1 expandableY false
dashboard_set_property ${dash_path} ST_MAXcheck1 expandableX false
dashboard_set_property ${dash_path} ST_MAXcheck1 preferredWidth 200
dashboard_set_property ${dash_path} ST_MAXcheck1 visible true
dashboard_set_property ${dash_path} ST_MAXcheck1 text "MAX constraints"
dashboard_set_property ${dash_path} ST_MAXcheck1 checked false
dashboard_set_property ${dash_path} ST_MAXcheck1 onClick "::Integrated_MainControl::MAX_Input $dash_path"
dashboard_set_property ${dash_path} ST_MAXcheck1 toolTip "Check to generate Fitter overconstraints (max_delay constraints)"


#dashboard_add ${dash_path} ST_FPcheck1 checkBox ST_GRP 
#dashboard_set_property ${dash_path} ST_FPcheck1 expandableY false
#dashboard_set_property ${dash_path} ST_FPcheck1 expandableX false
#dashboard_set_property ${dash_path} ST_FPcheck1 preferredWidth 200
#dashboard_set_property ${dash_path} ST_FPcheck1 visible false
#dashboard_set_property ${dash_path} ST_FPcheck1 text "FP constraints"
#dashboard_set_property ${dash_path} ST_FPcheck1 checked false
#dashboard_set_property ${dash_path} ST_FPcheck1 onClick "::Integrated_MainControl::FP_Input $dash_path"



##################STEP2##########################################

dashboard_add ${dash_path} ST_Step2 label ST_GRP 
dashboard_set_property ${dash_path} ST_Step2 expandableY false
dashboard_set_property ${dash_path} ST_Step2 expandableX false
dashboard_set_property ${dash_path} ST_Step2 preferredWidth 200
dashboard_set_property ${dash_path} ST_Step2 text "STEP 2:"


dashboard_add ${dash_path} ST_SScheck2 checkBox ST_GRP 
dashboard_set_property ${dash_path} ST_SScheck2 expandableY false
dashboard_set_property ${dash_path} ST_SScheck2 expandableX false
dashboard_set_property ${dash_path} ST_SScheck2 preferredWidth 200 
dashboard_set_property ${dash_path} ST_SScheck2 visible true
dashboard_set_property ${dash_path} ST_SScheck2 text "Seed Sweep"
dashboard_set_property ${dash_path} ST_SScheck2 checked false 
dashboard_set_property ${dash_path} ST_SScheck2 onClick "::Integrated_MainControl::Seed_Input $dash_path"
dashboard_set_property ${dash_path} ST_SScheck2 toolTip "Click if you want to perform seed sweep after constraints have been generated"


dashboard_add ${dash_path} ST_dummy1 label ST_GRP 
dashboard_set_property ${dash_path} ST_dummy1 expandableY false
dashboard_set_property ${dash_path} ST_dummy1 expandableX false
dashboard_set_property ${dash_path} ST_dummy1 preferredWidth 200
dashboard_set_property ${dash_path} ST_dummy1 text ""


dashboard_add ${dash_path} ST_dummy2 label ST_GRP 
dashboard_set_property ${dash_path} ST_dummy2 expandableY false
dashboard_set_property ${dash_path} ST_dummy2 expandableX false
dashboard_set_property ${dash_path} ST_dummy2 preferredWidth 200
dashboard_set_property ${dash_path} ST_dummy2 text ""


##################STEP3##########################################
#
dashboard_add ${dash_path} ST_Step3 label ST_GRP 
dashboard_set_property ${dash_path} ST_Step3 expandableY false
dashboard_set_property ${dash_path} ST_Step3 expandableX false
dashboard_set_property ${dash_path} ST_Step3 preferredWidth 200
dashboard_set_property ${dash_path} ST_Step3 text "STEP 3:"

dashboard_add ${dash_path} ST_ASeedcheck3 checkBox ST_GRP 
dashboard_set_property ${dash_path} ST_ASeedcheck3 expandableY false
dashboard_set_property ${dash_path} ST_ASeedcheck3 expandableX false
dashboard_set_property ${dash_path} ST_ASeedcheck3 preferredWidth 200 
dashboard_set_property ${dash_path} ST_ASeedcheck3 visible true
dashboard_set_property ${dash_path} ST_ASeedcheck3 text "Analyze Seed"
dashboard_set_property ${dash_path} ST_ASeedcheck3 checked false 
dashboard_set_property ${dash_path} ST_ASeedcheck3 onClick "::Integrated_MainControl::Seed_Analyze $dash_path"
dashboard_set_property ${dash_path} ST_ASeedcheck3 toolTip "Click to analyze failing paths from seed sweep results"

dashboard_add ${dash_path} ST_dummy3_1 label ST_GRP 
dashboard_set_property ${dash_path} ST_dummy3_1 expandableY false
dashboard_set_property ${dash_path} ST_dummy3_1 expandableX false
dashboard_set_property ${dash_path} ST_dummy3_1 preferredWidth 200
dashboard_set_property ${dash_path} ST_dummy3_1 text ""

#dashboard_add ${dash_path} ST_AMLDcheck3 checkBox ST_GRP 
#dashboard_set_property ${dash_path} ST_AMLDcheck3 expandableY false
#dashboard_set_property ${dash_path} ST_AMLDcheck3 expandableX false
#dashboard_set_property ${dash_path} ST_AMLDcheck3 preferredWidth 200
#dashboard_set_property ${dash_path} ST_AMLDcheck3 visible true
#dashboard_set_property ${dash_path} ST_AMLDcheck3 text "Analyze MLD"
#dashboard_set_property ${dash_path} ST_AMLDcheck3 checked false

dashboard_add ${dash_path} ST_dummy3_2 label ST_GRP 
dashboard_set_property ${dash_path} ST_dummy3_2 expandableY false
dashboard_set_property ${dash_path} ST_dummy3_2 expandableX false
dashboard_set_property ${dash_path} ST_dummy3_2 preferredWidth 200
dashboard_set_property ${dash_path} ST_dummy3_2 text ""

##################STEP4##########################################

dashboard_add ${dash_path} ST_Step4 label ST_GRP 
dashboard_set_property ${dash_path} ST_Step4 expandableY false
dashboard_set_property ${dash_path} ST_Step4 expandableX false
dashboard_set_property ${dash_path} ST_Step4 preferredWidth 200
dashboard_set_property ${dash_path} ST_Step4 text "STEP 4:"

dashboard_add ${dash_path} ST_Maxcheck4 checkBox ST_GRP 
dashboard_set_property ${dash_path} ST_Maxcheck4 expandableY false
dashboard_set_property ${dash_path} ST_Maxcheck4 expandableX false
dashboard_set_property ${dash_path} ST_Maxcheck4 preferredWidth 200 
dashboard_set_property ${dash_path} ST_Maxcheck4 visible true
dashboard_set_property ${dash_path} ST_Maxcheck4 text "MAX Constraints based on Failing Paths"
dashboard_set_property ${dash_path} ST_Maxcheck4 checked false 
dashboard_set_property ${dash_path}  ST_Maxcheck4 onClick "::Integrated_MainControl::Max_Seed $dash_path"
dashboard_set_property ${dash_path} ST_Maxcheck4 toolTip "Click to generate max_delay constraints for common failing paths across seeds"

dashboard_add ${dash_path} ST_dummy4_1 label ST_GRP 
dashboard_set_property ${dash_path} ST_dummy4_1 expandableY false
dashboard_set_property ${dash_path} ST_dummy4_1 expandableX false
dashboard_set_property ${dash_path} ST_dummy4_1 preferredWidth 200
dashboard_set_property ${dash_path} ST_dummy4_1 text ""

dashboard_add ${dash_path} ST_dummy4_2 label ST_GRP 
dashboard_set_property ${dash_path} ST_dummy4_2 expandableY false
dashboard_set_property ${dash_path} ST_dummy4_2 expandableX false
dashboard_set_property ${dash_path} ST_dummy4_2 preferredWidth 200
dashboard_set_property ${dash_path} ST_dummy4_2 text ""


##################STEP5##########################################

dashboard_add ${dash_path} ST_Step5 label ST_GRP 
dashboard_set_property ${dash_path} ST_Step5 expandableY false
dashboard_set_property ${dash_path} ST_Step5 expandableX false
dashboard_set_property ${dash_path} ST_Step5 preferredWidth 200
dashboard_set_property ${dash_path} ST_Step5 text "Repeat Step 2 to 4"


dashboard_add ${dash_path} ST_SScheck5 comboBox ST_GRP 
dashboard_set_property ${dash_path} ST_SScheck5 expandableY false
dashboard_set_property ${dash_path} ST_SScheck5 expandableX false
dashboard_set_property ${dash_path} ST_SScheck5 preferredWidth 50
dashboard_set_property ${dash_path} ST_SScheck5 options { "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
dashboard_set_property ${dash_path} ST_SScheck5 toolTip "Enter number of times step 2 to 4 to be repeated"
dashboard_set_property ${dash_path} ST_SScheck5 onChange "::Integrated_MainControl::EnterIteration $dash_path"


dashboard_add ${dash_path} ST_dummy5_1 label ST_GRP 
dashboard_set_property ${dash_path} ST_dummy5_1 expandableY false
dashboard_set_property ${dash_path} ST_dummy5_1 expandableX false
dashboard_set_property ${dash_path} ST_dummy5_1 preferredWidth 200
dashboard_set_property ${dash_path} ST_dummy5_1 text ""


dashboard_add ${dash_path} ST_dummy5_2 label ST_GRP 
dashboard_set_property ${dash_path} ST_dummy5_2 expandableY false
dashboard_set_property ${dash_path} ST_dummy5_2 expandableX false
dashboard_set_property ${dash_path} ST_dummy5_2 preferredWidth 200
dashboard_set_property ${dash_path} ST_dummy5_2 text ""

#################################################################
dashboard_add ${dash_path} ConfigureButton button ST_GRP
dashboard_set_property ${dash_path} ConfigureButton expandableX false
dashboard_set_property ${dash_path} ConfigureButton expandableY false
dashboard_set_property ${dash_path} ConfigureButton text "START"
dashboard_set_property ${dash_path} ConfigureButton toolTip "Generates the selected constraints for selected modules"
dashboard_set_property ${dash_path} ConfigureButton onClick "::Integrated_MainControl::GenerateConstraints $dash_path"




###############################################################################
#                   MLD SETTINGS
###############################################################################
dashboard_add ${dash_path} MLD_GRP group topGroup
dashboard_set_property ${dash_path} MLD_GRP  expandableX false
dashboard_set_property ${dash_path} MLD_GRP  expandableY false
dashboard_set_property ${dash_path} MLD_GRP  preferredWidth 1600
dashboard_set_property ${dash_path} MLD_GRP  title "MLD Settings"
dashboard_set_property ${dash_path} MLD_GRP  itemsPerRow 8
dashboard_set_property ${dash_path} MLD_GRP  visible false

dashboard_add ${dash_path} MLD_LevelLabel label MLD_GRP 
dashboard_set_property ${dash_path} MLD_LevelLabel expandableY false
dashboard_set_property ${dash_path} MLD_LevelLabel expandableX false 
dashboard_set_property ${dash_path} MLD_LevelLabel preferredWidth 200
dashboard_set_property ${dash_path} MLD_LevelLabel text "Level:"

dashboard_add ${dash_path} MLD_LevelCombo comboBox MLD_GRP
dashboard_set_property ${dash_path} MLD_LevelCombo expandableY false
dashboard_set_property ${dash_path} MLD_LevelCombo expandableX false
dashboard_set_property ${dash_path} MLD_LevelCombo preferredWidth 100
dashboard_set_property ${dash_path} MLD_LevelCombo selected 0
dashboard_set_property ${dash_path} MLD_LevelCombo options { "TOP" "BLOCK" }
dashboard_set_property ${dash_path} MLD_LevelCombo onChange "::Integrated_MainControl::MLD_LevelChange $dash_path"

dashboard_add ${dash_path} MLD_DestThrsLabel label MLD_GRP
dashboard_set_property ${dash_path} MLD_DestThrsLabel expandableY false
dashboard_set_property ${dash_path} MLD_DestThrsLabel expandableX false
dashboard_set_property ${dash_path} MLD_DestThrsLabel preferredWidth 200
dashboard_set_property ${dash_path} MLD_DestThrsLabel text "Destination Threshold:"

dashboard_add ${dash_path} MLD_DestThrstTextField textField MLD_GRP
dashboard_set_property ${dash_path} MLD_DestThrstTextField expandableY false
dashboard_set_property ${dash_path} MLD_DestThrstTextField expandableX false 
dashboard_set_property ${dash_path} MLD_DestThrstTextField editable true
dashboard_set_property ${dash_path} MLD_DestThrstTextField preferredWidth 200
dashboard_set_property ${dash_path} MLD_DestThrstTextField text "150"
dashboard_set_property ${dash_path} MLD_DestThrstTextField toolTip "Destination entities to be grouped in Integrated"

dashboard_add ${dash_path} MLD_GrpThrstLabel label MLD_GRP
dashboard_set_property ${dash_path} MLD_GrpThrstLabel expandableY false 
dashboard_set_property ${dash_path} MLD_GrpThrstLabel expandableX false
dashboard_set_property ${dash_path} MLD_GrpThrstLabel preferredWidth 200 
dashboard_set_property ${dash_path} MLD_GrpThrstLabel text "Group Threshold:"

dashboard_add ${dash_path} MLD_GrpThrstTextField textField MLD_GRP
dashboard_set_property ${dash_path} MLD_GrpThrstTextField expandableY false
dashboard_set_property ${dash_path} MLD_GrpThrstTextField expandableX false
dashboard_set_property ${dash_path} MLD_GrpThrstTextField editable true
dashboard_set_property ${dash_path} MLD_GrpThrstTextField preferredWidth 200
dashboard_set_property ${dash_path} MLD_GrpThrstTextField text "10"
dashboard_set_property ${dash_path} MLD_GrpThrstTextField toolTip "Threshold for grouping destination thresholds"

dashboard_add ${dash_path} MLD_clkLabel label MLD_GRP
dashboard_set_property ${dash_path} MLD_clkLabel expandableY false
dashboard_set_property ${dash_path} MLD_clkLabel expandableX false
dashboard_set_property ${dash_path} MLD_clkLabel preferredWidth 200
dashboard_set_property ${dash_path} MLD_clkLabel text "CLK:"
dashboard_set_property ${dash_path} MLD_clkLabel visible false 

dashboard_add ${dash_path} MLD_clkTextField textField MLD_GRP
dashboard_set_property ${dash_path} MLD_clkTextField expandableY false
dashboard_set_property ${dash_path} MLD_clkTextField expandableX false
dashboard_set_property ${dash_path} MLD_clkTextField editable true
dashboard_set_property ${dash_path} MLD_clkTextField preferredWidth 200
dashboard_set_property ${dash_path} MLD_clkTextField text "u_a10_soc|iopll_dsp|outclk0"
dashboard_set_property ${dash_path} MLD_clkTextField toolTip "Enter full hierarchy of clock"
dashboard_set_property ${dash_path} MLD_clkTextField visible false 



dashboard_add ${dash_path} MLD_ModuleNumLabel label MLD_GRP 
dashboard_set_property ${dash_path} MLD_ModuleNumLabel expandableY false
dashboard_set_property ${dash_path} MLD_ModuleNumLabel expandableX false
dashboard_set_property ${dash_path} MLD_ModuleNumLabel preferredWidth 100
dashboard_set_property ${dash_path} MLD_ModuleNumLabel text "Number of modules:"

dashboard_add ${dash_path} MLD_ModuleNumCombo comboBox MLD_GRP 
dashboard_set_property ${dash_path} MLD_ModuleNumCombo expandableY false
dashboard_set_property ${dash_path} MLD_ModuleNumCombo expandableX false
dashboard_set_property ${dash_path} MLD_ModuleNumCombo preferredWidth 100
dashboard_set_property ${dash_path} MLD_ModuleNumCombo options { "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
dashboard_set_property ${dash_path} MLD_ModuleNumCombo toolTip "Enter no. of modules for which constraints are to be generated (MAX 10)"
dashboard_set_property ${dash_path} MLD_ModuleNumCombo onChange "::Integrated_MainControl::EnterMLDModuleInfo $dash_path"

for {set i 0} {$i < 6} {incr i} {
dashboard_add ${dash_path} MLD_dummy($i) label MLD_GRP 
dashboard_set_property ${dash_path} MLD_dummy($i) expandableY false
dashboard_set_property ${dash_path} MLD_dummy($i) expandableX false 
dashboard_set_property ${dash_path} MLD_dummy($i) text "" 
}

for {set i 0} {$i < 10} {incr i} {

dashboard_add ${dash_path} MLD_ModuleLabel($i) label MLD_GRP 
dashboard_set_property ${dash_path} MLD_ModuleLabel($i) expandableY false
dashboard_set_property ${dash_path} MLD_ModuleLabel($i) expandableX false
dashboard_set_property ${dash_path} MLD_ModuleLabel($i) visible false
dashboard_set_property ${dash_path} MLD_ModuleLabel($i) text "Module name [expr {$i + 1}]:"


dashboard_add ${dash_path} MLD_ModuleTextField($i) textField MLD_GRP 
dashboard_set_property ${dash_path} MLD_ModuleTextField($i) expandableY false
dashboard_set_property ${dash_path} MLD_ModuleTextField($i) expandableX false
dashboard_set_property ${dash_path} MLD_ModuleTextField($i) editable true
dashboard_set_property ${dash_path} MLD_ModuleTextField($i) preferredWidth 200
dashboard_set_property ${dash_path} MLD_ModuleTextField($i) visible false
dashboard_set_property ${dash_path} MLD_ModuleTextField($i) text ""
dashboard_set_property ${dash_path} MLD_ModuleTextField($i) toolTip "Enter module name (eg. LCFR/LDUC/DPD)"

}

###############################################################################
#                   MAX SETTINGS
###############################################################################
dashboard_add ${dash_path} MAX_GRP group topGroup
dashboard_set_property ${dash_path} MAX_GRP  expandableX false
dashboard_set_property ${dash_path} MAX_GRP  expandableY false
dashboard_set_property ${dash_path} MAX_GRP  preferredWidth 1200
dashboard_set_property ${dash_path} MAX_GRP  title "MAX Settings"
dashboard_set_property ${dash_path} MAX_GRP  visible false
dashboard_set_property ${dash_path} MAX_GRP  itemsPerRow 6


dashboard_add ${dash_path} MAX_LevelLabel label MAX_GRP 
dashboard_set_property ${dash_path} MAX_LevelLabel expandableY false
dashboard_set_property ${dash_path} MAX_LevelLabel expandableX false
dashboard_set_property ${dash_path} MAX_LevelLabel preferredWidth 200
dashboard_set_property ${dash_path} MAX_LevelLabel text "Level:"

dashboard_add ${dash_path} MAX_LevelCombo comboBox MAX_GRP
dashboard_set_property ${dash_path} MAX_LevelCombo expandableY false
dashboard_set_property ${dash_path} MAX_LevelCombo expandableX false
dashboard_set_property ${dash_path} MAX_LevelCombo preferredWidth 100
dashboard_set_property ${dash_path} MAX_LevelCombo selected 0
dashboard_set_property ${dash_path} MAX_LevelCombo options { "TOP" "BLOCK" }
dashboard_set_property ${dash_path} MAX_LevelCombo onChange "::Integrated_MainControl::MAX_LevelChange $dash_path"

dashboard_add ${dash_path} MAX_DestThrsLabel label MAX_GRP
dashboard_set_property ${dash_path} MAX_DestThrsLabel expandableY false
dashboard_set_property ${dash_path} MAX_DestThrsLabel expandableX false
dashboard_set_property ${dash_path} MAX_DestThrsLabel preferredWidth 200
dashboard_set_property ${dash_path} MAX_DestThrsLabel text "MAX Fanout Threshold:"

dashboard_add ${dash_path} MAX_DestThrstTextField textField MAX_GRP
dashboard_set_property ${dash_path} MAX_DestThrstTextField expandableY false
dashboard_set_property ${dash_path} MAX_DestThrstTextField expandableX false
dashboard_set_property ${dash_path} MAX_DestThrstTextField editable true
dashboard_set_property ${dash_path} MAX_DestThrstTextField preferredWidth 200
dashboard_set_property ${dash_path} MAX_DestThrstTextField text "150"
dashboard_set_property ${dash_path} MAX_DestThrstTextField toolTip "Destination entities to be grouped in Integrated"


dashboard_add ${dash_path} MAX_clkLabel label MAX_GRP
dashboard_set_property ${dash_path} MAX_clkLabel expandableY false
dashboard_set_property ${dash_path} MAX_clkLabel expandableX false
dashboard_set_property ${dash_path} MAX_clkLabel preferredWidth 200 
dashboard_set_property ${dash_path} MAX_clkLabel text "CLK:"
dashboard_set_property ${dash_path} MAX_clkLabel visible false

dashboard_add ${dash_path} MAX_clkTextField textField MAX_GRP
dashboard_set_property ${dash_path} MAX_clkTextField expandableY false
dashboard_set_property ${dash_path} MAX_clkTextField expandableX false
dashboard_set_property ${dash_path} MAX_clkTextField editable true
dashboard_set_property ${dash_path} MAX_clkTextField preferredWidth 200
dashboard_set_property ${dash_path} MAX_clkTextField text "u_a10_soc|iopll_dsp|outclk0"
dashboard_set_property ${dash_path} MAX_clkTextField toolTip "Enter full hierarchy of clock"
dashboard_set_property ${dash_path} MAX_clkTextField visible false 

dashboard_add ${dash_path} MAX_ModuleNumLabel label MAX_GRP 
dashboard_set_property ${dash_path} MAX_ModuleNumLabel expandableY false
dashboard_set_property ${dash_path} MAX_ModuleNumLabel expandableX false
dashboard_set_property ${dash_path} MAX_ModuleNumLabel preferredWidth 200
dashboard_set_property ${dash_path} MAX_ModuleNumLabel text "Number of modules:"

dashboard_add ${dash_path} MAX_ModuleNumCombo comboBox MAX_GRP 
dashboard_set_property ${dash_path} MAX_ModuleNumCombo expandableY false
dashboard_set_property ${dash_path} MAX_ModuleNumCombo expandableX false
dashboard_set_property ${dash_path} MAX_ModuleNumCombo preferredWidth 100
dashboard_set_property ${dash_path} MAX_ModuleNumCombo options { "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
dashboard_set_property ${dash_path} MAX_ModuleNumCombo toolTip "Enter no. of modules for which constraints are to be generated (MAX 10)"
dashboard_set_property ${dash_path} MAX_ModuleNumCombo onChange "::Integrated_MainControl::EnterMAXModuleInfo $dash_path"

for {set i 0} {$i < 4} {incr i} {
dashboard_add ${dash_path} MAX_dummy2($i) label MAX_GRP 
dashboard_set_property ${dash_path} MAX_dummy2($i) expandableY false
dashboard_set_property ${dash_path} MAX_dummy2($i) expandableX false 
dashboard_set_property ${dash_path} MAX_dummy2($i) text "" 
dashboard_set_property ${dash_path} MAX_dummy2($i) preferredWidth 200 

}

for {set i 0} {$i < 10} {incr i} {

dashboard_add ${dash_path} MAX_ModuleLabel($i) label MAX_GRP 
dashboard_set_property ${dash_path} MAX_ModuleLabel($i) expandableY false
dashboard_set_property ${dash_path} MAX_ModuleLabel($i) expandableX false
dashboard_set_property ${dash_path} MAX_ModuleLabel($i) visible false
dashboard_set_property ${dash_path} MAX_ModuleLabel($i) text "Module name [expr {$i + 1}]:"


dashboard_add ${dash_path} MAX_ModuleTextField($i) textField MAX_GRP 
dashboard_set_property ${dash_path} MAX_ModuleTextField($i) expandableY false
dashboard_set_property ${dash_path} MAX_ModuleTextField($i) expandableX false
dashboard_set_property ${dash_path} MAX_ModuleTextField($i) editable true
dashboard_set_property ${dash_path} MAX_ModuleTextField($i) preferredWidth 200
dashboard_set_property ${dash_path} MAX_ModuleTextField($i) visible false
dashboard_set_property ${dash_path} MAX_ModuleTextField($i) text ""
dashboard_set_property ${dash_path} MAX_ModuleTextField($i) toolTip "Enter module name (eg. LCFR/LDUC/DPD)"

}


###############################################################################
#                   MAX SEED SETTINGS
###############################################################################
dashboard_add ${dash_path} MAX_SEED_GRP group topGroup
dashboard_set_property ${dash_path} MAX_SEED_GRP  expandableX false
dashboard_set_property ${dash_path} MAX_SEED_GRP  expandableY false
dashboard_set_property ${dash_path} MAX_SEED_GRP  preferredWidth 1200
dashboard_set_property ${dash_path} MAX_SEED_GRP  title "MAX Settings"
dashboard_set_property ${dash_path} MAX_SEED_GRP  visible false
dashboard_set_property ${dash_path} MAX_SEED_GRP  itemsPerRow 6

dashboard_add ${dash_path} MAX_SEED_DestThrsLabel label MAX_SEED_GRP
dashboard_set_property ${dash_path} MAX_SEED_DestThrsLabel expandableY false
dashboard_set_property ${dash_path} MAX_SEED_DestThrsLabel expandableX false
dashboard_set_property ${dash_path} MAX_SEED_DestThrsLabel preferredWidth 200
dashboard_set_property ${dash_path} MAX_SEED_DestThrsLabel text "MAX Fanout Threshold:"

dashboard_add ${dash_path} MAX_SEED_DestThrstTextField textField MAX_SEED_GRP
dashboard_set_property ${dash_path} MAX_SEED_DestThrstTextField expandableY false
dashboard_set_property ${dash_path} MAX_SEED_DestThrstTextField expandableX false
dashboard_set_property ${dash_path} MAX_SEED_DestThrstTextField editable true
dashboard_set_property ${dash_path} MAX_SEED_DestThrstTextField preferredWidth 200
dashboard_set_property ${dash_path} MAX_SEED_DestThrstTextField text "150"
dashboard_set_property ${dash_path} MAX_SEED_DestThrstTextField toolTip "Destination entities to be grouped in Integrated"

dashboard_add ${dash_path} MAX_SEED_SeedCntLabel label MAX_SEED_GRP
dashboard_set_property ${dash_path} MAX_SEED_SeedCntLabel expandableY false
dashboard_set_property ${dash_path} MAX_SEED_SeedCntLabel expandableX false
dashboard_set_property ${dash_path} MAX_SEED_SeedCntLabel preferredWidth 200
dashboard_set_property ${dash_path} MAX_SEED_SeedCntLabel text "Number of Seed Hit Count:"

dashboard_add ${dash_path} MAX_SEED_SeedCntTextField textField MAX_SEED_GRP
dashboard_set_property ${dash_path} MAX_SEED_SeedCntTextField expandableY false
dashboard_set_property ${dash_path} MAX_SEED_SeedCntTextField expandableX false
dashboard_set_property ${dash_path} MAX_SEED_SeedCntTextField editable true
dashboard_set_property ${dash_path} MAX_SEED_SeedCntTextField preferredWidth 200
dashboard_set_property ${dash_path} MAX_SEED_SeedCntTextField text "2"


dashboard_add ${dash_path} MAX_SEED_HitCntLabel label MAX_SEED_GRP
dashboard_set_property ${dash_path} MAX_SEED_HitCntLabel expandableY false
dashboard_set_property ${dash_path} MAX_SEED_HitCntLabel expandableX false
dashboard_set_property ${dash_path} MAX_SEED_HitCntLabel preferredWidth 200
dashboard_set_property ${dash_path} MAX_SEED_HitCntLabel text "Maximum Number of Violations in Single Seed:"

dashboard_add ${dash_path} MAX_SEED_HitCntTextField textField MAX_SEED_GRP
dashboard_set_property ${dash_path} MAX_SEED_HitCntTextField expandableY false
dashboard_set_property ${dash_path} MAX_SEED_HitCntTextField expandableX false
dashboard_set_property ${dash_path} MAX_SEED_HitCntTextField editable true
dashboard_set_property ${dash_path} MAX_SEED_HitCntTextField preferredWidth 200
dashboard_set_property ${dash_path} MAX_SEED_HitCntTextField text "100"

###############################################################################
#                   FLOOR SETTINGS
###############################################################################
dashboard_add ${dash_path} FP_GRP group topGroup
dashboard_set_property ${dash_path} FP_GRP  expandableX false
dashboard_set_property ${dash_path} FP_GRP  expandableY false
dashboard_set_property ${dash_path} FP_GRP  preferredWidth 900
dashboard_set_property ${dash_path} FP_GRP  title "FP PLAN SETTINGS"
dashboard_set_property ${dash_path} FP_GRP  visible false 
dashboard_set_property ${dash_path} FP_GRP  itemsPerRow 3


dashboard_add ${dash_path} FloorPlanPathLabel label FP_GRP 
dashboard_set_property ${dash_path} FloorPlanPathLabel expandableY false
dashboard_set_property ${dash_path} FloorPlanPathLabel expandableX false
dashboard_set_property ${dash_path} FloorPlanPathLabel preferredWidth 200 
dashboard_set_property ${dash_path} FloorPlanPathLabel text "Floor Plan Guide File:"

dashboard_add ${dash_path} FloorPlanPathTextField textField FP_GRP
dashboard_set_property ${dash_path} FloorPlanPathTextField expandableY false
dashboard_set_property ${dash_path} FloorPlanPathTextField expandableX false
dashboard_set_property ${dash_path} FloorPlanPathTextField editable true
dashboard_set_property ${dash_path} FloorPlanPathTextField preferredWidth 700
dashboard_set_property ${dash_path} FloorPlanPathTextField text ""
dashboard_set_property ${dash_path} FloorPlanPathTextField toolTip "GuideLine Document for the Floor Plan"

dashboard_add ${dash_path} Floor_NavigateButton fileChooserButton FP_GRP
dashboard_set_property ${dash_path} Floor_NavigateButton expandableX false
dashboard_set_property ${dash_path} Floor_NavigateButton expandableY false
dashboard_set_property ${dash_path} Floor_NavigateButton preferredWidth 30
dashboard_set_property ${dash_path} Floor_NavigateButton text ".."
dashboard_set_property ${dash_path} Floor_NavigateButton title "Floor Plan (.csv file)"
dashboard_set_property ${dash_path} Floor_NavigateButton mode "files_only"
dashboard_set_property ${dash_path} Floor_NavigateButton filter [list "FP PLAN FILE (.csv)" "csv"]
dashboard_set_property ${dash_path} Floor_NavigateButton chooserButtonText "Select"
dashboard_set_property ${dash_path} Floor_NavigateButton onChoose "::Integrated_MainControl::FloorPath $dash_path"

###############################################################################
#                   SEED SWEEP SETTINGS
###############################################################################

dashboard_add ${dash_path} SS_GRP group topGroup
dashboard_set_property ${dash_path} SS_GRP expandableX false
dashboard_set_property ${dash_path} SS_GRP expandableY false
dashboard_set_property ${dash_path} SS_GRP preferredWidth 900
dashboard_set_property ${dash_path} SS_GRP title "Seed Sweep Settings"
dashboard_set_property ${dash_path} SS_GRP visible false 
dashboard_set_property ${dash_path} SS_GRP itemsPerRow 3

dashboard_add ${dash_path} SS_ExecutionPath label SS_GRP
dashboard_set_property ${dash_path} SS_ExecutionPath expandableY false
dashboard_set_property ${dash_path} SS_ExecutionPath expandableX false
#dashboard_set_property ${dash_path} SS_ExecutionPath preferredWidth 200 
dashboard_set_property ${dash_path} SS_ExecutionPath text "Execution directory path:"

dashboard_add ${dash_path} SS_ExecutionPathTextField textField SS_GRP
dashboard_set_property ${dash_path} SS_ExecutionPathTextField expandableY false
dashboard_set_property ${dash_path} SS_ExecutionPathTextField expandableX false
dashboard_set_property ${dash_path} SS_ExecutionPathTextField editable true
dashboard_set_property ${dash_path} SS_ExecutionPathTextField preferredWidth 700
dashboard_set_property ${dash_path} SS_ExecutionPathTextField text "E:/seed_sweep"
dashboard_set_property ${dash_path} SS_ExecutionPathTextField toolTip "Select directory from where you want to run the seed sweep tool. Note that the quartus project will be copied to this location for every seed"

dashboard_add ${dash_path} SS_NavigateButton fileChooserButton SS_GRP
dashboard_set_property ${dash_path} SS_NavigateButton expandableX false
dashboard_set_property ${dash_path} SS_NavigateButton expandableY false
dashboard_set_property ${dash_path} SS_NavigateButton preferredWidth 30
dashboard_set_property ${dash_path} SS_NavigateButton text ".."
dashboard_set_property ${dash_path} SS_NavigateButton title "Seed sweep execution folder"
dashboard_set_property ${dash_path} SS_NavigateButton mode "directories_only"
dashboard_set_property ${dash_path} SS_NavigateButton chooserButtonText "Select"
dashboard_set_property ${dash_path} SS_NavigateButton onChoose "::Integrated_MainControl::SeedSweepExecutionPath $dash_path"

dashboard_add ${dash_path} SS_ParallelExecutionLabel label SS_GRP
dashboard_set_property ${dash_path} SS_ParallelExecutionLabel expandableY false
dashboard_set_property ${dash_path} SS_ParallelExecutionLabel expandableX false
dashboard_set_property ${dash_path} SS_ParallelExecutionLabel preferredWidth 70
dashboard_set_property ${dash_path} SS_ParallelExecutionLabel text "No. of Parallel Executions:"

dashboard_add ${dash_path} SS_ParallelExecutionCombo comboBox SS_GRP 
dashboard_set_property ${dash_path} SS_ParallelExecutionCombo expandableY false
dashboard_set_property ${dash_path} SS_ParallelExecutionCombo expandableX false
dashboard_set_property ${dash_path} SS_ParallelExecutionCombo preferredWidth 50
dashboard_set_property ${dash_path} SS_ParallelExecutionCombo selected 0
dashboard_set_property ${dash_path} SS_ParallelExecutionCombo options { "1" "2" "3" }


dashboard_add ${dash_path} SS_emptyLabel1 label SS_GRP 
dashboard_set_property ${dash_path} SS_emptyLabel1 expandableX false
dashboard_set_property ${dash_path} SS_emptyLabel1 expandableY false
dashboard_set_property ${dash_path} SS_emptyLabel1 text ""
dashboard_set_property ${dash_path} SS_emptyLabel1 preferredWidth 200


#Number of constraints

dashboard_add ${dash_path} SS_SeedNumLabel label SS_GRP 
dashboard_set_property ${dash_path} SS_SeedNumLabel expandableY false
dashboard_set_property ${dash_path} SS_SeedNumLabel expandableX false
dashboard_set_property ${dash_path} SS_SeedNumLabel preferredWidth 200
dashboard_set_property ${dash_path} SS_SeedNumLabel text "No. of Seeds to be tested:"

dashboard_add ${dash_path} SS_SeedNumCombo comboBox SS_GRP 
dashboard_set_property ${dash_path} SS_SeedNumCombo expandableY false
dashboard_set_property ${dash_path} SS_SeedNumCombo expandableX false
dashboard_set_property ${dash_path} SS_SeedNumCombo preferredWidth 50
dashboard_set_property ${dash_path} SS_SeedNumCombo selected 0
dashboard_set_property ${dash_path} SS_SeedNumCombo options { "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SS_SeedNumCombo toolTip "Enter no. of seeds for which timing analysis is to be carried out"
dashboard_set_property ${dash_path} SS_SeedNumCombo onChange "::Integrated_MainControl::SeedNumChange $dash_path"

dashboard_add ${dash_path} SS_emptyLabel2 label SS_GRP 
dashboard_set_property ${dash_path} SS_emptyLabel2 expandableX false
dashboard_set_property ${dash_path} SS_emptyLabel2 expandableY false
dashboard_set_property ${dash_path} SS_emptyLabel2 text ""
dashboard_set_property ${dash_path} SS_emptyLabel2 preferredWidth 200



for {set i 0} {$i < 10} {incr i} {

dashboard_add ${dash_path} SS_ModuleLabel($i) label SS_GRP 
dashboard_set_property ${dash_path} SS_ModuleLabel($i) expandableY false
dashboard_set_property ${dash_path} SS_ModuleLabel($i) expandableX false
dashboard_set_property ${dash_path} SS_ModuleLabel($i) visible false
dashboard_set_property ${dash_path} SS_ModuleLabel($i) text "Seed number:"

dashboard_add ${dash_path} SS_ModuleCombo($i) comboBox SS_GRP 
dashboard_set_property ${dash_path} SS_ModuleCombo($i) expandableY false
dashboard_set_property ${dash_path} SS_ModuleCombo($i) expandableX false
dashboard_set_property ${dash_path} SS_ModuleCombo($i) preferredWidth 100
dashboard_set_property ${dash_path} SS_ModuleCombo($i) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SS_ModuleCombo($i) selected $i 
dashboard_set_property ${dash_path} SS_ModuleCombo($i) visible false
dashboard_set_property ${dash_path} SS_ModuleCombo($i) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SS_emptyLabel($i) label SS_GRP 
dashboard_set_property ${dash_path} SS_emptyLabel($i) expandableX false
dashboard_set_property ${dash_path} SS_emptyLabel($i) expandableY false
dashboard_set_property ${dash_path} SS_emptyLabel($i) text ""
dashboard_set_property ${dash_path} SS_emptyLabel($i) preferredWidth 200

}












###############################################################################
#                   MESSAGE WINDOW 
###############################################################################


dashboard_add ${dash_path} MessageWindow group topGroup
dashboard_set_property ${dash_path} MessageWindow expandableX false
dashboard_set_property ${dash_path} MessageWindow expandableY false
dashboard_set_property ${dash_path} MessageWindow title "Message/Warning"
dashboard_set_property ${dash_path} MessageWindow preferredWidth 800
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
	set ::Integrated_MainControl::QuartusInstallationPath [dashboard_get_property ${dash_path} NavigateButton paths]
	set qpath [file nativename $::Integrated_MainControl::QuartusInstallationPath]
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
	set ::Integrated_MainControl::QuartusInstallationPath $qpath
	
}

proc ProjectPath {dash_path} {
	set ::Integrated_MainControl::QuartusProjectPath [dashboard_get_property ${dash_path} NavigateButton1 paths]
	set qpath [file nativename $::Integrated_MainControl::QuartusProjectPath]
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
	set ::Integrated_MainControl::QuartusProjectPath $qpath	
}

proc SDCPath {dash_path} {
	set ::Integrated_MainControl::QuartusSDCPath [dashboard_get_property ${dash_path} SDC_NavigateButton paths]
	set sdc_path [file nativename $::Integrated_MainControl::QuartusSDCPath]
	set n [string length $sdc_path]
	for {set i 0} {$i < $n} {incr i} {
			set x [ string index $sdc_path $i]
			if { [string compare $x "{"] == 0 | [string compare $x "}"] == 0 } {
				set sdc_path [string replace $sdc_path $i $i ""]
			}
			if { [string compare $x "\\"] == 0 } {
				set sdc_path [string replace $sdc_path $i $i "/"]
			}
		}
		
		set n [string length $sdc_path]
		set x_2d [ string index $sdc_path [expr $n-3] ]
		set x_1d [ string index $sdc_path [expr $n-2] ]
		set x    [ string index $sdc_path [expr $n-1] ]
		if { [string compare $x "f"] == 0 & [string compare $x_1d "p"] == 0 & [string compare $x_2d "q"] == 0 } {
			dashboard_set_property ${dash_path} MessageWindowTextField text ""	
		} else {
			dashboard_set_property ${dash_path} MessageWindowTextField text "Please select .sdc file from project folder"	
		}
	
	dashboard_set_property ${dash_path} QuartusSDCPathTextField text $sdc_path
	set ::Integrated_MainControl::QuartusSDCPath $sdc_path	
}





proc FloorPath {dash_path} {
	set ::Integrated_MainControl::FloorPlanPath [dashboard_get_property ${dash_path} Floor_NavigateButton paths]
	set floor_path [file nativename $::Integrated_MainControl::FloorPlanPath]
	set n [string length $floor_path]
	for {set i 0} {$i < $n} {incr i} {
			set x [ string index $floor_path $i]
			if { [string compare $x "{"] == 0 | [string compare $x "}"] == 0 } {
				set floor_path [string replace $floor_path $i $i ""]
			}
			if { [string compare $x "\\"] == 0 } {
				set floor_path [string replace $floor_path $i $i "/"]
			}
		}
		
		set n [string length $floor_path]
		set x_2d [ string index $floor_path [expr $n-3] ]
		set x_1d [ string index $floor_path [expr $n-2] ]
		set x    [ string index $floor_path [expr $n-1] ]
		if { [string compare $x "f"] == 0 & [string compare $x_1d "p"] == 0 & [string compare $x_2d "q"] == 0 } {
			dashboard_set_property ${dash_path} MessageWindowTextField text ""	
		} else {
			dashboard_set_property ${dash_path} MessageWindowTextField text "Please select .csv file from project folder"	
		}
	
	dashboard_set_property ${dash_path} FloorPlanPathTextField text $floor_path
	set ::Integrated_MainControl::FloorPlanPath $floor_path	
}

proc MLD_LevelChange {dash_path} {
	set ::Integrated_MainControl::MLD_LevelSelection [dashboard_get_property ${dash_path} MLD_LevelCombo selected ]
	if {${::Integrated_MainControl::MLD_LevelSelection} == 0} {
		#CHIP
		dashboard_set_property ${dash_path} MLD_ModuleNumCombo options { "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
		dashboard_set_property ${dash_path} MLD_ModuleNumCombo toolTip "Enter no. of modules for which constraints are to be generated (MAX 10)"
		dashboard_set_property ${dash_path} MLD_ModuleLabel(0) text "Module name 1"
	} else {
		#set level "BLOCK"
		for {set i 1} {$i < 10} {incr i} {
			dashboard_set_property ${dash_path} MLD_ModuleLabel($i) visible false
			dashboard_set_property ${dash_path} MLD_ModuleTextField($i) visible false
		}
		dashboard_set_property ${dash_path} MLD_ModuleNumCombo options { "0" "1" }
		dashboard_set_property ${dash_path} MLD_ModuleNumCombo toolTip "Constraints are generated for entire project"
		dashboard_set_property ${dash_path} MLD_ModuleLabel(0) text "Block name"
	}
}

proc MAX_LevelChange {dash_path} {
	set ::Integrated_MainControl::MAX_LevelSelection [dashboard_get_property ${dash_path} MAX_LevelCombo selected ]
	if {${::Integrated_MainControl::MAX_LevelSelection} == 0} {
		#CHIP
		dashboard_set_property ${dash_path} MAX_ModuleNumCombo options { "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"}
		dashboard_set_property ${dash_path} MAX_ModuleNumCombo toolTip "Enter no. of modules for which constraints are to be generated (MAX 10)"
		dashboard_set_property ${dash_path} MAX_ModuleLabel(0) text "Module name 1"
	} else {
		#set level "BLOCK"
		for {set i 1} {$i < 10} {incr i} {
			dashboard_set_property ${dash_path} MAX_ModuleLabel($i) visible false
			dashboard_set_property ${dash_path} MAX_ModuleTextField($i) visible false
		}
		dashboard_set_property ${dash_path} MAX_ModuleNumCombo options { "0" "1" }
		dashboard_set_property ${dash_path} MAX_ModuleNumCombo toolTip "Constraints are generated for entire project"
		dashboard_set_property ${dash_path} MAX_ModuleLabel(0) text "Block name"
	}
}


proc EnterMLDModuleInfo {dash_path} {
	set ::Integrated_MainControl::MLD_ModuleNumSelection [dashboard_get_property ${dash_path} MLD_ModuleNumCombo selected ]
	dashboard_set_property ${dash_path} MessageWindowTextField text "Enter names of modules, tick the checkboxes for required constraints and finally click on Generate Constraints button"
	        
		for {set i 0} {$i <  $::Integrated_MainControl::MLD_ModuleNumSelection } {incr i} {
			dashboard_set_property ${dash_path} MLD_ModuleTextField($i) visible true
			dashboard_set_property ${dash_path} MLD_ModuleLabel($i) visible true

		}

		for {set i  $::Integrated_MainControl::MLD_ModuleNumSelection } {$i < 10} {incr i} {
			dashboard_set_property ${dash_path} MLD_ModuleTextField($i) visible false
			dashboard_set_property ${dash_path} MLD_ModuleLabel($i) visible false

		}

}

proc EnterMAXModuleInfo {dash_path} {
	set ::Integrated_MainControl::MAX_ModuleNumSelection [dashboard_get_property ${dash_path} MAX_ModuleNumCombo selected ]
	dashboard_set_property ${dash_path} MessageWindowTextField text "Enter names of modules, tick the checkboxes for required constraints and finally click on Generate Constraints button"

		for {set i 0} {$i <  $::Integrated_MainControl::MAX_ModuleNumSelection } {incr i} {
			dashboard_set_property ${dash_path} MAX_ModuleTextField($i) visible true
			dashboard_set_property ${dash_path} MAX_ModuleLabel($i) visible true

		}

		for {set i  $::Integrated_MainControl::MAX_ModuleNumSelection } {$i < 10} {incr i} {
			dashboard_set_property ${dash_path} MAX_ModuleTextField($i) visible false
			dashboard_set_property ${dash_path} MAX_ModuleLabel($i) visible false

		}

}


proc SeedSweepExecutionPath {dash_path} {
	set ::Integrated_MainControl::SS_ExecutionPath [dashboard_get_property ${dash_path} SS_NavigateButton paths]
	set qpath [file nativename $::Integrated_MainControl::SS_ExecutionPath]
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
	dashboard_set_property ${dash_path} SS_ExecutionPathTextField text $qpath
	set ::Integrated_MainControl::SS_ExecutionPath $qpath
	
}


proc SeedNumChange {dash_path} {
	set ::Integrated_MainControl::SS_NumSeed [dashboard_get_property ${dash_path} SS_SeedNumCombo selected]

	for {set i 0} {$i < 10} {incr i} {
		dashboard_set_property ${dash_path} SS_ModuleLabel($i) visible false
		dashboard_set_property ${dash_path} SS_ModuleCombo($i) visible false
	}
	# MAKE FALSE, Disabled the options..  
	for {set i 0} {$i < $::Integrated_MainControl::SS_NumSeed} {incr i} {
		dashboard_set_property ${dash_path} SS_ModuleLabel($i) visible true
		dashboard_set_property ${dash_path} SS_ModuleCombo($i) visible true
	}
}

proc MLD_Input {dash_path} {
  set ::Integrated_MainControl::MLD_CHK [dashboard_get_property ${dash_path} ST_MLDcheck1 checked]
  if { ${::Integrated_MainControl::MLD_CHK} == true } {
  dashboard_set_property ${dash_path} MLD_GRP  visible true 
  } else {
  dashboard_set_property ${dash_path} MLD_GRP  visible false 
  }

}

proc FP_Input {dash_path} {
  set ::Integrated_MainControl::FP_CHK [dashboard_get_property ${dash_path} ST_FPcheck1 checked]
  if { ${::Integrated_MainControl::FP_CHK} == true } {
  dashboard_set_property ${dash_path} FP_GRP  visible true 
  } else {
  dashboard_set_property ${dash_path} FP_GRP  visible false 
  }

}


proc MAX_Input {dash_path} {
  set ::Integrated_MainControl::MAX_CHK [dashboard_get_property ${dash_path} ST_MAXcheck1 checked]

  if { ${::Integrated_MainControl::MAX_CHK} == true } {
  dashboard_set_property ${dash_path} MAX_GRP  visible true 
  } else {
  dashboard_set_property ${dash_path} MAX_GRP  visible false 
  }

}


proc Seed_Input {dash_path} {
  set ::Integrated_MainControl::Seed_CHK [dashboard_get_property ${dash_path} ST_SScheck2 checked]

  if {${::Integrated_MainControl::Seed_CHK} == true} {
  dashboard_set_property ${dash_path} SS_GRP  visible true 
  } else {
  dashboard_set_property ${dash_path} SS_GRP  visible false 
  }

}


proc Seed_Analyze {dash_path} {
  set ::Integrated_MainControl::Seed_Analyze_CHK [dashboard_get_property ${dash_path} ST_ASeedcheck3 checked]

}

proc Max_Seed {dash_path} {
  set ::Integrated_MainControl::Max_Seed_CHK [dashboard_get_property ${dash_path} ST_Maxcheck4 checked]
  if {$::Integrated_MainControl::Max_Seed_CHK == true} {
       dashboard_set_property ${dash_path} MAX_SEED_GRP  visible true
       dashboard_set_property ${dash_path} ST_ASeedcheck3 checked true
  } else {
       dashboard_set_property ${dash_path} MAX_SEED_GRP  visible false
  }
}

proc EnterIteration {dash_path} {
  set ::Integrated_MainControl::Iteration_value [dashboard_get_property ${dash_path} ST_SScheck5 selected]
}




proc GenerateConstraints {dash_path} {


####################################################################################################

	dashboard_set_property ${dash_path} MessageWindowTextField text "Constraints Generation started"

	set ::Integrated_MainControl::QuartusInstallationPath [dashboard_get_property ${dash_path} QuartusInstallPathTextField text ]
	set ::Integrated_MainControl::QuartusProjectPath      [dashboard_get_property ${dash_path} QuartusProjectPathTextField text ]
	set ::Integrated_MainControl::QuartusSDCPath          [dashboard_get_property ${dash_path} QuartusSDCPathTextField text ]
	set ::Integrated_MainControl::BaseRunSelect           [dashboard_get_property ${dash_path} ST_Basecheck1 checked]

	
	
set quartus_sta        "$::Integrated_MainControl::QuartusInstallationPath/quartus_sta"
set quartus_path        "$::Integrated_MainControl::QuartusInstallationPath"
set prj_qpf            "$::Integrated_MainControl::QuartusProjectPath"
set prj_sdc            "$::Integrated_MainControl::QuartusSDCPath"
set clk_name           [dashboard_get_property ${dash_path} clkTextField text ]

set MLD_OPTION           $::Integrated_MainControl::MLD_CHK 
set MAX_OPTION           $::Integrated_MainControl::MAX_CHK 
set FP_OPTION            $::Integrated_MainControl::FP_CHK
set SEED_OPTION          $::Integrated_MainControl::Seed_CHK
set SEED_ANALYZE_OPTION  $::Integrated_MainControl::Seed_Analyze_CHK
set MAX_SEED_OPTION      $::Integrated_MainControl::Max_Seed_CHK

set seed_iteration       $::Integrated_MainControl::Iteration_value

set curr_path    [pwd]

#PROJECT NAME
set word_list [split $prj_qpf "/"]
set prj_name  [lindex $word_list end]
set word_list [split $prj_name "\."]
set prj_name  [lindex $word_list 0]

#PROJECT SDC NAME
set word_list [split $prj_sdc "/"]
set prj_sdc_name  [lindex $word_list end]
set word_list [split $prj_sdc_name "\."]
set prj_sdc_name  [lindex $word_list 0]


#PROJECT FOLDER 
# To Extract Project Folder
set prj_qpf_t [string trim $prj_qpf " "]
   # List
set word_list [split $prj_qpf_t "/"]
   #Deleting the last from the list
set prj_folder [lreplace $word_list end end]
   #Insert / 
set prj_folder [join $prj_folder "/"] 

#QSF FILE 

set prj_qsf [concat $prj_folder\/$prj_name\.qsf]

####################################################################################################
#                            BASE RUN 
####################################################################################################
if { ${::Integrated_MainControl::BaseRunSelect} == true } {
	cd $prj_folder
	set prj_name_path [findfile ${prj_folder} *.qpf]
	set rev_name_path [findfile ${prj_folder} *.qsf]
	puts $prj_name_path
	puts $rev_name_path
	set prj_name_ext [file tail $prj_name_path]
	set rev_name_ext [file tail $rev_name_path]
	puts $prj_name_ext
	puts $rev_name_ext
	set prj_name [string trimright $prj_name_ext ".qpf"]
	set rev_name [string trimright $rev_name_ext ".qsf"]
	#set rev_name $prj_name
	puts $prj_name
	puts $rev_name
	dashboard_set_property ${dash_path} MessageWindowTextField text "Base version compilation has started"
 	exec $quartus_path/quartus_map --read_settings_files=on --write_settings_files=off $prj_name -c $rev_name 
	dashboard_set_property ${dash_path} MessageWindowTextField text "Quartus Analysis & Synthesis is completed successfully for base version"
	exec $quartus_path/quartus_fit --read_settings_files=off --write_settings_files=off $prj_name -c $rev_name
	dashboard_set_property ${dash_path} MessageWindowTextField text "Quartus Fitter is completed successfully for base version"
	exec $quartus_path/quartus_asm --read_settings_files=off --write_settings_files=off $prj_name -c $rev_name
	dashboard_set_property ${dash_path} MessageWindowTextField text "Quartus Assembler is completed successfully for base version"
	exec $quartus_path/quartus_sta $prj_name -c $rev_name	
	dashboard_set_property ${dash_path} MessageWindowTextField text "Quartus TimeQuest Analyzer is completed successfully for base version"
	#QuartusExecution ${quartus_install_path} $prj_name $rev_name 1
	cd $curr_path 
}

####################################################################################################
#                            MLD 
####################################################################################################

if {$MLD_OPTION == true} {

	set ::Integrated_MainControl::MLD_LevelSelection    [dashboard_get_property ${dash_path} MLD_LevelCombo selected ]
	set ::Integrated_MainControl::MLD_DestThresholdVar  [dashboard_get_property ${dash_path} MLD_DestThrstTextField text ]
	set ::Integrated_MainControl::MLD_GrpThresholdVar   [dashboard_get_property ${dash_path} MLD_GrpThrstTextField text ]
	set ::Integrated_MainControl::MLD_clkVar            [dashboard_get_property ${dash_path} clkTextField text ]	
	set ::Integrated_MainControl::MLD_ModuleNumVar      [dashboard_get_property ${dash_path} MLD_ModuleNumCombo selected]
	for {set i 0} {$i < 10} {incr i} {
		set ::Integrated_MainControl::MLD_BlockNumVar($i) [dashboard_get_property ${dash_path} MLD_ModuleTextField($i) text]
	}


	if {${::Integrated_MainControl::MLD_LevelSelection} == 0} {
		set mld_level "CHIP"
	} else {
		set mld_level "BLOCK"
	}
set mld_dest_thrsh $::Integrated_MainControl::MLD_DestThresholdVar
set mld_grp_thrsh $::Integrated_MainControl::MLD_GrpThresholdVar
set mld_clk_name $::Integrated_MainControl::MLD_clkVar

after 2000
        puts "MLD Constraints"
	dashboard_set_property ${dash_path} MessageWindowTextField text "MLD Constraints Generation is running"

	if { ${::Integrated_MainControl::MLD_ModuleNumVar} != 0 } {
		for {set i 0} {$i < ${::Integrated_MainControl::MLD_ModuleNumVar}} {incr i} {
			set mld_block_name $::Integrated_MainControl::MLD_BlockNumVar($i)
		       puts "Quartus Sta $quartus_sta"
		       puts "prj_qpf     $prj_qpf"
		       puts "MLD Level $mld_level"
		       puts "MLD Dest Thrsh $mld_dest_thrsh"
		       puts "MLD GRP Thrsh $mld_grp_thrsh"
		       puts "MLD CLK Name $mld_clk_name"
		       puts "MLD Block Name $mld_block_name"
		       exec $quartus_sta -t  mld_cat.tcl $quartus_sta $prj_qpf $mld_level $mld_dest_thrsh $mld_grp_thrsh $mld_clk_name $mld_block_name
		       dashboard_set_property ${dash_path} MessageWindowTextField text "MLD constraints for Module [expr $i + 1] have been generated - Constraints generation still in progress !"
		}
	} else {
		set mld_block_name $::Integrated_MainControl::MLD_BlockNumVar(0)
	        exec $quartus_sta -t  mld_cat.tcl $quartus_sta $prj_qpf $mld_level $mld_dest_thrsh $mld_grp_thrsh $mld_clk_name $mld_block_name
	        dashboard_set_property ${dash_path} MessageWindowTextField text "Integrated constraints for Block have been generated"
	}	
	
	dashboard_set_property ${dash_path} MessageWindowTextField text "MLD Constraints Generation Finished"
}


####################################################################################################
#                            MAX 
####################################################################################################

if  {$MAX_OPTION == true} {

	set ::Integrated_MainControl::MAX_LevelSelection    [dashboard_get_property ${dash_path} MAX_LevelCombo selected ]
	set ::Integrated_MainControl::MAX_DestThresholdVar  [dashboard_get_property ${dash_path} MAX_DestThrstTextField text ]
	set ::Integrated_MainControl::MAX_clkVar            [dashboard_get_property ${dash_path} clkTextField text ]	
	set ::Integrated_MainControl::MAX_ModuleNumVar      [dashboard_get_property ${dash_path} MAX_ModuleNumCombo selected]
	for {set i 0} {$i < 10} {incr i} {
		set ::Integrated_MainControl::MAX_BlockNumVar($i) [dashboard_get_property ${dash_path} MAX_ModuleTextField($i) text]
	}

	if {${::Integrated_MainControl::MAX_LevelSelection} == 0} {
		set max_level "CHIP"
	} else {
		set max_level "BLOCK"
	}
set max_sdc_dest_thrsh $::Integrated_MainControl::MAX_DestThresholdVar
set max_clk_name $::Integrated_MainControl::MAX_clkVar

	dashboard_set_property ${dash_path} MessageWindowTextField text "MAX Constraints Generation is running"
	if { ${::Integrated_MainControl::MAX_ModuleNumVar} != 0 } {
		for {set i 0} {$i < ${::Integrated_MainControl::MAX_ModuleNumVar}} {incr i} {
		      set max_block_name $::Integrated_MainControl::MAX_BlockNumVar($i)
                       puts "MAX Constraints"
		       puts "Quartus Sta $quartus_sta"
		       puts "prj_qpf     $prj_qpf"
		       puts "MAX Level $max_level"
		       puts "MAX Dest Thrsh $max_sdc_dest_thrsh"
		       puts "MAX CLK Name $max_clk_name"
		       puts "MAX Block Name $max_block_name"
		       exec $quartus_sta -t  max_cat.tcl $quartus_sta $prj_qpf $max_level $max_sdc_dest_thrsh $max_clk_name $max_block_name
		       dashboard_set_property ${dash_path} MessageWindowTextField text "MAX FANOUT constraints for Module [expr $i + 1] have been generated - Constraints generation still in progress !"
		}
	} else {
		set block_name $::Integrated_MainControl::BlockNumVar(0)
		set MAXchoice $::Integrated_MainControl::Blockcheck1($i)
			exec $quartus_sta -t  max_cat.tcl $quartus_sta $prj_qpf $max_level $max_sdc_dest_thrsh $max_clk_name $max_block_name
			dashboard_set_property ${dash_path} MessageWindowTextField text "MAX FANOUT constraints for Block have been generated"
	}	
	
	dashboard_set_property ${dash_path} MessageWindowTextField text "MAX Constraints Generation Finished"

}

####################################################################################################
#                            FLOOR PLAN 
####################################################################################################

if {$FP_OPTION == true} {

	set FP_csv_input    [dashboard_get_property ${dash_path} FloorPlanPathTextField text ]

        dashboard_set_property ${dash_path} MessageWindowTextField text "Generating Floorplan Constraints . . ."
        puts "Floor Constraints"
	puts "QUARTUS STA $quartus_sta"
	puts "Quartus Prj $prj_qpf"
	puts "Floor Plan excel $FP_csv_input"
        exec $quartus_sta -t  floor_cat.tcl $quartus_sta $prj_qpf $FP_csv_input 
        dashboard_set_property ${dash_path} MessageWindowTextField text "FloorPlan Constraints Generated !"

}

####################################################################################################
# ADDING MLD to Master QPF File
#
if  {$MLD_OPTION == true} {
set qsf_file_apd [open $prj_qsf a]

        if { ${::Integrated_MainControl::MLD_ModuleNumVar} != 0 } {
		for {set i 0} {$i < ${::Integrated_MainControl::MLD_ModuleNumVar}} {incr i} {
		      set mld_block_name $::Integrated_MainControl::MLD_BlockNumVar($i)
		      set mld_block_name [concat "$prj_name\_$mld_block_name"] 
		      set qsf_file [concat "\n source   \"$prj_folder\/Fmax_cat\/$mld_block_name\.qsf\""]
		      puts $qsf_file_apd "\n  "
		      puts $qsf_file_apd $qsf_file
		}
	}
close $qsf_file_apd
}




# ADDING MAX to MASTER SDC FILE



if  {$MAX_OPTION == true} {
set sdc_file_apd [open $prj_sdc a]

        if { ${::Integrated_MainControl::MAX_ModuleNumVar} != 0 } {
		set sdc_condt "if \{\(\$\:\:quartus\(nameofexecutable\) \=\= \"quartus_map\"\) \|\| \(\$\:\:quartus\(nameofexecutable\) \=\= \"quartus_fit\"\)\} \{ " 
		puts $sdc_file_apd $sdc_condt
		for {set i 0} {$i < ${::Integrated_MainControl::MAX_ModuleNumVar}} {incr i} {
		      set max_block_name $::Integrated_MainControl::MAX_BlockNumVar($i)
		      set max_block_name [concat "$prj_name\_$max_block_name"] 
		      set sdc_file [concat "\n source   \"$prj_folder\/Fmax_cat\/$max_block_name\.sdc\""]
		      puts $sdc_file_apd "\n "
		      puts $sdc_file_apd $sdc_file 
		}
		puts $sdc_file_apd "\}"
	}
close $sdc_file_apd
}


####################################################################################################


####################################################################################################

set ::Integrated_MainControl::Seed_count      [dashboard_get_property ${dash_path} SS_SeedNumCombo selected]
	set ::Integrated_MainControl::Seed_exec_path  [dashboard_get_property ${dash_path} SS_ExecutionPathTextField text]

	set parallel_run                              [dashboard_get_property ${dash_path} SS_ParallelExecutionCombo selected]
	set parallel_run [expr {$parallel_run +1}]

        set no_seeds $::Integrated_MainControl::Seed_count

	for {set i 0} {$i < $no_seeds} {incr i} {
	    set seed_val [dashboard_get_property ${dash_path} SS_ModuleCombo($i) selected]
	    set seed_order($i) [expr {$seed_val + 1 }]
         }



# This will change based on the Seed Sweed options selected
set seed_path $::Integrated_MainControl::Seed_exec_path 




puts "Seed Iteration $seed_iteration"

for {set iteration_count 1} {$iteration_count <= $seed_iteration} {incr iteration_count} {

puts "Iteration Count $iteration_count"


set seed_iteration_path [concat "$seed_path\/iteration_$iteration_count"]
#set sdc_seed_file       [concat "$seed_iteration_path\/$prj_name\.sdc"]
set sdc_seed_file       [concat "$seed_iteration_path\/$prj_sdc_name\.sdc"]
set All_violations_file     [concat "$seed_iteration_path\/All_Violations\.txt"]
set C_violations_file     [concat "$seed_iteration_path\/Common_Violations\.txt"]

####################################################################################################
#                            SEED  
####################################################################################################

if {$SEED_OPTION == true} {

        dashboard_set_property ${dash_path} MessageWindowTextField text "Starting Seed Sweep . . ."
        puts "Seed Constraints"
	puts "QUARTUS STA $quartus_sta"
	puts "Quartus Prj $prj_qpf"
	puts "Seed Path $seed_iteration_path"
	puts "Parallel  $parallel_run"
	puts "Number of Seeds $no_seeds"
	puts $seed_order(0)
#	puts $seed_order(1)
	file mkdir $seed_iteration_path
        #exec $quartus_sta -t  seedsweep_cat.tcl $quartus_sta $prj_qpf $seed_iteration_path $parallel_run $no_seeds $seed_order
        #exec $quartus_sta -t  seedsweep_cat.tcl $quartus_path $prj_folder $seed_iteration_path $parallel_run $no_seeds 

        StartSeedSweep $quartus_path $prj_folder $seed_iteration_path $parallel_run $no_seeds

        dashboard_set_property ${dash_path} MessageWindowTextField text "Seed Sweep Completed !"
}

####################################################################################################
#                            SEED ANALYZE  
####################################################################################################

if {$SEED_ANALYZE_OPTION == true} {

set ::Integrated_MainControl::MAX_SEED_SeedCntVar  [dashboard_get_property ${dash_path} MAX_SEED_SeedCntTextField text ]
set ::Integrated_MainControl::MAX_SEED_HitCntVar  [dashboard_get_property ${dash_path} MAX_SEED_HitCntTextField text ]

set sdc_seed_cnt $::Integrated_MainControl::MAX_SEED_SeedCntVar 
set sdc_hit_cnt  $::Integrated_MainControl::MAX_SEED_HitCntVar 

	cd $curr_path

        dashboard_set_property ${dash_path} MessageWindowTextField text "Analyze Timing Report is running"

	set qpf_file_list "input_qpf_path.txt"

	set proj_path [open $qpf_file_list "w+"]

	for {set i 1} {$i <= $no_seeds} {incr i} {
        set qpf_path($i) [concat $seed_iteration_path\/seed$i\/$prj_name\.qpf]
	puts "project path : $qpf_path($i)"
	puts $proj_path $qpf_path($i)
	}

	close $proj_path

        puts "Seed Analyze Constraints"
	puts "Quartus Sta $quartus_sta"
	puts "Clock Name $clk_name"
	puts "Number of Seeds $no_seeds"
	puts "Seed Iteration Path $seed_iteration_path"

        exec $quartus_sta -t  seedanalyze_cat.tcl $quartus_sta $clk_name $no_seeds $seed_iteration_path $qpf_file_list $sdc_seed_cnt $sdc_hit_cnt
        dashboard_set_property ${dash_path} MessageWindowTextField text "Comparison Report Generated !"
}


####################################################################################################
#                            MAX DELAY CONSTRAINTS  
####################################################################################################
if {$MAX_SEED_OPTION == true} {
dashboard_set_property ${dash_path} MessageWindowTextField text "Generate MAX DELAY constraint based on violations report across all seeds"
# Need to add as input configuration
set ::Integrated_MainControl::MAX_SEED_DestThresholdVar  [dashboard_get_property ${dash_path} MAX_SEED_DestThrstTextField text ]




#set sdc_dest_thrsh 50
set sdc_dest_thrsh $::Integrated_MainControl::MAX_SEED_DestThresholdVar 


        puts "MAX DELAY Constraints"
	puts "Quartus Sta $quartus_sta"
	puts "Project QPF $prj_qpf"
	puts "Clk Name $clk_name"
	puts "sdc_seed_file $sdc_seed_file"
	puts "violations file $All_violations_file"

exec $quartus_sta -t  max_seed_cat.tcl $quartus_sta $prj_qpf $sdc_dest_thrsh $clk_name $sdc_seed_file $All_violations_file $C_violations_file 

dashboard_set_property ${dash_path} MessageWindowTextField text " MAX DELAY Constraint Report Generated !"

# ADDING to MASTER FILE

set sdc_file_apd [open $prj_sdc a]

set sdc_condt "if \{\(\$\:\:quartus\(nameofexecutable\) \=\= \"quartus_map\"\) \|\| \(\$\:\:quartus\(nameofexecutable\) \=\= \"quartus_fit\"\)\} \{ " 
puts $sdc_file_apd $sdc_condt

puts $sdc_file_apd [concat "\n source   \"$sdc_seed_file\""]
puts $sdc_file_apd "\}" 

close $sdc_file_apd
}
####################################################################################################
}
	
####################################################################################################

}

}
