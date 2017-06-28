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

package require Thread
namespace eval SeedSweep_MainControl {
  
#namespace export ConfigureTxSysrefMode ConfigureRxSysrefMode GetGuiProperties ConfigurePatternGenerator ConfigurePatternChecker    
  
	 variable SSQuartusInstallationPath
	 variable SSQuartusProjectPath
	 variable SSExecutionPath
	 variable SSNumSeed
	 variable SSTargetClk
	 variable SSParallelization


proc SeedSweep_DashBoard { dash_path tabGroup } {

#image create photo imgobj -file "bigcat_logo.png" -width 400 -height 400 
#pack [label .myLabel]
#.myLabel configure -image imgobj 

#dashboard_set_property ${dash_path} $tabGroup expandableX true
#dashboard_set_property ${dash_path} $tabGroup expandableY true

#Main control widgets
dashboard_add ${dash_path} SStopGroup group self
dashboard_set_property ${dash_path} SStopGroup expandableX false
dashboard_set_property ${dash_path} SStopGroup expandableY true
dashboard_set_property ${dash_path} SStopGroup itemsPerRow 1
dashboard_set_property ${dash_path} SStopGroup title "" 

#Input dialog
#dashboard_add ${dash_path} ControlGroup group SStopGroup
#dashboard_set_property ${dash_path} ControlGroup expandableX false
#dashboard_set_property ${dash_path} ControlGroup expandableY false
#dashboard_set_property ${dash_path} ControlGroup itemsPerRow 1
#dashboard_set_property ${dash_path} ControlGroup title ""

dashboard_add ${dash_path} SSInputData group SStopGroup
dashboard_set_property ${dash_path} SSInputData expandableX false
dashboard_set_property ${dash_path} SSInputData expandableY false
dashboard_set_property ${dash_path} SSInputData preferredWidth 1000
dashboard_set_property ${dash_path} SSInputData title "Input Configuration"
dashboard_set_property ${dash_path} SSInputData itemsPerRow 3

dashboard_add ${dash_path} SSQuartusInstallPath label SSInputData
dashboard_set_property ${dash_path} SSQuartusInstallPath expandableY false
dashboard_set_property ${dash_path} SSQuartusInstallPath expandableX false
dashboard_set_property ${dash_path} SSQuartusInstallPath text "Quartus installation path:"

dashboard_add ${dash_path} SSQuartusInstallPathTextField textField SSInputData
dashboard_set_property ${dash_path} SSQuartusInstallPathTextField expandableY false
dashboard_set_property ${dash_path} SSQuartusInstallPathTextField expandableX false
dashboard_set_property ${dash_path} SSQuartusInstallPathTextField editable true
dashboard_set_property ${dash_path} SSQuartusInstallPathTextField preferredWidth 700
dashboard_set_property ${dash_path} SSQuartusInstallPathTextField text "C:/altera/quartus/bin64"
dashboard_set_property ${dash_path} SSQuartusInstallPathTextField toolTip "Enter Quartus installation location upto bin(or)bin64 folder"

dashboard_add ${dash_path} SSNavigateButton fileChooserButton SSInputData
dashboard_set_property ${dash_path} SSNavigateButton expandableX false
dashboard_set_property ${dash_path} SSNavigateButton expandableY false
dashboard_set_property ${dash_path} SSNavigateButton preferredWidth 30
dashboard_set_property ${dash_path} SSNavigateButton text ".."
dashboard_set_property ${dash_path} SSNavigateButton title "Quartus installation folder"
dashboard_set_property ${dash_path} SSNavigateButton mode "directories_only"
dashboard_set_property ${dash_path} SSNavigateButton chooserButtonText "Select"
dashboard_set_property ${dash_path} SSNavigateButton onChoose "::SeedSweep_MainControl::SeedSweepQuartusPath $dash_path"

dashboard_add ${dash_path} SSQuartusProjectPathLabel label SSInputData
dashboard_set_property ${dash_path} SSQuartusProjectPathLabel expandableY false
dashboard_set_property ${dash_path} SSQuartusProjectPathLabel expandableX false
dashboard_set_property ${dash_path} SSQuartusProjectPathLabel text "Quartus Project path:"

dashboard_add ${dash_path} SSQuartusProjectPathTextField textField SSInputData
dashboard_set_property ${dash_path} SSQuartusProjectPathTextField expandableY false
dashboard_set_property ${dash_path} SSQuartusProjectPathTextField expandableX false
dashboard_set_property ${dash_path} SSQuartusProjectPathTextField editable true
dashboard_set_property ${dash_path} SSQuartusProjectPathTextField preferredWidth 700
dashboard_set_property ${dash_path} SSQuartusProjectPathTextField text "F:/Timing_Improvement/8C4T"
dashboard_set_property ${dash_path} SSQuartusProjectPathTextField toolTip "Point to the required project folder on which seed sweep is to be carried out"

dashboard_add ${dash_path} SSNavigateButton1 fileChooserButton SSInputData
dashboard_set_property ${dash_path} SSNavigateButton1 expandableX false
dashboard_set_property ${dash_path} SSNavigateButton1 expandableY false
dashboard_set_property ${dash_path} SSNavigateButton1 preferredWidth 30
dashboard_set_property ${dash_path} SSNavigateButton1 text ".."
dashboard_set_property ${dash_path} SSNavigateButton1 title "Project folder (containins .qpf and .qsf files)"
dashboard_set_property ${dash_path} SSNavigateButton1 mode "directories_only"
dashboard_set_property ${dash_path} SSNavigateButton1 chooserButtonText "Select"
dashboard_set_property ${dash_path} SSNavigateButton1 onChoose "::SeedSweep_MainControl::SeedSweepProjectPath $dash_path"

dashboard_add ${dash_path} ExecutionPath label SSInputData
dashboard_set_property ${dash_path} ExecutionPath expandableY false
dashboard_set_property ${dash_path} ExecutionPath expandableX false
dashboard_set_property ${dash_path} ExecutionPath text "Execution directory path:"

dashboard_add ${dash_path} ExecutionPathTextField textField SSInputData
dashboard_set_property ${dash_path} ExecutionPathTextField expandableY false
dashboard_set_property ${dash_path} ExecutionPathTextField expandableX false
dashboard_set_property ${dash_path} ExecutionPathTextField editable true
dashboard_set_property ${dash_path} ExecutionPathTextField preferredWidth 700
dashboard_set_property ${dash_path} ExecutionPathTextField text "E:/seed_sweep"
dashboard_set_property ${dash_path} ExecutionPathTextField toolTip "Select directory from where you want to run the seed sweep tool. Note that the quartus project will be copied to this location for every seed"

dashboard_add ${dash_path} NavigateButton2 fileChooserButton SSInputData
dashboard_set_property ${dash_path} NavigateButton2 expandableX false
dashboard_set_property ${dash_path} NavigateButton2 expandableY false
dashboard_set_property ${dash_path} NavigateButton2 preferredWidth 30
dashboard_set_property ${dash_path} NavigateButton2 text ".."
dashboard_set_property ${dash_path} NavigateButton2 title "Seed sweep execution folder"
dashboard_set_property ${dash_path} NavigateButton2 mode "directories_only"
dashboard_set_property ${dash_path} NavigateButton2 chooserButtonText "Select"
dashboard_set_property ${dash_path} NavigateButton2 onChoose "::SeedSweep_MainControl::SeedSweepExecutionPath $dash_path"

#dashboard_add ${dash_path} SSclkLabel label SSInputData
#dashboard_set_property ${dash_path} SSclkLabel expandableY false
#dashboard_set_property ${dash_path} SSclkLabel expandableX false
#dashboard_set_property ${dash_path} SSclkLabel text "Target clock:"

#dashboard_add ${dash_path} SSclkTextField textField SSInputData
#dashboard_set_property ${dash_path} SSclkTextField expandableY false
#dashboard_set_property ${dash_path} SSclkTextField expandableX false
#dashboard_set_property ${dash_path} SSclkTextField editable true
#dashboard_set_property ${dash_path} SSclkTextField preferredWidth 300
#dashboard_set_property ${dash_path} SSclkTextField text "u_a10_soc|iopll_dsp|outclk0"
#dashboard_set_property ${dash_path} SSclkTextField toolTip "Enter full hierarchy of clock"

#dashboard_add ${dash_path} TxemptyLabel2 label SSInputData
#dashboard_set_property ${dash_path} TxemptyLabel2 expandableX false
#dashboard_set_property ${dash_path} TxemptyLabel2 expandableY false
#dashboard_set_property ${dash_path} TxemptyLabel2 text ""
#dashboard_set_property ${dash_path} TxemptyLabel2 preferredWidth 50

dashboard_add ${dash_path} ParallelExecutionLabel label SSInputData
dashboard_set_property ${dash_path} ParallelExecutionLabel expandableY false
dashboard_set_property ${dash_path} ParallelExecutionLabel expandableX false
dashboard_set_property ${dash_path} ParallelExecutionLabel preferredWidth 70
dashboard_set_property ${dash_path} ParallelExecutionLabel text "No. of Parallel Executions:"

dashboard_add ${dash_path} ParallelExecutionCombo comboBox SSInputData
dashboard_set_property ${dash_path} ParallelExecutionCombo expandableY false
dashboard_set_property ${dash_path} ParallelExecutionCombo expandableX false
dashboard_set_property ${dash_path} ParallelExecutionCombo preferredWidth 60
dashboard_set_property ${dash_path} ParallelExecutionCombo selected 0
dashboard_set_property ${dash_path} ParallelExecutionCombo options { "1" "2" "3" }
#dashboard_set_property ${dash_path} LevelCombo onChange "::SeedSweep_MainControl::LevelChange $dash_path"

dashboard_add ${dash_path} TxemptyLabel1 label SSInputData
dashboard_set_property ${dash_path} TxemptyLabel1 expandableX false
dashboard_set_property ${dash_path} TxemptyLabel1 expandableY false
dashboard_set_property ${dash_path} TxemptyLabel1 text ""
dashboard_set_property ${dash_path} TxemptyLabel1 preferredWidth 50





#Number of constraints
dashboard_add ${dash_path} SeedSelectionGroup group SStopGroup
dashboard_set_property ${dash_path} SeedSelectionGroup itemsPerRow 3
dashboard_set_property ${dash_path} SeedSelectionGroup expandableX false
dashboard_set_property ${dash_path} SeedSelectionGroup expandableY false
dashboard_set_property ${dash_path} SeedSelectionGroup preferredWidth 1000
dashboard_set_property ${dash_path} SeedSelectionGroup title "Seed selection"

#dashboard_add ${dash_path} TxILASConfigurationDataGroup group ConstraintSelectionGroup
#dashboard_set_property ${dash_path} TxILASConfigurationDataGroup expandableX false
#dashboard_set_property ${dash_path} TxILASConfigurationDataGroup expandableY false
#dashboard_set_property ${dash_path} TxILASConfigurationDataGroup title "ILAS Configuration Data:"
#dashboard_set_property ${dash_path} TxILASConfigurationDataGroup itemsPerRow 4

dashboard_add ${dash_path} SeedNumLabel label SeedSelectionGroup
dashboard_set_property ${dash_path} SeedNumLabel expandableY false
dashboard_set_property ${dash_path} SeedNumLabel expandableX false
dashboard_set_property ${dash_path} SeedNumLabel preferredWidth 200
dashboard_set_property ${dash_path} SeedNumLabel text "No. of Seeds to be tested:"

dashboard_add ${dash_path} SeedNumCombo comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SeedNumCombo expandableY false
dashboard_set_property ${dash_path} SeedNumCombo expandableX false
dashboard_set_property ${dash_path} SeedNumCombo preferredWidth 100
dashboard_set_property ${dash_path} SeedNumCombo selected 0
dashboard_set_property ${dash_path} SeedNumCombo options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SeedNumCombo toolTip "Enter no. of seeds for which timing analysis is to be carried out"
dashboard_set_property ${dash_path} SeedNumCombo onChange "::SeedSweep_MainControl::SeedNumChange $dash_path"

dashboard_add ${dash_path} SSemptyLabel1 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel1 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel1 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel1 text ""
dashboard_set_property ${dash_path} SSemptyLabel1 preferredWidth 200

dashboard_add ${dash_path} SSModuleLabel(0) label SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleLabel(0) expandableY false
dashboard_set_property ${dash_path} SSModuleLabel(0) expandableX false
dashboard_set_property ${dash_path} SSModuleLabel(0) visible false
dashboard_set_property ${dash_path} SSModuleLabel(0) text "Seed number:"

dashboard_add ${dash_path} SSModuleCombo(0) comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleCombo(0) expandableY false
dashboard_set_property ${dash_path} SSModuleCombo(0) expandableX false
dashboard_set_property ${dash_path} SSModuleCombo(0) preferredWidth 100
dashboard_set_property ${dash_path} SSModuleCombo(0) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SSModuleCombo(0) selected 0
dashboard_set_property ${dash_path} SSModuleCombo(0) visible false
dashboard_set_property ${dash_path} SSModuleCombo(0) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SSemptyLabel2 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel2 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel2 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel2 text ""
dashboard_set_property ${dash_path} SSemptyLabel2 preferredWidth 200


dashboard_add ${dash_path} SSModuleLabel(1) label SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleLabel(1) expandableY false
dashboard_set_property ${dash_path} SSModuleLabel(1) expandableX false
dashboard_set_property ${dash_path} SSModuleLabel(1) visible false
dashboard_set_property ${dash_path} SSModuleLabel(1) text "Seed number:"

dashboard_add ${dash_path} SSModuleCombo(1) comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleCombo(1) expandableY false
dashboard_set_property ${dash_path} SSModuleCombo(1) expandableX false
dashboard_set_property ${dash_path} SSModuleCombo(1) preferredWidth 100
dashboard_set_property ${dash_path} SSModuleCombo(1) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SSModuleCombo(1) selected 1
dashboard_set_property ${dash_path} SSModuleCombo(1) visible false
dashboard_set_property ${dash_path} SSModuleCombo(1) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SSemptyLabel3 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel3 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel3 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel3 text ""
dashboard_set_property ${dash_path} SSemptyLabel3 preferredWidth 200


dashboard_add ${dash_path} SSModuleLabel(2) label SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleLabel(2) expandableY false
dashboard_set_property ${dash_path} SSModuleLabel(2) expandableX false
dashboard_set_property ${dash_path} SSModuleLabel(2) visible false
dashboard_set_property ${dash_path} SSModuleLabel(2) text "Seed number:"

dashboard_add ${dash_path} SSModuleCombo(2) comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleCombo(2) expandableY false
dashboard_set_property ${dash_path} SSModuleCombo(2) expandableX false
dashboard_set_property ${dash_path} SSModuleCombo(2) preferredWidth 100
dashboard_set_property ${dash_path} SSModuleCombo(2) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SSModuleCombo(2) selected 2
dashboard_set_property ${dash_path} SSModuleCombo(2) visible false
dashboard_set_property ${dash_path} SSModuleCombo(2) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SSemptyLabel4 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel4 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel4 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel4 text ""
dashboard_set_property ${dash_path} SSemptyLabel4 preferredWidth 200


dashboard_add ${dash_path} SSModuleLabel(3) label SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleLabel(3) expandableY false
dashboard_set_property ${dash_path} SSModuleLabel(3) expandableX false
dashboard_set_property ${dash_path} SSModuleLabel(3) visible false
dashboard_set_property ${dash_path} SSModuleLabel(3) text "Seed number:"

dashboard_add ${dash_path} SSModuleCombo(3) comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleCombo(3) expandableY false
dashboard_set_property ${dash_path} SSModuleCombo(3) expandableX false
dashboard_set_property ${dash_path} SSModuleCombo(3) preferredWidth 100
dashboard_set_property ${dash_path} SSModuleCombo(3) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SSModuleCombo(3) selected 3
dashboard_set_property ${dash_path} SSModuleCombo(3) visible false
dashboard_set_property ${dash_path} SSModuleCombo(3) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SSemptyLabel5 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel5 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel5 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel5 text ""
dashboard_set_property ${dash_path} SSemptyLabel5 preferredWidth 200


dashboard_add ${dash_path} SSModuleLabel(4) label SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleLabel(4) expandableY false
dashboard_set_property ${dash_path} SSModuleLabel(4) expandableX false
dashboard_set_property ${dash_path} SSModuleLabel(4) visible false
dashboard_set_property ${dash_path} SSModuleLabel(4) text "Seed number:"

dashboard_add ${dash_path} SSModuleCombo(4) comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleCombo(4) expandableY false
dashboard_set_property ${dash_path} SSModuleCombo(4) expandableX false
dashboard_set_property ${dash_path} SSModuleCombo(4) preferredWidth 100
dashboard_set_property ${dash_path} SSModuleCombo(4) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SSModuleCombo(4) selected 4
dashboard_set_property ${dash_path} SSModuleCombo(4) visible false
dashboard_set_property ${dash_path} SSModuleCombo(4) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SSemptyLabel6 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel6 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel6 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel6 text ""
dashboard_set_property ${dash_path} SSemptyLabel6 preferredWidth 200


dashboard_add ${dash_path} SSModuleLabel(5) label SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleLabel(5) expandableY false
dashboard_set_property ${dash_path} SSModuleLabel(5) expandableX false
dashboard_set_property ${dash_path} SSModuleLabel(5) visible false
dashboard_set_property ${dash_path} SSModuleLabel(5) text "Seed number:"

dashboard_add ${dash_path} SSModuleCombo(5) comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleCombo(5) expandableY false
dashboard_set_property ${dash_path} SSModuleCombo(5) expandableX false
dashboard_set_property ${dash_path} SSModuleCombo(5) preferredWidth 100
dashboard_set_property ${dash_path} SSModuleCombo(5) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SSModuleCombo(5) selected 5
dashboard_set_property ${dash_path} SSModuleCombo(5) visible false
dashboard_set_property ${dash_path} SSModuleCombo(5) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SSemptyLabel7 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel7 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel7 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel7 text ""
dashboard_set_property ${dash_path} SSemptyLabel7 preferredWidth 200


dashboard_add ${dash_path} SSModuleLabel(6) label SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleLabel(6) expandableY false
dashboard_set_property ${dash_path} SSModuleLabel(6) expandableX false
dashboard_set_property ${dash_path} SSModuleLabel(6) visible false
dashboard_set_property ${dash_path} SSModuleLabel(6) text "Seed number:"

dashboard_add ${dash_path} SSModuleCombo(6) comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleCombo(6) expandableY false
dashboard_set_property ${dash_path} SSModuleCombo(6) expandableX false
dashboard_set_property ${dash_path} SSModuleCombo(6) preferredWidth 100
dashboard_set_property ${dash_path} SSModuleCombo(6) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SSModuleCombo(6) selected 6
dashboard_set_property ${dash_path} SSModuleCombo(6) visible false
dashboard_set_property ${dash_path} SSModuleCombo(6) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SSemptyLabel8 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel8 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel8 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel8 text ""
dashboard_set_property ${dash_path} SSemptyLabel8 preferredWidth 200


dashboard_add ${dash_path} SSModuleLabel(7) label SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleLabel(7) expandableY false
dashboard_set_property ${dash_path} SSModuleLabel(7) expandableX false
dashboard_set_property ${dash_path} SSModuleLabel(7) visible false
dashboard_set_property ${dash_path} SSModuleLabel(7) text "Seed number:"

dashboard_add ${dash_path} SSModuleCombo(7) comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleCombo(7) expandableY false
dashboard_set_property ${dash_path} SSModuleCombo(7) expandableX false
dashboard_set_property ${dash_path} SSModuleCombo(7) preferredWidth 100
dashboard_set_property ${dash_path} SSModuleCombo(7) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SSModuleCombo(7) selected 7
dashboard_set_property ${dash_path} SSModuleCombo(7) visible false
dashboard_set_property ${dash_path} SSModuleCombo(7) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SSemptyLabel9 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel9 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel9 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel9 text ""
dashboard_set_property ${dash_path} SSemptyLabel9 preferredWidth 200


dashboard_add ${dash_path} SSModuleLabel(8) label SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleLabel(8) expandableY false
dashboard_set_property ${dash_path} SSModuleLabel(8) expandableX false
dashboard_set_property ${dash_path} SSModuleLabel(8) visible false
dashboard_set_property ${dash_path} SSModuleLabel(8) text "Seed number:"

dashboard_add ${dash_path} SSModuleCombo(8) comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleCombo(8) expandableY false
dashboard_set_property ${dash_path} SSModuleCombo(8) expandableX false
dashboard_set_property ${dash_path} SSModuleCombo(8) preferredWidth 100
dashboard_set_property ${dash_path} SSModuleCombo(8) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SSModuleCombo(8) selected 8
dashboard_set_property ${dash_path} SSModuleCombo(8) visible false
dashboard_set_property ${dash_path} SSModuleCombo(8) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SSemptyLabel10 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel10 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel10 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel10 text ""
dashboard_set_property ${dash_path} SSemptyLabel10 preferredWidth 200


dashboard_add ${dash_path} SSModuleLabel(9) label SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleLabel(9) expandableY false
dashboard_set_property ${dash_path} SSModuleLabel(9) expandableX false		
dashboard_set_property ${dash_path} SSModuleLabel(9) visible false
dashboard_set_property ${dash_path} SSModuleLabel(9) text "Seed number:"

dashboard_add ${dash_path} SSModuleCombo(9) comboBox SeedSelectionGroup
dashboard_set_property ${dash_path} SSModuleCombo(9) expandableY false
dashboard_set_property ${dash_path} SSModuleCombo(9) expandableX false
dashboard_set_property ${dash_path} SSModuleCombo(9) preferredWidth 100
dashboard_set_property ${dash_path} SSModuleCombo(9) options { "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" }
dashboard_set_property ${dash_path} SSModuleCombo(9) selected 9
dashboard_set_property ${dash_path} SSModuleCombo(9) visible false
dashboard_set_property ${dash_path} SSModuleCombo(9) toolTip "Select seed number 1-10"

dashboard_add ${dash_path} SSemptyLabel1 label SeedSelectionGroup
dashboard_set_property ${dash_path} SSemptyLabel1 expandableX false
dashboard_set_property ${dash_path} SSemptyLabel1 expandableY false
dashboard_set_property ${dash_path} SSemptyLabel1 text ""
dashboard_set_property ${dash_path} SSemptyLabel1 preferredWidth 800


dashboard_add ${dash_path} StartButton button SeedSelectionGroup
dashboard_set_property ${dash_path} StartButton expandableX false
dashboard_set_property ${dash_path} StartButton expandableY false
dashboard_set_property ${dash_path} StartButton text "Start"
dashboard_set_property ${dash_path} StartButton toolTip "Starts Timing Analysis for selected seed numbers"
dashboard_set_property ${dash_path} StartButton onClick "::SeedSweep_MainControl::StartSeedSweep $dash_path"
dashboard_set_property ${dash_path} StartButton preferredWidth 100

dashboard_add ${dash_path} SSMessageWindow group SStopGroup
dashboard_set_property ${dash_path} SSMessageWindow expandableX false
dashboard_set_property ${dash_path} SSMessageWindow expandableY false
dashboard_set_property ${dash_path} SSMessageWindow title "Message/Warning"
dashboard_set_property ${dash_path} SSMessageWindow preferredWidth 1000
dashboard_set_property ${dash_path} SSMessageWindow itemsPerRow 1

#Message/Warning
#dashboard_add ${dash_path} MessageWindowLabel label MessageWindow
#dashboard_set_property ${dash_path} MessageWindowLabel expandableY false
#dashboard_set_property ${dash_path} MessageWindowLabel expandableX false
#dashboard_set_property ${dash_path} MessageWindowLabel text "Message/Warning:"
#
dashboard_add ${dash_path} SSMessageWindowTextField textField SSMessageWindow
dashboard_set_property ${dash_path} SSMessageWindowTextField expandableY false
dashboard_set_property ${dash_path} SSMessageWindowTextField expandableX false
dashboard_set_property ${dash_path} SSMessageWindowTextField text ""
dashboard_set_property ${dash_path} SSMessageWindowTextField editable false
dashboard_set_property ${dash_path} SSMessageWindowTextField preferredWidth 980
dashboard_set_property ${dash_path} SSMessageWindowTextField preferredHeight 30
}


#Syntax: dashboard_get_property ${dash_path} TxIPLocalMultiframeClockPhaseOffsetTextField text]  
#dashboard_get_property ${dash_path} RegWriteReadCombo selected
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

proc SeedSweepQuartusPath {dash_path} {
	set ::SeedSweep_MainControl::SSQuartusInstallationPath [dashboard_get_property ${dash_path} SSNavigateButton paths]
	set qpath [file nativename $::SeedSweep_MainControl::SSQuartusInstallationPath]
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
	dashboard_set_property ${dash_path} SSQuartusInstallPathTextField text $qpath
	set ::SeedSweep_MainControl::SSQuartusInstallationPath $qpath
	
}

proc SeedSweepProjectPath {dash_path} {
	set ::SeedSweep_MainControl::SSQuartusProjectPath [dashboard_get_property ${dash_path} SSNavigateButton1 paths]
	set qpath [file nativename $::SeedSweep_MainControl::SSQuartusProjectPath]
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
		
	dashboard_set_property ${dash_path} SSQuartusProjectPathTextField text $qpath
	set ::SeedSweep_MainControl::SSQuartusProjectPath $qpath	
}

proc SeedSweepExecutionPath {dash_path} {
	set ::SeedSweep_MainControl::SSExecutionPath [dashboard_get_property ${dash_path} NavigateButton2 paths]
	set qpath [file nativename $::SeedSweep_MainControl::SSExecutionPath]
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
	dashboard_set_property ${dash_path} ExecutionPathTextField text $qpath
	set ::SeedSweep_MainControl::SSExecutionPath $qpath
	
}

proc SeedNumChange {dash_path} {
	set ::SeedSweep_MainControl::SSNumSeed [dashboard_get_property ${dash_path} SeedNumCombo selected]
	#puts ${::SeedSweep_MainControl::SSNumSeed}
	for {set i 0} {$i < 10} {incr i} {
		dashboard_set_property ${dash_path} SSModuleLabel($i) visible false
		dashboard_set_property ${dash_path} SSModuleCombo($i) visible false
	}
	for {set i 0} {$i < [expr (${::SeedSweep_MainControl::SSNumSeed}+1) ]} {incr i} {
		dashboard_set_property ${dash_path} SSModuleLabel($i) visible true
		dashboard_set_property ${dash_path} SSModuleCombo($i) visible true
	}
	dashboard_set_property ${dash_path} SSMessageWindowTextField text "Now select the Seed numbers for which analysis is to be carried out"
}

proc QuartusExecution {Quartus_path prj rev seedn dash_path} {
	#Syntax: quartus_sh --clean [-c <revision_name>] <project>
	exec $Quartus_path/quartus_sh --clean -c * $prj
	dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus has cleaned the project for seed $seedn"
	exec $Quartus_path/quartus_map --read_settings_files=on --write_settings_files=off $prj -c $rev 
	dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus Analysis & Synthesis is completed successfully for seed $seedn"
	exec $Quartus_path/quartus_fit --read_settings_files=off --write_settings_files=off $prj -c $rev --seed=$seedn
	dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus Fitter is completed successfully for seed $seedn"
	exec $Quartus_path/quartus_asm --read_settings_files=off --write_settings_files=off $prj -c $rev
	dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus Assembler is completed successfully for seed $seedn"
	exec $Quartus_path/quartus_sta $prj -c $rev
	dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus Timing Analysis is completed successfully for seed $seedn"
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
		close $fp
		exec bash quartus_execution.sh &
	}
}

