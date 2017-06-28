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

source ./mld_gui.tcl
source ./max_gui.tcl
source ./seedsweep_gui.tcl
source ./seedsweep_cat.tcl
source ./seedanalyze_gui.tcl
source ./mldanalyze_gui.tcl
source ./floorcat_gui.tcl
source ./integrated_cat.tcl


variable dashboardActive 0
       
		 
if { ${dashboardActive} == 1 } {
return -code ok "dashboard already active"
}
set dashboardActive 1

        #
        # Create dashboard 
        #

		#set dash_mldanalyze      [add_service dashboard dashboard_mldanalyze "MLDAnalyze_CAT" "CAT_Tools/MLDAnalyze_CAT"]
		#set dash_seedanalyze     [add_service dashboard dashboard_seedanalyze "SeedAnalyze_CAT" "CAT_Tools/SeedAnalyze_CAT"]
		#set dash_seedsweep       [add_service dashboard dashboard_seedsweep "SeedSweep_CAT" "CAT_Tools/SeedSweep_CAT"]
		#set dash_max             [add_service dashboard dashboard_max "MAX_CAT" "CAT_Tools/Max_CAT"]
		#set dash_mld             [add_service dashboard dashboard_mld "MLD_CAT" "CAT_Tools/MLD_CAT"]
		#set dash_floorcat        [add_service dashboard dashboard_floor "FLOOR_CAT" "CAT_Tools/FLOOR_CAT"]
		set dash_Integratedcat   [add_service dashboard dashboard_integratedanalyze "Integrated_CAT" "CAT_Tools/Integrated_CAT"]


        #
        # Set dashboard properties
        #
        #dashboard_set_property ${dash_mld} self developmentMode true
        #dashboard_set_property ${dash_mld} self itemsPerRow 1
        #dashboard_set_property ${dash_mld} self visible false 

        #dashboard_set_property ${dash_max} self developmentMode true
        #dashboard_set_property ${dash_max} self itemsPerRow 1
        #dashboard_set_property ${dash_max} self visible false 

        #dashboard_set_property ${dash_seedsweep} self developmentMode true
        #dashboard_set_property ${dash_seedsweep} self itemsPerRow 1
        #dashboard_set_property ${dash_seedsweep} self visible false

        #dashboard_set_property ${dash_seedanalyze} self developmentMode true
        #dashboard_set_property ${dash_seedanalyze} self itemsPerRow 1
        #dashboard_set_property ${dash_seedanalyze} self visible false

        #dashboard_set_property ${dash_mldanalyze} self developmentMode true
        #dashboard_set_property ${dash_mldanalyze} self itemsPerRow 1
        #dashboard_set_property ${dash_mldanalyze} self visible false
	#
        #dashboard_set_property ${dash_floorcat} self developmentMode true
        #dashboard_set_property ${dash_floorcat} self itemsPerRow 1
        #dashboard_set_property ${dash_floorcat} self visible false 


        dashboard_set_property ${dash_Integratedcat} self developmentMode true
        dashboard_set_property ${dash_Integratedcat} self itemsPerRow 1
        dashboard_set_property ${dash_Integratedcat} self visible true 


       	set MLDControlGroup "MLD_CAT"
        set MAXControlGroup "MAX_CAT"
        set SeedSweepControlGroup  "SeedSweep_CAT"
        set SeedAnalyzeControlGroup  "SeedAnalyze_CAT"
        set MLDAnalyzeControlGroup  "MLDAnalyze_CAT"
        set FloorCatControlGroup  "FLOOR_CAT"
	set IntegratedControlGroup "Integrated_CAT"

        #::MLD_MainControl::MLD_DashBoard $dash_mld $MLDControlGroup
        #::MAX_MainControl::MAX_DashBoard $dash_max $MAXControlGroup
        #::SeedSweep_MainControl::SeedSweep_DashBoard $dash_seedsweep $SeedSweepControlGroup
        #::SeedAnalyze_MainControl::SeedAnalyze_DashBoard $dash_seedanalyze $SeedAnalyzeControlGroup
        #::MLDAnalyze_MainControl::MLDAnalyze_DashBoard $dash_mldanalyze $MLDAnalyzeControlGroup
        #::FloorCat_MainControl::FloorCat_DashBoard $dash_floorcat $FloorCatControlGroup
        ::Integrated_MainControl::Integrated_DashBoard $dash_Integratedcat $IntegratedControlGroup

        return -code ok