proc StartSeedSweep {dash_path} {
	dashboard_set_property ${dash_path} SSMessageWindowTextField text "Seed Sweep is starting"
	set ::SeedSweep_MainControl::SSQuartusInstallationPath [dashboard_get_property ${dash_path} SSQuartusInstallPathTextField text]
	set ::SeedSweep_MainControl::SSQuartusProjectPath [dashboard_get_property ${dash_path} SSQuartusProjectPathTextField text]
	set ::SeedSweep_MainControl::SSExecutionPath [dashboard_get_property ${dash_path} ExecutionPathTextField text]
	#set ::SeedSweep_MainControl::SSTargetClk [dashboard_get_property ${dash_path} SSclkTextField text]
	set ::SeedSweep_MainControl::SSParallelization [dashboard_get_property ${dash_path} ParallelExecutionCombo selected]
	set ::SeedSweep_MainControl::SSNumSeed [dashboard_get_property ${dash_path} SeedNumCombo selected]

	if { [expr ${::SeedSweep_MainControl::SSParallelization} + 1] == 1 } {
		puts "single run"
		for {set i 0} {$i < [expr (${::SeedSweep_MainControl::SSNumSeed}+1) ]} {incr i} {
			
			set ::SeedSweep_MainControl::seedi [dashboard_get_property ${dash_path} SSModuleCombo($i) selected]
			set seed_calc [expr (${::SeedSweep_MainControl::seedi}+1)]
			puts $seed_calc
			dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is going to start for seed $seed_calc"

			file delete -force ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc
			file copy -force ${::SeedSweep_MainControl::SSQuartusProjectPath} ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc
			puts "Copied"
			set prj_name_path [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc *.qpf]
			set rev_name_path [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc *.qsf]
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
			cd ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc
			puts [pwd]
			QuartusExecution ${::SeedSweep_MainControl::SSQuartusInstallationPath} $prj_name $rev_name $seed_calc $dash_path
			dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is successfully completed for seed $seed_calc"
		}
	} elseif { [expr ${::SeedSweep_MainControl::SSParallelization} + 1] == 2 } {
		puts "2 parallel runs"
		for {set i 0} {$i < [expr (${::SeedSweep_MainControl::SSNumSeed}+1) ]} {incr i 2} {

		set ::SeedSweep_MainControl::seedi [dashboard_get_property ${dash_path} SSModuleCombo($i) selected]
		set seed_calc_1 [expr (${::SeedSweep_MainControl::seedi}+1)]
		puts $seed_calc_1
		dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is going to start for seed $seed_calc_1"
		file delete -force ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_1
		file copy -force ${::SeedSweep_MainControl::SSQuartusProjectPath} ${::SeedSweep::SSExecutionPath}/seed$seed_calc_1
		set prj_name_path_1 [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_1 *.qpf]
		set rev_name_path_1 [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_1 *.qsf]
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
		set prj_path1 ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_1
		cd ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_1
		puts [pwd]	
	
		QuartusParallelExecution1 ${::SeedSweep_MainControl::SSQuartusInstallationPath} $prj_path1 $prj_name_1 $rev_name_1 $seed_calc_1
		#dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is successfully completed for seed $seed_calc_1"		
	

		set ::SeedSweep_MainControl::seedi [dashboard_get_property ${dash_path} SSModuleCombo([expr ($i+1)]) selected]
		set seed_calc_2 [expr (${::SeedSweep_MainControl::seedi}+1)]
		puts $seed_calc_2
		after 1000
		dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is going to start for seed $seed_calc_2"

		file delete -force ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_2
		file copy -force ${::SeedSweep_MainControl::SSQuartusProjectPath} ${::SeedSweep::SSExecutionPath}/seed$seed_calc_2
		set prj_name_path_2 [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_2 *.qpf]
		set rev_name_path_2 [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_2 *.qsf]
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
		set prj_path2 ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_2
		cd ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_2
		puts [pwd]	

		#QuartusParallelExecution2 ${::SeedSweep_MainControl::SSQuartusInstallationPath} $prj_path2 $prj_name_2 $rev_name_2 $seed_calc_2
		QuartusExecution ${::SeedSweep_MainControl::SSQuartusInstallationPath} $prj_name_2 $rev_name_2 $seed_calc_2 $dash_path
		dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is successfully completed for seed $seed_calc_2"		

		}
	} elseif { [expr ${::SeedSweep_MainControl::SSParallelization} + 1] == 3 } {
		puts "3 parallel runs"
		for {set i 0} {$i < [expr (${::SeedSweep_MainControl::SSNumSeed}+1) ]} {incr i 3} {

		set ::SeedSweep_MainControl::seedi [dashboard_get_property ${dash_path} SSModuleCombo($i) selected]
		set seed_calc_1 [expr (${::SeedSweep_MainControl::seedi}+1)]
		puts $seed_calc_1
		dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is going to start for seed $seed_calc_1"
		file delete -force ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_1
		file copy -force ${::SeedSweep_MainControl::SSQuartusProjectPath} ${::SeedSweep::SSExecutionPath}/seed$seed_calc_1
		set prj_name_path_1 [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_1 *.qpf]
		set rev_name_path_1 [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_1 *.qsf]
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
		set prj_path1 ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_1
		cd ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_1
		puts [pwd]	
	
		QuartusParallelExecution1 ${::SeedSweep_MainControl::SSQuartusInstallationPath} $prj_path1 $prj_name_1 $rev_name_1 $seed_calc_1
		#dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is successfully completed for seed $seed_calc_1"		
		
		#2nd seed
		set ::SeedSweep_MainControl::seedi [dashboard_get_property ${dash_path} SSModuleCombo([expr ($i+1)]) selected]
		set seed_calc_2 [expr (${::SeedSweep_MainControl::seedi}+1)]
		puts $seed_calc_2
		after 1000
		dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is going to start for seed $seed_calc_2"
		file delete -force ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_2
		file copy -force ${::SeedSweep_MainControl::SSQuartusProjectPath} ${::SeedSweep::SSExecutionPath}/seed$seed_calc_2
		set prj_name_path_2 [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_2 *.qpf]
		set rev_name_path_2 [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_2 *.qsf]
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
		set prj_path2 ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_2
		cd ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_2
		puts [pwd]	
	
		QuartusParallelExecution1 ${::SeedSweep_MainControl::SSQuartusInstallationPath} $prj_path2 $prj_name_2 $rev_name_2 $seed_calc_2
		
		#3rd seed
		set ::SeedSweep_MainControl::seedi [dashboard_get_property ${dash_path} SSModuleCombo([expr ($i+2)]) selected]
		set seed_calc_3 [expr (${::SeedSweep_MainControl::seedi}+1)]
		puts $seed_calc_3
		after 1000
		dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is going to start for seed $seed_calc_3"

		file delete -force ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_3
		file copy -force ${::SeedSweep_MainControl::SSQuartusProjectPath} ${::SeedSweep::SSExecutionPath}/seed$seed_calc_3
		set prj_name_path_3 [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_3 *.qpf]
		set rev_name_path_3 [findfile ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_3 *.qsf]
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
		set prj_path2 ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_3
		cd ${::SeedSweep_MainControl::SSExecutionPath}/seed$seed_calc_3
		puts [pwd]	

		#QuartusParallelExecution2 ${::SeedSweep_MainControl::SSQuartusInstallationPath} $prj_path2 $prj_name_3 $rev_name_3 $seed_calc_3
		QuartusExecution ${::SeedSweep_MainControl::SSQuartusInstallationPath} $prj_name_3 $rev_name_3 $seed_calc_3 $dash_path
		dashboard_set_property ${dash_path} SSMessageWindowTextField text "Quartus compilation is successfully completed for seed $seed_calc_3"		

		}
	}


	

}



 
 
}
