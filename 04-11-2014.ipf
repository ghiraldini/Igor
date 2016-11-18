#pragma rtGlobals=1		// Use modern global access method.

//LAST TIME UPDATED: 04-11-2014
// Modified LoadAndClipPoints for 14.04 Code (MIU valve and Description blank columns dont delete)
// Sean M Added NewCodeLWIA 
// Added Noise Graphs to GGA 09-03-2013
// Added N2Oiso graphs 07-2013
// Added N2O new code 08-13-2013
// Added HF graphs 08-15-2013
// Added HCl & HF-HCl 11-19-2013
// TIWA Working and LWIA working
// Updated temperature bounds check for FGGA
// Has Dr Elena functions - deleteprepandvial
// Has Noise/Noise for TIWA
//  Added TimeStampToggle
// Added EAA graphs
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//LGR Graphs Igor macro to read data files (of various instrument code versions) from FGGAs and LWIAs							//
//																														//
// The below macro was written by Scott Cauble, August 2010 & Modified by Jason Ghiraldini + Dr. Elena							//
// HARD CODED ELEMENTS OF THIS MACRO:																				//
//	max number of graphs that can be displayed is 20.																		//
//	number of measurements per injection is 20 (flags display portion of TIWA and helper function getNoise)						//																								
//																														//
// create table when file is loaded with the average SNR, pkpk noise, duration of test, percent difference								//
// 																							 							//	
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

Macro DisplayLGRGraphs(InstrumentType, DateTimeFormat)
	String InstrumentType
	Variable DateTimeFormat
	Prompt InstrumentType, "Please select instrument type", popup "N2O;N2Oiso;LWIA;LWIAnew;FGGA;TIWA;WVIA;FMA;AMA;NO2;OCS;CO;HF;HCl;HF_HCl;GEO;EAA"
	Prompt DateTimeFormat, "0 for mm/dd/yyyy, 1 for dd/mm/yyyy"
	String cmd
	Printf "\r"	
	Variable WaterDensityHistogram_numBins = 40//CHANGE NUMBER OF BINS for water density histogram
	
	Silent 1
	
	//--------------------------------------------------------------------------FMA Code----------------------------------------------------------------------------------------------------------------------------------------------
	If (CmpStr(InstrumentType, "FMA") == 0)
		If (exists("X_CH4__ppm") != 1)//New version of FGGA code was just loaded.
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		endif
		Printf "Displaying 11 FMA graphs..."
		if (exists("X_CH4__ppm_se") == 1)
		DisplayGraph(1, 11, InstrumentType, "X_CH4__ppm", "TimeW", "CH4 ppm", "Date and Time")
		DisplayGraph(2, 11, InstrumentType, "X_CH4__ppm_se", "TimeW", "CH4 ppm standard error", "Date and Time")
		DisplayGraph(3, 11, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
		DisplayGraph(4, 11, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(5, 11, InstrumentType, "GasP_torr_se", "TimeW", "Gas pressure (torr) standard error", "Date and Time")
		DisplayGraph(6, 11, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(7, 11, InstrumentType, "GasT_C_se", "TimeW", "Gas temp (C) standard error", "Date and Time")
		DisplayGraph(8, 11, InstrumentType, "RD0_us", "TimeW", "Laser A (CH4) Ring-down Time (us)", "Date and Time")
		DisplayGraph(9, 11, InstrumentType, "RD0_us_se", "TimeW", "Laser A (CH4) Ring-down Time (us) standard error", "Date and Time")
		DisplayGraph(10, 11, InstrumentType, "LTC0_v", "TimeW", "LTCA (CH4 laser temp controller voltage)", "Date and Time")
		DisplayGraph(11, 11, InstrumentType, "AmbT_C", "TimeW", "AmbT_C (Ambient Temperature)", "Date and Time")	
		else
		DisplayGraph(1, 11, InstrumentType, "X_CH4__ppm", "TimeW", "CH4 ppm", "Date and Time")
		DisplayGraph(2, 11, InstrumentType, "X_CH4__ppm_sd", "TimeW", "CH4 ppm standard error", "Date and Time")
		DisplayGraph(3, 11, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
		DisplayGraph(4, 11, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(5, 11, InstrumentType, "GasP_torr_sd", "TimeW", "Gas pressure (torr) standard error", "Date and Time")
		DisplayGraph(6, 11, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(7, 11, InstrumentType, "GasT_C_sd", "TimeW", "Gas temp (C) standard error", "Date and Time")
		DisplayGraph(8, 11, InstrumentType, "RD0_us", "TimeW", "Laser A (CH4) Ring-down Time (us)", "Date and Time")
		DisplayGraph(9, 11, InstrumentType, "RD0_us_sd", "TimeW", "Laser A (CH4) Ring-down Time (us) standard error", "Date and Time")
		DisplayGraph(10, 11, InstrumentType, "LTC0_v", "TimeW", "LTCA (CH4 laser temp controller voltage)", "Date and Time")
		DisplayGraph(11, 11, InstrumentType, "AmbT_C", "TimeW", "AmbT_C (Ambient Temperature)", "Date and Time")	
		endif
	Endif
	//--------------------------------------------------------------------------------------------------------------------AMA Code---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	If (CmpStr(InstrumentType, "AMA") == 0)
		If (exists("X_C2H2__ppb") != 1)//Test to see if the data file has already been loaded
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		Endif
		If (exists("X_C2H2__ppb") == 1)//Test to see which version of code was loaded
			Printf "Displaying AMA graphs..."
			DisplayGraph(1, 20, InstrumentType, "X_14CO2__ppm", "TimeW", "CO2 ppm", "Date and Time")
			DisplayGraph(2, 20, InstrumentType, "X_C2H2__ppb", "TimeW", "C2H2 ppb", "Date and Time")
			DisplayGraph(3, 20, InstrumentType, "X_CH4__ppm", "TimeW", "CH4 Toggle ppm", "Date and Time")
			DisplayGraph(4, 20, InstrumentType, "X_CH4H__ppm", "TimeW", "CH4 HIGH ppm", "Date and Time")
			DisplayGraph(5, 20, InstrumentType, "X_CH4L__ppm", "TimeW", "CH4 LOW ppm", "Date and Time")
			DisplayGraph(6, 20, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
			DisplayGraph(7, 20, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
			DisplayGraph(8, 20, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
			DisplayGraph(9, 20, InstrumentType, "AmbT_C", "TimeW", "AmbT_C (Ambient Temperature)", "Date and Time")
			DisplayGraph(11, 20, InstrumentType, "RD0_us", "TimeW", "Laser A Ring-down Time (us)", "Date and Time")
			DisplayGraph(14, 20, InstrumentType, "RD1_us", "TimeW", "Laser B Ring-down Time (us)", "Date and Time")
			DisplayGraph(13, 20, InstrumentType, "LTC0_v", "TimeW", "LTCA (Laser 1 temp controller voltage)", "Date and Time")
			DisplayGraph(14, 20, InstrumentType, "LTC1_v", "TimeW", "LTCB (Laser 2 controller voltage)", "Date and Time")
			DisplayGraph(16, 20, InstrumentType, "BL0T", "TimeW", "Laser A BL0", "Date and Time")
			DisplayGraph(17, 20, InstrumentType, "BL1T", "TimeW", "Laser A BL1", "Date and Time")
			DisplayGraph(18, 20, InstrumentType, "BL0T_B", "TimeW", "Laser B BL0", "Date and Time")
			DisplayGraph(19, 20, InstrumentType, "BL1T_B", "TimeW", "Laser ABBL1", "Date and Time")

		endif
	Endif
	//--------------------------------------------------------------------------------------------------------------------FGGA Code---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	If (CmpStr(InstrumentType, "FGGA") == 0)
		If (exists("X_CO2__ppm") != 1 || exists("X_CH4__ppm") != 1)//Test to see if the data file has already been loaded
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		Else
			Printf "FGGA data already loaded.  If you would like to display graphs for a different data file, run LoadNewLGRDataFile(\"FGGA\"), then re-run DisplayLGRGraphs(\"FGGA\")\r"
		Endif
		If (exists("X_CO2__ppm_se") == 1)//Test to see which version of code was loaded
			Printf "Displaying old code FGGA graphs..."
			DisplayGraph(3, 16, InstrumentType, "X_CO2__ppm", "TimeW", "CO2 ppm", "Date and Time")
			DisplayGraph(4, 16, InstrumentType, "X_CO2__ppm_se", "TimeW", "CO2 ppm standard error", "Date and Time") //Changed the order of graph display
			DisplayGraph(1, 16, InstrumentType, "X_CH4__ppm", "TimeW", "CH4 ppm", "Date and Time")
			DisplayGraph(2, 16, InstrumentType, "X_CH4__ppm_se", "TimeW", "CH4 ppm standard error", "Date and Time")
			DisplayGraph(5, 16, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
			DisplayGraph(6, 16, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
			DisplayGraph(7, 16, InstrumentType, "GasP_torr_se", "TimeW", "Gas pressure (torr) standard error", "Date and Time")
			DisplayGraph(8, 16, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
			DisplayGraph(9, 16, InstrumentType, "GasT_C_se", "TimeW", "Gas temp (C) standard error", "Date and Time")
			DisplayGraph(10, 16, InstrumentType, "RD0_us", "TimeW", "Laser A (CH4) Ring-down Time (us)", "Date and Time")
			DisplayGraph(11, 16, InstrumentType, "RD0_us_se", "TimeW", "Laser A (CH4) Ring-down Time (us) standard error", "Date and Time")
			DisplayGraph(14, 16, InstrumentType, "RD1_us", "TimeW", "Laser B (CO2) Ring-down Time (us)", "Date and Time")
			DisplayGraph(13, 16, InstrumentType, "RD1_us_se", "TimeW", "Laser B (CO2) Ring-down Time (us) standard error", "Date and Time")
			DisplayGraph(14, 16, InstrumentType, "LTC0_v", "TimeW", "LTCA (CH4 laser temp controller voltage)", "Date and Time")
			DisplayGraph(15, 16, InstrumentType, "LTC1_v", "TimeW", "LTCB (CO2 laser temp controller voltage)", "Date and Time")
//			DisplayGraph(16, 16, InstrumentType, "AmbT_C", "TimeW", "AmbT_C (Ambient Temperature)", "Date and Time")
		endif
		If (exists("X_CO2__ppm_sd") ==1)//new code was loaded
			DisplayGraph(3, 16, InstrumentType, "X_CO2__ppm", "TimeW", "CO2 ppm", "Date and Time")
			DisplayGraph(4, 16, InstrumentType, "X_CO2__ppm_sd", "TimeW", "CO2 ppm standard error", "Date and Time") //Changed the order of graph display
			DisplayGraph(1, 16, InstrumentType, "X_CH4__ppm", "TimeW", "CH4 ppm", "Date and Time")
			DisplayGraph(2, 16, InstrumentType, "X_CH4__ppm_sd", "TimeW", "CH4 ppm standard error", "Date and Time")
			DisplayGraph(5, 16, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
			DisplayGraph(6, 16, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
			DisplayGraph(7, 16, InstrumentType, "GasP_torr_sd", "TimeW", "Gas pressure (torr) standard error", "Date and Time")
			DisplayGraph(8, 16, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
			DisplayGraph(9, 16, InstrumentType, "GasT_C_sd", "TimeW", "Gas temp (C) standard error", "Date and Time")
			DisplayGraph(10, 16, InstrumentType, "RD0_us", "TimeW", "Laser A (CH4) Ring-down Time (us)", "Date and Time")
			DisplayGraph(11, 16, InstrumentType, "RD0_us_sd", "TimeW", "Laser A (CH4) Ring-down Time (us) standard error", "Date and Time")
			DisplayGraph(14, 16, InstrumentType, "RD1_us", "TimeW", "Laser B (CO2) Ring-down Time (us)", "Date and Time")
			DisplayGraph(13, 16, InstrumentType, "RD1_us_sd", "TimeW", "Laser B (CO2) Ring-down Time (us) standard error", "Date and Time")
			DisplayGraph(14, 16, InstrumentType, "LTC0_v", "TimeW", "LTCA (CH4 laser temp controller voltage)", "Date and Time")
			DisplayGraph(15, 16, InstrumentType, "LTC1_v", "TimeW", "LTCB (CO2 laser temp controller voltage)", "Date and Time")
			DisplayGraph(16, 16, InstrumentType, "AmbT_C", "TimeW", "AmbT_C (Ambient Temperature)", "Date and Time")
		endif
	Endif
	//--------------------------------------------------------------------------------------LWIA Code---------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
	If (CmpStr(InstrumentType, "LWIA") == 0)
		If (exists("H2O_N_cm3"))//A set of data columns unique to this type of instrument
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
			print "Close Igor and Load new data..."
		Else
			Printf "LWIA data already loaded.   If you would like to display graphs for a different data file, run LoadNewLGRDataFile(\"LWIA\"), then re-run DisplayLGRGraphs(\"LWIA\")\r"
		Endif
		If (exists("H2O_N_cm3") == 1 && numpnts(Time_sec) == numpnts(H2O_N_cm3))//Make sure the set of data columns unique to this type of instrument is present
			//Also make sure the number of points in the time wave matches the number of pts in one of the unique waves
			Printf "Displaying 7 LWIA graphs..."//follow the format below
			DisplayGraph(1, 8, InstrumentType, "D_H", "Time_sec", "D/H Ratio", "Date and Time")
			DisplayGraph(2, 8, InstrumentType, "O18_O16", "Time_sec", "18O/16O Ratio", "Date and Time")
			DisplayGraph(3, 8, InstrumentType, "H2O_N_cm3", "Time_sec", "Water Number Density (cm-3)", "Date and Time")
			ModifyGraph mode=3
			
			Make/N=(WaterDensityHistogram_numBins)/O H2O_N_cm3_HistLGRGraphs//CHANGE BINS HERE
			Histogram/B=1 H2O_N_cm3,H2O_N_cm3_HistLGRGraphs
			String histogramaxisname
			sPrintf histogramaxisname, "Counts (%g bins)", WaterDensityHistogram_numBins
			DisplayGraph(4, 8, InstrumentType, "H2O_N_cm3_HistLGRGraphs", "", histogramaxisname, "Water Number Density (cm-3)")
			ModifyGraph mode=5
			
			DisplayGraph(5, 8, InstrumentType, "FitCoeff_18", "Time_sec", "Pressure Width Coefficient", "Date and Time")
			DisplayGraph(6, 8, InstrumentType, "RD_Tau", "Time_sec", "Ring-down Time (us)", "Date and Time")
			DisplayGraph(7, 8, InstrumentType, "Temp_Celsius", "Time_sec", "Gas temp (C)", "Date and Time")
			DisplayGraph(8, 8, InstrumentType, "FitCoeff_13", "Time_sec", "Line Position (GHz)", "Date and Time")
		Endif
	Endif
	//--------------------------------------------------------------------------------------LWIA  New Code---------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
	If (CmpStr(InstrumentType, "LWIAnew") == 0)
		If (exists("X_H2Oa_ND") != 1)//A set of data columns unique to this type of instrument
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
			print "Close Igor and Load new data..."
		Else
			Printf "LWIA data already loaded.   If you would like to display graphs for a different data file, run LoadNewLGRDataFile(\"LWIA\"), then re-run DisplayLGRGraphs(\"LWIA\")\r"
		Endif
			If (exists("X_H2Oa__ND") == 1)//Make sure the set of data columns unique to this type of instrument is present
			Variable nMeasInj = 30						// 30 measurements per injection hard coded
			Variable numInjs = numpnts(TimeW)/nMeasInj		
			Variable numFlags = 0, i=(nMeasInj-1)			//  Code outputs the flag in the last measurement line
            
			DisplayGraph(1, 8, InstrumentType, "DHr", "TimeW", "D/H Ratio", "Date and Time")
			ModifyGraph gaps=0
			DisplayGraph(2, 8, InstrumentType, "O18O16r", "TimeW", "18O/16O Ratio", "Date and Time")
			ModifyGraph gaps=0
			DisplayGraph(3, 8, InstrumentType, "X_H2Oa__ND", "TimeW", "Water Number Density (cm-3)", "Date and Time")
			ModifyGraph mode=4
			
			Make/N=(WaterDensityHistogram_numBins)/O X_H2Oa__ND_HistLGRGraphs//CHANGE BINS HERE
			Histogram/B=1 X_H2Oa__ND,X_H2Oa__ND_HistLGRGraphs
			String histogramaxisname
			sPrintf histogramaxisname, "Counts (%g bins)", WaterDensityHistogram_numBins
		
			DisplayGraph(4, 8, InstrumentType, "X_H2Oa__ND_HistLGRGraphs", "", histogramaxisname, "Water Number Density (cm-3)")
			ModifyGraph mode=5

			DisplayGraph(5, 8, InstrumentType, "GasP_torr", "TimeW", "Pressure", "Date and Time")
			ModifyGraph mode=4
			DisplayGraph(6, 8, InstrumentType, "RD0_us", "TimeW", "RD Laser A", "Date and Time")
			DisplayGraph(7, 8, InstrumentType, "GasT_C", "TimeW", "Cell Temperature", "Date and Time")
			DisplayGraph(8, 8, InstrumentType, "H2Oa_10_CT", "TimeW", "Line Posistion A", "Date and Time")
		Endif
	Endif
	//------------------------------------------------------------------------------------------------TIWA Code-------------------------------------------------------------------------------------------------------------------------------------
		
	If (CmpStr(InstrumentType, "TIWA") == 0)
		If (exists("X_H2Oa__ND") != 1) //A set of data columns unique to this type of instrument
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		Else
			Printf "T-LWIA data already loaded.   If you would like to display graphs for a different data file, run LoadNewLGRDataFile(\"LWIA\"), then re-run DisplayLGRGraphs(\"LWIA\")\r"
		Endif
		If (exists("X_H2Oa__ND") == 1 && numpnts(X_H2Oa__ND) == numpnts(DHr))//Make sure the set of data columns unique to this type of instrument is present
			Variable nMeasInj = 30						// 30 measurements per injection hard coded
			Variable numInjs = numpnts(TimeW)/nMeasInj		
			Variable numFlags = 0, i=(nMeasInj-1)			//  Code outputs the flag in the last measurement line
			
			deletePrepandVial()
			getNoise(nMeasInj)
			do
				if (Cmpstr (Flag[i], "           norm") != 0)
					numFlags += 1
				endif
				i+=nMeasInj
			while (i<(numInjs*nMeasInj))

                	print "-------------------------------------------------------------------------------------------------------------------"
			print nMeasInj, "measurements per injection", numFlags, "flags out of", numInjs, "injections", numFlags/numInjs*100,"%"
			print "--------------------------------------------------------------------------------------------------------------------"

			Printf "Displaying 16 IWIA graphs..."//follow the format below
			DisplayGraph(1, 16, InstrumentType, "DHr", "TimeW", "D/H Ratio", "Date and Time")
			DisplayGraph(2, 16, InstrumentType, "O18O16r", "TimeW", "18O/16O Ratio", "Date and Time")
			DisplayGraph(3, 16, InstrumentType, "O17O16r", "TimeW", "17O/16O Ratio", "Date and Time")
			DisplayGraph(4, 16, InstrumentType, "GasT_C", "TimeW", "Cell Temperature", "Date and Time")			
			DisplayGraph(6, 16, InstrumentType, "X_H2Oa__ND", "TimeW", "Water Number Density (cm-3)", "Date and Time")
			ModifyGraph mode=3
			Make/N=(WaterDensityHistogram_numBins)/O X_H2Oa__ND_HistLGRGraphs//CHANGE BINS HERE
			Histogram/B=1 X_H2Oa__ND,X_H2Oa__ND_HistLGRGraphs
			String histogramaxisname
			sPrintf histogramaxisname, "Counts (%g bins)", WaterDensityHistogram_numBins
			DisplayGraph(5, 16, InstrumentType, "X_H2Oa__ND_HistLGRGraphs", "", histogramaxisname, "Water Number Density (cm-3)")
			ModifyGraph mode=5
			DisplayGraph(7, 16, InstrumentType, "X_H2Ob__ND", "TimeW", "H2Ob ppm", "Date and Time")
			ModifyGraph mode=3

			DisplayGraph(8, 16, InstrumentType, "GasP_torr", "TimeW", "Pressure", "Date and Time")
			ModifyGraph mode=4
			DisplayGraph(9, 16, InstrumentType, "RD0_us", "TimeW", "RD Laser A", "Date and Time")
			DisplayGraph(10, 16, InstrumentType, "RD1_us", "TimeW", "RD Laser B", "Date and Time")
			
			DisplayGraph(11, 16, InstrumentType, "H2Oa_10_CT", "TimeW", "Line Posistion A", "Date and Time")
			DisplayGraph(13, 16, InstrumentType, "H2Oa_10_PT", "TimeW", "Pressure Width A", "Date and Time")
			DisplayGraph(14, 16, InstrumentType, "H2Ob_10_CT_B", "TimeW", "Line Position B", "Date and Time")
			DisplayGraph(14, 16, InstrumentType, "H2Ob_10_PT_B", "TimeW", "Pressure Width B", "Date and Time")
			DisplayGraph(15, 16, InstrumentType, "GasP_torr", "X_H2Oa__ND", "Correlation", "Pressure vs Injection Volume")
			DisplayGraph(16, 16, InstrumentType, "DH_noise", "Injection_num", "Avg/Stdev", "Injection Number")
			AppendToGraph O18_noise vs Injection_num
			AppendToGraph O17_noise vs Injection_num
			
			ModifyGraph rgb(O18_noise)=(0,15872,65280)
			ModifyGraph rgb(O17_noise)=(0,0,0)
			
			WaveStats/Q O18_noise
                    Variable tagpt = V_minloc
                    Tag/W=TIWA_Graph16 /L=0/I=0 /X=1/Y=75 O18_noise, tagpt, "O18: \{mean(O18_noise)} \rO17: \{mean(O17_noise)} \rDH : \{mean(DH_noise)}"

			Printf "If you would like to print these graphs, run Print_Graphs(\"%s\")\r", InstrumentType
		Else
			Printf "Cannot recognize %s data column names. Try running the LoadNewLGRDataFile(\"%s\")\r", InstrumentType, InstrumentType
			Abort("Cannot recognize data column names. Try running the LoadNewLGRDataFile() macro.")
		Endif
	Endif
	//-----------------------------------------------------------------------------------------------WVIA Code---------------------------------------------------------------------------------------------------------------------------------------
If (CmpStr(InstrumentType, "WVIA") == 0)
		If (exists("H2O_ppm") != 1)//Test to see if the data file has already been loaded
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType, DateTimeFormat
			 LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		Endif
			Printf "Data already loaded.  If you would like to display graphs for a different data file, run LoadNewLGRDataFile(\"FGGA\"), then re-run DisplayLGRGraphs(\"FGGA\")\r"

		If (exists("H2Oc_ppm_se") == 1)//Test to see which version of code was loaded
			Printf "Displaying old code FGGA graphs..."
			DisplayGraph(1, 16, InstrumentType, "H2Oc_ppm", "TimeW", "CO2 ppm", "Date and Time")
			DisplayGraph(2, 16, InstrumentType, "H2O16c_ppm", "TimeW", "CO2 ppm standard error", "Date and Time") //Changed the order of graph display
			DisplayGraph(3, 16, InstrumentType, "H2O18c_ppm", "TimeW", "CH4 ppm", "Date and Time")
			DisplayGraph(4, 16, InstrumentType, "HODc_ppm", "TimeW", "CH4 ppm standard error", "Date and Time")
			DisplayGraph(5, 16, InstrumentType, "O18_del", "TimeW", "H2O ppm", "Date and Time")
			DisplayGraph(6, 16, InstrumentType, "D_del", "TimeW", "Gas pressure (torr)", "Date and Time")
			DisplayGraph(7, 16, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr) standard error", "Date and Time")
			DisplayGraph(8, 16, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
			DisplayGraph(9, 16, InstrumentType, "Gnd", "TimeW", "Gas temp (C) standard error", "Date and Time")
			DisplayGraph(10, 16, InstrumentType, "RD0_us", "TimeW", "Laser A (CH4) Ring-down Time (us)", "Date and Time")
			DisplayGraph(11, 16, InstrumentType, "Peak0", "TimeW", "Laser A (CH4) Ring-down Time (us) standard error", "Date and Time")
			DisplayGraph(14, 16, InstrumentType, "BL0T", "TimeW", "Laser B (CO2) Ring-down Time (us)", "Date and Time")
			DisplayGraph(13, 16, InstrumentType, "BL1T", "TimeW", "Laser B (CO2) Ring-down Time (us) standard error", "Date and Time")
			DisplayGraph(14, 16, InstrumentType, "LTC0_v", "TimeW", "LTCA (CH4 laser temp controller voltage)", "Date and Time")
			DisplayGraph(15, 16, InstrumentType, "AmbT_C", "TimeW", "LTCB (CO2 laser temp controller voltage)", "Date and Time")
			DisplayGraph(16, 16, InstrumentType, "Raw18_ppm", "TimeW", "AmbT_C (Ambient Temperature)", "Date and Time")			
		endif
		If (exists("O17_del") == 1)//New Code
			Printf "Displaying old code FGGA graphs..."
		
			DisplayGraph(1, 20, InstrumentType, "O17_del", "TimeW", "O17 del", "Date and Time") //Changed the order of graph display
			DisplayGraph(2, 20, InstrumentType, "O18_del", "TimeW", "O18_del", "Date and Time")
			DisplayGraph(3, 20, InstrumentType, "D_del", "TimeW", "D_del", "Date and Time")
			DisplayGraph(4, 20, InstrumentType, "DH", "TimeW", "DH", "Date and Time")	
			DisplayGraph(5, 20, InstrumentType, "O18O16", "TimeW", "O18/O16", "Date and Time")
			DisplayGraph(6, 20, InstrumentType, "O17O16", "TimeW", "O17/O16", "Date and Time")
			DisplayGraph(7, 20, InstrumentType, "H2O_ppm", "TimeW", "H2O ppm", "Date and Time")
			ModifyGraph rgb=(0,43520,65280)
			DisplayGraph(8, 20, InstrumentType, "RD0_us", "TimeW", "Laser A Ring-down Time (us)", "Date and Time")
			DisplayGraph(9, 20, InstrumentType, "RD1_us", "TimeW", "Laser B Ring-down Time (us)", "Date and Time")
			DisplayGraph(11, 20, InstrumentType, "BL0T", "TimeW", "Laser 1 BL0", "Date and Time")
			DisplayGraph(12, 20, InstrumentType, "BL1T", "TimeW", "Laser 1 BL1", "Date and Time")
			DisplayGraph(13, 20, InstrumentType, "BL0T_B", "TimeW", "Laser 2 BL0", "Date and Time")
			DisplayGraph(14, 20, InstrumentType, "BL1T_B", "TimeW", "Laser 2 BL1", "Date and Time")
			DisplayGraph(16, 20, InstrumentType, "LTC0_v", "TimeW", "Linelock A", "Date and Time")
			DisplayGraph(17, 20, InstrumentType, "LTC1_v", "TimeW", "Linelock B", "Date and Time")
			DisplayGraph(18, 20, InstrumentType, "GasP_torr", "TimeW", "Gas pressure ", "Date and Time")
			DisplayGraph(19, 20, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
			DisplayGraph(20, 20, InstrumentType, "Gnd", "TimeW", "Detector Ground", "Date and Time")	
		endif
	Endif
	//-----------------------------------------------------------------------------------------------CO Code---------------------------------------------------------------------------------------------------------------------------------------
	If (CmpStr(InstrumentType, "CO") == 0)
//		sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
		LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
		Execute /Q cmd
		DisplayGraph(1, 10, InstrumentType, "X_CO__ppm", "TimeW", "CO ppm", "Date and Time")
		DisplayGraph(2, 10, InstrumentType, "AIN5", "TimeW", "AIN5 (Supercool temperature)", "Date and Time")
		DisplayGraph(3, 10, InstrumentType, "AIN6", "TimeW", "AIN6 (Laser temperature)", "Date and Time")
		DisplayGraph(4, 10, InstrumentType, "LTC0_v", "TimeW", "Line lock voltage (Laser temp controller)", "Date and Time")
		DisplayGraph(5, 10, InstrumentType, "Peak0", "TimeW", "Peak0 (Peak spacing)Laser temp controller voltage", "Date and Time")
		DisplayGraph(6, 10, InstrumentType, "AmbT_C", "TimeW", "Ambient temp (C)", "Date and Time")
		DisplayGraph(7, 10, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(8, 10, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(9, 10, InstrumentType, "Gnd", "TimeW", "Gnd (Detector background)", "Date and Time")
//		DisplayGraph(10, 10, InstrumentType, "[CO_dry]__ppm", "[H2O]__ppm", "CO Water Broadening", "H2O Concentration")
	Endif

//---------------------------------------------------------------------------EAA----------------------------------------------------------------------------------------------------------------------------------
	If (CmpStr(InstrumentType, "EAA") == 0)
		If (exists("TimeW") != 1)//New version of FGGA code was just loaded.
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		endif
		Printf "Displaying graphs..."
		if(exists("X_NH3__ppm"))
		DisplayGraph(1, 14, InstrumentType, "X_NH3__ppm", "TimeW", "NH3 ppm", "Date and Time")
		DisplayGraph(2, 14, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
		DisplayGraph(3, 14, InstrumentType, "AmbT_C", "TimeW", "Ambient Temperature", "Date and Time")	
		DisplayGraph(4, 14, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(5, 14, InstrumentType, "GasT_C_se", "TimeW", "Gas temp Std Err", "Date and Time")
		DisplayGraph(6, 14, InstrumentType, "RD0_us", "TimeW", "Ring-down", "Date and Time")
		DisplayGraph(7, 14, InstrumentType, "RD0_us_se", "TimeW", "Ring-down Std Err", "Date and Time")
		DisplayGraph(8, 14, InstrumentType, "LTC0_v", "TimeW", "Laser temp voltage", "Date and Time")
		DisplayGraph(9, 14, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(10, 14, InstrumentType, "GasP_torr_se", "TimeW", "Gas pressure Std Err", "Date and Time")
		DisplayGraph(11, 14, InstrumentType, "BL0T", "TimeW", "Baseline 0", "Date and Time")
		DisplayGraph(14, 14, InstrumentType, "BL1T", "TimeW", "Baseline 1", "Date and Time")
		endif
		if(exists("X_NH3_a_ppm"))
		DisplayGraph(1, 16, InstrumentType, "X_NH3_a_ppm", "TimeW", "NH3 ppm 1st Fit", "Date and Time")
		DisplayGraph(2, 16, InstrumentType, "X_NH3_b_ppm", "TimeW", "NH3 ppm 2nd Fit", "Date and Time")
		DisplayGraph(3, 16, InstrumentType, "X_H2O_a_ppm", "TimeW", "H2O ppm 1st Fit", "Date and Time")
		DisplayGraph(4, 16, InstrumentType, "X_H2O_b_ppm", "TimeW", "H2O ppm 2nd Fit", "Date and Time")		
		DisplayGraph(5, 16, InstrumentType, "AmbT_C", "TimeW", "Ambient Temperature", "Date and Time")	
		DisplayGraph(6, 16, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(7, 16, InstrumentType, "GasT_C_sd", "TimeW", "Gas temp Std Err", "Date and Time")
		DisplayGraph(8, 16, InstrumentType, "RD0_us", "TimeW", "Ring-down", "Date and Time")
		DisplayGraph(9, 16, InstrumentType, "LTC0_v", "TimeW", "Laser temp voltage", "Date and Time")
		DisplayGraph(10, 16, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(11, 16, InstrumentType, "BL0T_0", "TimeW", "1st Baseline 0", "Date and Time")
		DisplayGraph(12, 16, InstrumentType, "BL1T_0", "TimeW", "1st Baseline 1", "Date and Time")
		DisplayGraph(13, 16, InstrumentType, "BL0T_0", "TimeW", "2nd Baseline 0", "Date and Time")
		DisplayGraph(14, 16, InstrumentType, "BL1T_0", "TimeW", "2nd Baseline 1", "Date and Time")
		endif

	Endif
	//-----------------------------------------------------------------------------------------------HF----------------------------------------------------------------------------------------------------------------
	If (CmpStr(InstrumentType, "HF") == 0)
		If (exists("X_HF__ppm") != 1)//New version of FGGA code was just loaded.
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		endif
		Printf "Displaying graphs..."
		DisplayGraph(1, 14, InstrumentType, "X_HF__ppm", "TimeW", "HF ppm", "Date and Time")
		DisplayGraph(2, 14, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
		DisplayGraph(3, 14, InstrumentType, "AmbT_C", "TimeW", "Ambient Temperature", "Date and Time")	
		DisplayGraph(4, 14, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(5, 14, InstrumentType, "GasT_C_se", "TimeW", "Gas temp Std Err", "Date and Time")
		DisplayGraph(6, 14, InstrumentType, "RD0_us", "TimeW", "Ring-down", "Date and Time")
		DisplayGraph(7, 14, InstrumentType, "RD0_us_se", "TimeW", "Ring-down Std Err", "Date and Time")
		DisplayGraph(8, 14, InstrumentType, "LTC0_v", "TimeW", "Laser temp voltage", "Date and Time")
		DisplayGraph(9, 14, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(10, 14, InstrumentType, "GasP_torr_se", "TimeW", "Gas pressure Std Err", "Date and Time")
		DisplayGraph(11, 14, InstrumentType, "BL0T", "TimeW", "Baseline 0", "Date and Time")
		DisplayGraph(14, 14, InstrumentType, "BL1T", "TimeW", "Baseline 1", "Date and Time")

	Endif
	If (CmpStr(InstrumentType, "HCl") == 0)
		If (exists("X_HCL__ppm") != 1)//New version of FGGA code was just loaded.
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		endif
		Printf "Displaying graphs..."
		DisplayGraph(1, 16, InstrumentType, "X_HCL__ppm", "TimeW", "HCL ppm", "Date and Time")
		DisplayGraph(2, 16, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
		DisplayGraph(3, 16, InstrumentType, "AmbT_C", "TimeW", "Ambient Temperature", "Date and Time")	
		DisplayGraph(4, 16, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(5, 16, InstrumentType, "RD0_us", "TimeW", "Ring-down", "Date and Time")
		DisplayGraph(6, 16, InstrumentType, "Gnd", "TimeW", "Gnd (Detector background)", "Date and Time")
		DisplayGraph(7, 16, InstrumentType, "LTC0_v", "TimeW", "Laser temp voltage", "Date and Time")
		DisplayGraph(8, 16, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(9, 16, InstrumentType, "BL0T", "TimeW", "Baseline 0", "Date and Time")
		DisplayGraph(10, 16, InstrumentType, "BL1T", "TimeW", "Baseline 1", "Date and Time")

	Endif
	If (CmpStr(InstrumentType, "HF_HCl") == 0)
		If (exists("TimeW") == 0)//New version of FGGA code was just loaded.
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
		Printf "Displaying graphs..."
		endif
		DisplayGraph(1, 20, InstrumentType, "X_HF__ppm", "TimeW", "HF ppm", "Date and Time")
		DisplayGraph(2, 20, InstrumentType, "X_HCL__ppm", "TimeW", "HCL ppm", "Date and Time")
		DisplayGraph(3, 20, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
		DisplayGraph(4, 20, InstrumentType, "AmbT_C", "TimeW", "Ambient Temperature", "Date and Time")	
		DisplayGraph(5, 20, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(6, 20, InstrumentType, "RD0_us", "TimeW", "Ring-down 0", "Date and Time")
		DisplayGraph(7, 20, InstrumentType, "RD1_us", "TimeW", "Ring-down 1", "Date and Time")
		DisplayGraph(8, 20, InstrumentType, "LTC0_v", "TimeW", "Laser 1 temp voltage", "Date and Time")
		DisplayGraph(9, 20, InstrumentType, "LTC1_v", "TimeW", "Laser 2 temp voltage", "Date and Time")
		DisplayGraph(10, 20, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(11, 20, InstrumentType, "BL0T_A", "TimeW", "Laser A Baseline 1-0", "Date and Time")
		DisplayGraph(14, 20, InstrumentType, "BL1T_A", "TimeW", "Laser A Baseline 1-1", "Date and Time")
		DisplayGraph(13, 20, InstrumentType, "BL0T2_A", "TimeW", "Laser A Baseline 2-0", "Date and Time")
		DisplayGraph(14, 20, InstrumentType, "BL1T2_A", "TimeW", "Laser A Baseline 2-1", "Date and Time")
		DisplayGraph(16, 20, InstrumentType, "BL0T_B", "TimeW", "Laser B Baseline 1-0", "Date and Time")
		DisplayGraph(17, 20, InstrumentType, "BL1T_B", "TimeW", "Laser B Baseline 1-1", "Date and Time")
//		DisplayGraph(18, 20, InstrumentType, "BL0T2_B", "TimeW", "Laser B Baseline 2-0", "Date and Time")
//		DisplayGraph(19, 20, InstrumentType, "BL1T2_B", "TimeW", "Laser B Baseline 2-1", "Date and Time")
	Endif
	//--------------------------------------------------------------------------------------------------OCS-----------------------------------------------------------------------------------------------------------
	If (CmpStr(InstrumentType, "OCS") == 0)
		If (exists("X_OCS__ppm") != 1 || exists("X_CO2__ppm") != 1)//Test to see if the data file has already been loaded
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		Else
			Printf "Data already loaded."
		Endif
		Printf "Displaying OCS graphs..."
		if(exists("BL0T") == 1)
		DisplayGraph(1, 16, InstrumentType, "X_OCS__ppm", "TimeW", "OCS ppb", "Date and Time")
		DisplayGraph(2, 16, InstrumentType, "X_CO2__ppm", "TimeW", "CO2 ppb", "Date and Time")
		DisplayGraph(3, 16, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
		DisplayGraph(4, 16, InstrumentType, "AIN5", "TimeW", "AIN5 (Supercool temperature)", "Date and Time")
		DisplayGraph(5, 16, InstrumentType, "AIN6", "TimeW", "Laser Temp", "Date and Time")
		DisplayGraph(6, 16, InstrumentType, "LTC0_v", "TimeW", "Line lock voltage (Laser temp controller)", "Date and Time")
		DisplayGraph(7, 16, InstrumentType, "Peak0", "TimeW", "Peak0 (Peak spacing)Laser temp controller voltage", "Date and Time")
		DisplayGraph(8, 16, InstrumentType, "AmbT_C", "TimeW", "Ambient temp (C)", "Date and Time")
		DisplayGraph(9, 16, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(10, 16, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(11, 16, InstrumentType, "X_OCS_dry__ppm", "X_H2O__ppm", "OCS Water Broadening", "H2O Concentration")
		DisplayGraph(14, 16, InstrumentType, "X_CO2_dry__ppm", "X_H2O__ppm", "CO2 Water Broadening", "H2O Concentration")
		DisplayGraph(13, 16, InstrumentType, "DetOff", "TimeW", "Detector Offset", "Date and Time")
		DisplayGraph(14, 16, InstrumentType, "RD0_us", "TimeW", "RD", "Date and Time")
		DisplayGraph(15, 16, InstrumentType, "BL0T", "TimeW", "Baseline 0", "Date and Time")
		DisplayGraph(16, 16, InstrumentType, "BL1T", "TimeW", "Baseline 1", "Date and Time")			
		else
		DisplayGraph(1, 13, InstrumentType, "X_OCS__ppm", "TimeW", "OCS ppb", "Date and Time")
		DisplayGraph(2, 13, InstrumentType, "X_CO2__ppm", "TimeW", "CO2 ppb", "Date and Time")
		DisplayGraph(3, 13, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
		DisplayGraph(4, 13, InstrumentType, "AIN5", "TimeW", "AIN5 (Supercool temperature)", "Date and Time")
		DisplayGraph(5, 13, InstrumentType, "AIN6", "TimeW", "Laser Temp", "Date and Time")
		DisplayGraph(7, 13, InstrumentType, "LTC0_v", "TimeW", "Line lock voltage (Laser temp controller)", "Date and Time")
		DisplayGraph(6, 13, InstrumentType, "AIN7", "TimeW", "Detector Temp", "Date and Time")
		DisplayGraph(8, 13, InstrumentType, "AmbT_C", "TimeW", "Ambient temp (C)", "Date and Time")
		DisplayGraph(9, 13, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(10, 13, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(11, 13, InstrumentType, "X_OCS_dry__ppm", "X_H2O__ppm", "OCS Water Broadening", "H2O Concentration")
		DisplayGraph(14, 13, InstrumentType, "X_CO2_dry__ppm", "X_H2O__ppm", "CO2 Water Broadening", "H2O Concentration")
//		DisplayGraph(13, 16, InstrumentType, "DetOff", "TimeW", "Detector Offset", "Date and Time")
		DisplayGraph(13, 13, InstrumentType, "RD0_us", "TimeW", "RD", "Date and Time")
//		DisplayGraph(15, 16, InstrumentType, "BL0T", "TimeW", "Baseline 0", "Date and Time")
//		DisplayGraph(16, 16, InstrumentType, "BL1T", "TimeW", "Baseline 1", "Date and Time")			
		endif
		
	Endif
	
	//-------------------------------------------------------------------------------------------N2O Code-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
	If (CmpStr(InstrumentType, "N2O") == 0)
		If (exists("X_CO__ppm") != 1 || exists("X_N2O__ppm") != 1)//Test to see if the data file has already been loaded
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		Else
			Printf "N2O data already loaded.  If you would like to display graphs for a different data file, run LoadNewLGRDataFile(\"N2O\"), then re-run DisplayLGRGraphs(\"N2O\")\r"
		Endif
		If (exists("X_CO__ppm_se") == 1)//Test to see which version of code was loaded
		Print "Displaying 16 N2O graphs..."
		DisplayGraph(1, 16, InstrumentType, "X_N2O__ppm", "TimeW", "N2O ppm", "Date and Time")
		DisplayGraph(2, 16, InstrumentType, "X_CO__ppm", "TimeW", "CO ppm", "Date and Time")
		DisplayGraph(3, 16, InstrumentType, "AIN5", "TimeW", "Supercool Temp", "Date and Time")
		DisplayGraph(4, 16, InstrumentType, "AIN6", "TimeW", "Laser Temp", "Date and Time")
		DisplayGraph(5, 16, InstrumentType, "LTC0_v", "TimeW", "Line lock voltage (Laser temp controller)", "Date and Time")
		DisplayGraph(6, 16, InstrumentType, "Peak0", "TimeW", "Peak0 (Peak spacing)Laser temp controller voltage", "Date and Time")
		DisplayGraph(7, 16, InstrumentType, "AmbT_C", "TimeW", "Ambient temp (C)", "Date and Time")
		DisplayGraph(8, 16, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(9, 16, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(10, 16, InstrumentType, "Gnd", "TimeW", "Gnd (Detector background)", "Date and Time")
		DisplayGraph(11, 16, InstrumentType, "X_CO_dry__ppm", "X_H2O__ppm", "CO Water Broadening", "H2O Concentration")
		DisplayGraph(14, 16, InstrumentType, "X_N2O_dry__ppm", "X_H2O__ppm", "N2O Water Broadening", "H2O Concentration")
		DisplayGraph(13, 16, InstrumentType, "DetOff", "TimeW", "Detector Offset", "Date and Time")
		DisplayGraph(14, 16, InstrumentType, "X_N2O__ppm", "X_CO__ppm", "PPB", "PPB")
		DisplayGraph(15, 16, InstrumentType, "BL0T", "TimeW", "Baseline 0", "Date and Time")
		DisplayGraph(16, 16, InstrumentType, "BL1T", "TimeW", "Baseline 1", "Date and Time")			
		endif
		If (exists("X_CO__ppm_sd") ==1)//new code was loaded
		DisplayGraph(1, 20, InstrumentType, "X_N2O__ppm", "TimeW", "N2O ppm", "Date and Time")
		DisplayGraph(2, 20, InstrumentType, "X_CO__ppm", "TimeW", "CO ppm", "Date and Time")
		DisplayGraph(3, 20, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
		DisplayGraph(4, 20, InstrumentType, "AmbT_C", "TimeW", "Ambient temp (C)", "Date and Time")
		DisplayGraph(5, 20, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		
		DisplayGraph(6, 20, InstrumentType, "AIN5", "TimeW", "Supercool Temp", "Date and Time")
		DisplayGraph(7, 20, InstrumentType, "AIN6", "TimeW", "Laser Temp", "Date and Time")
		DisplayGraph(8, 20, InstrumentType, "AIN7", "TimeW", "Detector Temp", "Date and Time")			
		DisplayGraph(9, 20, InstrumentType, "LTC0_v", "TimeW", "Line lock voltage (Laser temp controller)", "Date and Time")
		DisplayGraph(10, 20, InstrumentType, "Peak0", "TimeW", "Peak Spacing", "Date and Time")
		
		DisplayGraph(11, 20, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(14, 20, InstrumentType, "Gnd", "TimeW", "Detector Lock Voltage", "Date and Time")
		DisplayGraph(13, 20, InstrumentType, "DetOff", "TimeW", "Detector Lock Control Voltage", "Date and Time")
		DisplayGraph(14, 20, InstrumentType, "X_CO_d_ppm", "X_H2O__ppm", "CO Water Broadening", "H2O Concentration")
		DisplayGraph(15, 20, InstrumentType, "X_N2O_d_ppm", "X_H2O__ppm", "N2O Water Broadening", "H2O Concentration")

		DisplayGraph(16, 20, InstrumentType, "BL0T", "TimeW", "Baseline 0", "Date and Time")
		DisplayGraph(17, 20, InstrumentType, "BL1T", "TimeW", "Baseline 1", "Date and Time")			
		DisplayGraph(18, 20, InstrumentType, "Xaxis0", "TimeW", "Etalon A", "Date and Time")
		DisplayGraph(19, 20, InstrumentType, "Xaxis1", "TimeW", "Etalon B", "Date and Time")
		DisplayGraph(20, 20, InstrumentType, "Xaxis2", "TimeW", "Etalon C", "Date and Time")			

		endif
	Endif
		//-------------------------------------------------------------------------------------------N2OIso Code-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
	If (CmpStr(InstrumentType, "N2Oiso") == 0)
		If (exists("X_N2O__ppm") != 1)//Test to see if the data file has already been loaded
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		Else
			Printf "N2Oiso data already loaded.  If you would like to display graphs for a different data file, run LoadNewLGRDataFile(\"N2O\"), then re-run DisplayLGRGraphs(\"N2O\")\r"
		Endif
		Print "Displaying 16 N2O graphs..."
		DisplayGraph(1, 20, InstrumentType, "X_N2O__ppm", "TimeW", "N2O ppm", "Date and Time")
		DisplayGraph(2, 20, InstrumentType, "X_NNO__ppm", "TimeW", "NNO", "Date and Time")
		DisplayGraph(3, 20, InstrumentType, "X_NN15O__ppm", "TimeW", "NN15O", "Date and Time")
		DisplayGraph(4, 20, InstrumentType, "X_N15NO__ppm", "TimeW", "N15NO", "Date and Time")
		DisplayGraph(5, 20, InstrumentType, "X_NNO18__ppm", "TimeW", "NNO18", "Date and Time")
		DisplayGraph(6, 20, InstrumentType, "X_H2O__ppm", "TimeW", "H2O ppm", "Date and Time")
		
		DisplayGraph(7, 20, InstrumentType, "d15NA", "TimeW", "d15NA", "Date and Time")
		DisplayGraph(8, 20, InstrumentType, "d15NB", "TimeW", "d15NB", "Date and Time")
		DisplayGraph(9, 20, InstrumentType, "d18O", "TimeW", "d18O", "Date and Time")
		DisplayGraph(10, 20, InstrumentType, "d15N", "TimeW", "d15N", "Date and Time")
		
		DisplayGraph(11, 20, InstrumentType, "GasT_C", "TimeW", "Cell Temp", "H2O Concentration")
		DisplayGraph(14, 20, InstrumentType, "AmbT_C", "TimeW", "Ambient temp (C)", "Date and Time")
		DisplayGraph(13, 20, InstrumentType, "AIN5", "TimeW", "SuperCool Temp", "PPB")
		AppendToGraph/W=N2Oiso_Graph13/R AIN6 vs TimeW
		ModifyGraph rgb(AIN6)=(0,15872,65280),axRGB(right)=(0,15872,65280),tlblRGB(right)=(0,15872,65280),alblRGB(right)=(0,15872,65280)
		Label right "Laser Temp"
//		DisplayGraph(15, 20, InstrumentType, "AIN6", "TimeW", "Laser Temp", "Date and Time")
		DisplayGraph(14, 20, InstrumentType, "AIN7", "TimeW", "Detector Temp", "Date and Time")	
		AppendToGraph/W=N2Oiso_Graph14/R DetOff vs TimeW
		ModifyGraph rgb(DetOff)=(0,15872,65280),axRGB(right)=(0,15872,65280),tlblRGB(right)=(0,15872,65280),alblRGB(right)=(0,15872,65280)
		Label right "Detector Offset"
//		DisplayGraph(20, 20, InstrumentType, "DetOff", "TimeW", "Detector Control Voltage", "Date and Time")			
		DisplayGraph(15, 20, InstrumentType, "LTC0_v", "TimeW", "Linelock", "PPB")				
		DisplayGraph(16, 20, InstrumentType, "GasP_torr", "TimeW", "Pressure", "H2O Concentration")
		DisplayGraph(17, 20, InstrumentType, "Gnd", "TimeW", "Detector Ground", "PPB")
		DisplayGraph(18, 20, InstrumentType, "Peak0", "TimeW", "Peak Fitting", "Date and Time")
		DisplayGraph(19, 20, InstrumentType, "RD0_us", "TimeW", "Ringdown (us)", "Date and Time")
		DisplayGraph(20, 20, InstrumentType, "BL0T", "TimeW", "Basline 0 and 1", "Date and Time")
		AppendToGraph/R BL1T vs TimeW
		ModifyGraph rgb(BL1T)=(0,15872,65280),axRGB(right)=(0,15872,65280),tlblRGB(right)=(0,15872,65280),alblRGB(right)=(0,15872,65280)
		Label right "Baseline 1"
	Endif
	//-------------------------------------------------------------------------------------------GEO Code-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
	If (CmpStr(InstrumentType, "GEO") == 0)
		If (exists("X_CH4__ppm") != 1)//Test to see if the data file has already been loaded
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		Else
			Printf "GEO data already loaded.  If you would like to display graphs for a different data file, run LoadNewLGRDataFile(\"N2O\"), then re-run DisplayLGRGraphs(\"N2O\")\r"
		Endif
		DisplayGraph(1, 14, InstrumentType, "X_CH4__ppm", "TimeW", "CH4 ppm", "Date and Time")
		DisplayGraph(2, 14, InstrumentType, "X_CH4__ppm_se", "TimeW", "S_dev ppm", "Date and Time")
		DisplayGraph(3, 14, InstrumentType, "Delta", "TimeW", "Delta", "Date and Time")
		DisplayGraph(4, 14, InstrumentType, "RD0_us", "TimeW", "Ring Down", "Date and Time")
		DisplayGraph(5, 14, InstrumentType, "LTC0_v", "TimeW", "Line lock voltage (Laser temp controller)", "Date and Time")
		DisplayGraph(6, 14, InstrumentType, "Flow", "TimeW", "Flow Rate", "Date and Time")
		DisplayGraph(7, 14, InstrumentType, "GasT_C", "TimeW", "Gas temp (C)", "Date and Time")
		DisplayGraph(8, 14, InstrumentType, "GasP_torr", "TimeW", "Gas pressure (torr)", "Date and Time")
		DisplayGraph(9, 14, InstrumentType, "Gnd", "TimeW", "Gnd (Detector background)", "Date and Time")
		DisplayGraph(10, 14, InstrumentType, "PelT_C", "TimeW", "Peltier Temp", "Date and Time")
		DisplayGraph(11, 14, InstrumentType, "BL0T", "TimeW", "Baseline 0", "Date and Time")
		DisplayGraph(14, 14, InstrumentType, "BL1T", "TimeW", "Baseline 1", "Date and Time")			
	Endif

//-------------------------------------------------------------------------------------------NO2 Code-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
	If (CmpStr(InstrumentType, "NO2") == 0)
		If (exists("Concentration__ppb_") != 1)//Test to see if the data file has already been loaded
//			sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrumentType
			LoadNewLGRDataFile(InstrumentType, DateTimeFormat)
			Execute /Q cmd
		Else
			Printf "GEO data already loaded.  If you would like to display graphs for a different data file, run LoadNewLGRDataFile(\"N2O\"), then re-run DisplayLGRGraphs(\"N2O\")\r"
		Endif
			DisplayGraph(1, 16, InstrumentType, "Concentration__ppb_", "Measurement_Time_Stamp", "NO2 ppb", "Date and Time")
			DisplayGraph(2, 16, InstrumentType, "Concentration_SE__ppb_", "Measurement_Time_Stamp", "SE ppm", "Date and Time")
			DisplayGraph(3, 16, InstrumentType, "Tau__s_", "Measurement_Time_Stamp", "Tau", "Date and Time")
			DisplayGraph(4, 16, InstrumentType, "Tau_SE__s_", "Measurement_Time_Stamp", "Tau SE", "Date and Time")
			DisplayGraph(5, 16, InstrumentType, "Pressure__Torr_", "Measurement_Time_Stamp", "Pressure", "Date and Time")
			DisplayGraph(6, 16, InstrumentType, "Temperature__C_", "Measurement_Time_Stamp", "Cavity Temp (C)", "Date and Time")
			DisplayGraph(7, 16, InstrumentType, "LED_Temperature__V_", "Measurement_Time_Stamp", "LED Temp (V)", "Date and Time")
			DisplayGraph(8, 16, InstrumentType, "Instrument_Temperature__C_", "Measurement_Time_Stamp", "Ambient Temp", "Date and Time")
			DisplayGraph(9, 16, InstrumentType, "Loss__ppm_cm_", "Measurement_Time_Stamp", "Loss", "Date and Time")
			DisplayGraph(10, 16, InstrumentType, "Good_Fits", "Measurement_Time_Stamp", "Number Good Fits", "Date and Time")
			DisplayGraph(11, 16, InstrumentType, "Fit_Amplitude__V_", "Measurement_Time_Stamp", "Fit Amplitude", "Date and Time")
			DisplayGraph(14, 16, InstrumentType, "Fit_Amplitude_SE__V_", "Measurement_Time_Stamp", "Fit Amplitude SE", "Date and Time")
			DisplayGraph(13, 16, InstrumentType, "Fit_Offset__V_", "Measurement_Time_Stamp", "Fit Offset", "Date and Time")
			DisplayGraph(14, 16, InstrumentType, "Fit_Offset_SE__V_", "Measurement_Time_Stamp", "Fit Offset SE", "Date and Time")	
	Endif

	//-------------------------------------------------------------------------------------------HELPER FUNCTIONS-----------------------------------------shouldnt have to modify any code below-------------------------------------------------------------------------------------------
Function getNoise(nFitsPerInj)
	Variable nFitsPerInj
	
	Variable i = 0
	Variable x = 0
	Variable count = (numpnts(TimeW)/nFitsPerInj)
	Make/N=(count)/O DH_noise, O18_noise, O17_noise, Injection_num
	do
		WaveStats/Q/R=[x,(x+nFitsPerInj-1)] DHr
		DH_noise[i] = V_avg/V_sdev	
		WaveStats/Q/R=[x,(x+nFitsPerInj-1)] O18O16r
		O18_noise[i] = V_avg/V_sdev	
		WaveStats/Q/R=[x,(x+nFitsPerInj-1)] O17O16r
		O17_noise[i] = V_avg/V_sdev	
		Injection_num[i] = i+1
		i+=1
		x+=nFitsPerInj
	while(i < count)
	Edit DH_noise, O18_noise, O17_noise, Injection_num
	WaveStats /Q DH_noise
	print "D/H noise", V_avg
	WaveStats /Q O18_noise
	print "O18/O16 noise", V_avg
	WaveStats /Q O17_noise
	print "O17/O16 noise", V_avg
	
End

Macro deletePrepandVial()
	Variable i, j
	Variable numPoints =  numpnts(TimeW)
	Variable count=0
	String cmd
	
	Silent 1
	printf "Removing injections with prep and vial flags..."
	PauseUpdate
	
	i=numPoints-1		// starting from the end, because the number of points changes as you delete
	do
		if ((Cmpstr (Flag[i], "           prep") == 0) || (Cmpstr (Flag[i], "           vial") == 0))
			count +=1
			j = 0
			do
				sprintf cmd, "DeletePoints (%g), 1, %s" i, ImportedWaveNames[j]
				Execute /Q cmd
				
				j+=1
			while (j < numpnts(ImportedWaveNames))
		endif
		i-=1
	while (i>=0)
	ResumeUpdate
	
	print count, " injections removed"

End


Function LoadNewLGRDataFile(InstrumentType, timestamp)
	String InstrumentType
	Variable timestamp
	If (CmpStr(InstrumentType, "FGGA") == 0)
		Printf "Loading FGGA data file..."
		LoadAndClipPoints (1,2, timestamp)		
	Endif
	If (CmpStr(InstrumentType, "FMA") == 0)
		Printf "Loading FMA data file..."
		LoadAndClipPoints (1,2, timestamp)
	Endif
	If (CmpStr(InstrumentType, "LWIA") == 0)
		Printf "Loading LWIA data file..."
		LoadAndClipPoints (0,0,timestamp)
	Endif
	If (CmpStr(InstrumentType, "LWIAnew") == 0)
		Printf "Loading LWIA data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif
	If (CmpStr(InstrumentType, "TIWA") == 0)
		Printf "Loading TIWA data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif
	If (CmpStr(InstrumentType, "N2O") == 0)
		Printf "Loading N2O data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif
	If (CmpStr(InstrumentType, "N2Oiso") == 0)
		Printf "Loading N2Oiso data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif
	If (CmpStr(InstrumentType,  "WVIA") == 0)
		Printf "Loading WVIA data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif
	If (CmpStr(InstrumentType, "NO2") == 0)
		Printf "Loading NO2 data file..."
		LoadAndClipPoints (2,3,timestamp)
	Endif
	If (CmpStr(InstrumentType, "AMA") == 0)
		Printf "Loading AMA data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif
	If (CmpStr(InstrumentType, "HF") == 0)
		Printf "Loading HF data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif
	If (CmpStr(InstrumentType, "HCl") == 0)
		Printf "Loading HCl data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif
	If (CmpStr(InstrumentType, "EAA") == 0)
		Printf "Loading EAA data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif
	If (CmpStr(InstrumentType, "HF_HCl") == 0)
		Printf "Loading HF_HCl data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif

	If (CmpStr(InstrumentType, "OCS") == 0)
		Printf "Loading OCS data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif
	If (CmpStr(InstrumentType, "GEO") == 0)
		Printf "Loading GEO data file..."
		LoadAndClipPoints (1,2,timestamp)
	Endif

End
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Function Reload(t)
//	Variable t
//	Variable i
//	do
//		LoadAndClipPoints(1,2,)
//		for (i=0; i < t; i+=1)
//			print "delay"
//		endfor
//	while(t != -1)
		
//End

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function CloseOldGraphs(InstrumentType)

	//			HARD-CODED SECTIONS IN THIS FUNCTION:  maximum number of total graphs
	//

	String InstrumentType
	
	//Determine how many graphs there are to close.
	
	String GraphBaseName = InstrumentType + "_Graph"
	String CurrentGraphName
	Variable numGraphsToClose = 0
	Variable i = 0
	Do
		i += 1
		CurrentGraphName = GraphBaseName + num2str(i)
		DoWindow /F $CurrentGraphName
		If (V_flag != 0)
			numGraphsToClose += 1
		Endif
	while (i < 20)
	
	//Close the graphs.
	
	If (numGraphsToClose != 0)
		String cmd10
		cmd10 = "Closing " + num2str(numGraphsToClose) + " previously-made " + GraphBaseName + "s to avoid Date/Time wave mismatches.\r"
		Printf cmd10
		i = 0
		Do
			i += 1
			CurrentGraphName = GraphBaseName + num2str(i)
			DoWindow $CurrentGraphName
			If (V_flag != 0)
				KillWindow $CurrentGraphName
			Endif
		While (i < 20)
	Endif
End
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function LoadAndClipPoints(TWEAKS_ColumnLabelLine, TWEAKS_FirstDataLine, date_time)

	//
	//			NO HARD-CODED SECTIONS OF THIS FUNCTION
	//
	Variable TWEAKS_ColumnLabelLine
	Variable TWEAKS_FirstDataLine
	Variable date_time
	String/G gfullpath // added to update data from directory -- do not delete (called in Update function)
	
	//Load the waves
	if(date_time == 1)
	LoadWave/J/D/W/E=1/K=0/V={"\t,"," $",1,0}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}  // For "dd/mm/year"
	endif
	if(date_time == 0)
	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0} // For "mm/dd/year"
	endif
	
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)
	gfullpath = S_path+S_fileName
	Print "Path name and file name of data loaded: ", gfullpath

	If (V_flag == 0)
		Printf "No columns imported!\r"
		Abort
	Endif
	
	If (V_flag == 1)//make this better, i.e. find a smarter algorithm to see if the desired columns were loaded correctly
		String cmd8
		sprintf cmd8, "Data file \"%s\" loaded using incorrect LoadWave tweaks", S_fileName
		printf ".  %s", cmd8
		Abort(cmd8)
	Endif	
	Printf " %g columns loaded from \"%s\"\r", V_flag, S_fileName//note that V_flag = numpnts(ImportedWaveNames)

	//Determine the number of "trash" cells, i.e. the number of cells to clip at the tail end of the columns.

	Printf "Scanning imported data... "
	
	Variable numDataCells_thiswave
	Variable numGoodDataPoints_thiswave
	
	Variable maxDataCells_allwaves
	Variable numGoodDataPoints_allwaves
	Variable numTrashCells_allwaves
	
	Variable i = 0
	do
		i += 1
		numDataCells_thiswave = numpnts($ImportedWaveNames[i - 1])//Total number of data cells in the column, including blanks
		Wavestats /Q $ImportedWaveNames[i - 1]
		numGoodDataPoints_thiswave = V_npnts//Total number of *filled* data cells in the column
		If (i == 1)//On the first column scanned, assume all the filled data cells are good data points
			numGoodDataPoints_allwaves = numGoodDataPoints_thiswave
		Endif
		If (numGoodDataPoints_thiswave < numGoodDataPoints_allwaves && numGoodDataPoints_thiswave != 0)//if this column has fewer filled data cells than any other column (meaning fewer filled trash cells)....
			numGoodDataPoints_allwaves = numGoodDataPoints_thiswave
		Endif
		If (numDataCells_thiswave > maxDataCells_allwaves)//if this column has more trash than any other previously-scanned column...
			maxDataCells_allwaves = numDataCells_thiswave
		Endif
	while (i < numpnts(ImportedWaveNames)-2) // (-2) do NOT do WaveStats on MIU Valve and Description when they are blank
	
	numTrashCells_allwaves = maxDataCells_allwaves - numGoodDataPoints_allwaves
	
//-------//Clip off the trash cells from each column.---------Make new algorithm to delete everything after finding "-----BEGIN PGP MESSAGE-----"
	
	Printf "%g total data entries.  Trimming %g rows of .INI settings from the bottom of the imported columns...", numGoodDataPoints_allwaves, numTrashCells_allwaves
	Variable numTrashCells_thiswave
	i = 0
	String cmd7
	do
		i += 1
		numDataCells_thiswave = numpnts($ImportedWaveNames[i - 1])//Total number of data cells in the TimeW column, including blanks
		If (numDataCells_thiswave != numGoodDataPoints_allwaves)
			numTrashCells_thiswave = numDataCells_thiswave - numGoodDataPoints_allwaves//The difference is trash
			sprintf cmd7, "DeletePoints (%g - %g), %g, %s" numDataCells_thiswave, numTrashCells_thiswave, numTrashCells_thiswave, ImportedWaveNames[i - 1]
			Execute /Q cmd7
		Endif
	while (i - 1 < numpnts(ImportedWaveNames)-3) // (-3) to NOT delete the MIU valve and description columns when they are blank / not in use
	Printf " done.\r"
End
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function DisplayGraph(GraphNumber, numTotalGraphs, InstrumentName, GraphYAxisWaveName, GraphXAxisWaveName, LeftLabel, BottomLabel)//Example: DisplayGraph(1, "InstrumentType", "X_CO2__ppm", "CO2 ppm")
	
	//		HARD-CODED SECTIONS OF THIS FUNCTION:
	//
	//	1)	The tiling layout (TotalRows and TotalColumns) for different numTotalGraphs.
	//	2)	The screen resolution for Macintosh computers.  (Currently 1440 x 800)
	//	3)	Slight offsets for displaying correctly on a Windows computer.
	
	Variable GraphNumber
	Variable numTotalGraphs
	String InstrumentName
	String GraphYAxisWaveName
	String GraphXAxisWaveName
	String LeftLabel
	String BottomLabel
	If (numTotalGraphs < 1 || numTotalGraphs > 20)
		Printf "%g is an invalid total graph number\r", numTotalGraphs
		Abort
	Endif
	If (GraphNumber < 1 || GraphNumber > numTotalGraphs)
		Printf "%g is an invalid graph number\r", GraphNumber
		Abort
	Endif
	
	//Define how the graph windows are tiled on the screen.
	
	Variable TotalRows
	Variable TotalColumns
	If (numTotalGraphs > 16 && numTotalGraphs <= 20)
		numTotalGraphs = 20
		TotalRows = 4
		TotalColumns = 5
	Endif
	If (numTotalGraphs > 14 && numTotalGraphs <= 16)
		numTotalGraphs = 16
		TotalRows = 4
		TotalColumns = 4
	Endif
	If (numTotalGraphs > 9 && numTotalGraphs <= 14)
		numTotalGraphs = 14
		TotalRows = 3
		TotalColumns = 4
	Endif
	If (numTotalGraphs > 4 && numTotalGraphs <= 9)
		numTotalGraphs = 9
		TotalRows = 3
		TotalColumns = 3
	Endif
	If (numTotalGraphs > 2  && numTotalGraphs <= 4)
		numTotalGraphs = 4
		TotalRows = 2
		TotalColumns = 2
	Endif
	If (numTotalGraphs > 0  && numTotalGraphs <= 2)
		numTotalGraphs = 2
		TotalRows = 2
		TotalColumns = 1
	Endif
	Variable GraphsPerColumn = TotalRows
	Variable GraphsPerRow = TotalColumns
	
	//determine available pixels on the main Igor window

	Movewindow /F 2, 2, 2, 2
	GetWindow kwFrameInner, wsize
	Variable ScreenMaxX, ScreenMaxY, ScreenMinX, ScreenMinY
	If (V_left == 0 && V_top == 0 && V_right == 0 && V_bottom == 0)
		ScreenMaxX = 1440
		ScreenMaxY = 800
		ScreenMinX = 0
		ScreenMinY = 44//offset by width of top menu bar
	Else
		ScreenMaxX = V_right - 0.25
		ScreenMaxY = V_bottom - 23.35//leave room for the minimized windows at bottom of screen
		ScreenMinX = V_left
		ScreenMinY = V_top + 22.5//offset by width of top menu bar
		//Printf "MaxX = %g, MaxY = %g, MinX = %g, MinY = %g \r", V_right, V_bottom, V_left, V_top
	Endif
	
	//Calculate the position for this particular graph to display
	
	Variable Graphleft, Graphtop, Graphright, Graphbottom
	Variable GraphColumn, GraphRow
	
	GraphRow = floor( (GraphNumber - 0.1) / GraphsPerRow) + 1
	GraphColumn = GraphNumber - ((GraphRow - 1) * GraphsPerRow)
	
	
	Graphleft = (GraphColumn - 1) * (ScreenMaxX - ScreenMinX) / GraphsPerRow + ScreenMinX
	Graphright = (GraphColumn) * (ScreenMaxX - ScreenMinX) / GraphsPerRow + ScreenMinX
	
	Graphtop = (GraphRow - 1) * (ScreenMaxY - ScreenMinY) / GraphsPerColumn + ScreenMinY
	Graphbottom = (GraphRow) * (ScreenMaxY - ScreenMinY) / GraphsPerColumn + ScreenMinY
	
	//Display the graph
	
	String GraphBaseName = InstrumentName + "_Graph"
	String CurrentGraphName = GraphBaseName + num2str(GraphNumber)
	DoWindow /F $CurrentGraphName
	If (V_flag == 0)
		String cmd
		If (CmpStr(GraphXAxisWaveName, "") == 0)
			sprintf cmd, "Display /W=(%g, %g, %g, %g)/N=%s %s", Graphleft, Graphtop, Graphright, Graphbottom, CurrentGraphName, GraphYAxisWaveName
		Else
			sprintf cmd, "Display /W=(%g, %g, %g, %g)/N=%s %s vs %s", Graphleft, Graphtop, Graphright, Graphbottom, CurrentGraphName, GraphYAxisWaveName, GraphXAxisWaveName
		Endif
		Execute /Q cmd
		Label left LeftLabel
		Label bottom BottomLabel
		PrintSettings /W=$CurrentGraphName orientation=1
	Else
		MoveWindow /W=$CurrentGraphName Graphleft, Graphtop, Graphright, Graphbottom
		PrintSettings /W=$CurrentGraphName orientation=1
	Endif
End
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function WindowData()
	GetWindow kwTopWin, activeSW//kwTopWin
	Printf "Window name: %s", S_value
	Printf "S_value = %s", S_value
	DoWindow $S_value
	Printf "flag = %g", V_flag
	GetWindow kwTopWin, wsize
	Printf "Located at (Left, top, right, bottom): %g, %g, %g, %g", V_left, V_top, V_right, V_bottom
	
End


//--------------------------------------------------Percent Diff Calc for FGGA-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------					
Macro GGA_TestResults()	
	Silent 1
	Variable nmpoints = numpnts(X_CO2__ppm)
	Variable incr = 10
	Variable MAX1= -1000
	Variable MIN1 = 1000
	Variable MIN2 = 1000
	Variable MAX2 = -1000
	Variable i = 0
	Variable/G percent_diff1
	Variable/G percent_diff2
	Variable mean1
	Variable mean2
	Variable xloca
	Variable xlocb
	Variable xlocc
	Variable xlocd
	Variable smoothpoints = 300
	make/O/N=(numpnts(TimeW)) ch4_noise, co2_noise, pres_noise, temp_noise, rd0_noise, rd1_noise, ch4_spec, co2_spec
	do
	ch4_spec[i] = 0.0007
	co2_spec[i] = 0.07
	i+=1
	while(i<numpnts(TimeW)+1)
	i = 0
//CH4	Sdev
	Duplicate/O X_CH4__ppm_sd,Smooth_ch4_sd;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_ch4_sd
	AppendToGraph/W=FGGA_Graph2 Smooth_ch4_sd vs TimeW
	ModifyGraph/W=FGGA_Graph2 rgb(Smooth_ch4_sd)=(0,0,0)
	AppendToGraph/W=FGGA_Graph2 ch4_spec vs TimeW
	ModifyGraph/W=FGGA_Graph2 lsize(ch4_spec)=2,rgb(ch4_spec)=(0,65280,65280)
//CH4	
	Duplicate/O X_CH4__ppm,Smooth_ch4;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_ch4
	AppendToGraph/W=FGGA_Graph1 Smooth_ch4 vs TimeW
	ModifyGraph/W=FGGA_Graph1 rgb(Smooth_ch4)=(0,0,0)
	WaveStats/Q Smooth_ch4
	Variable	ch4_ave = V_avg	
//CO2 Sdev
	Duplicate/O X_CO2__ppm_sd,Smooth_co2_sd;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_co2_sd
	AppendToGraph/W=FGGA_Graph4 Smooth_co2_sd vs TimeW
	ModifyGraph/W=FGGA_Graph4 rgb(Smooth_co2_sd)=(0,0,0)
	AppendToGraph/W=FGGA_Graph4 co2_spec vs TimeW
	ModifyGraph/W=FGGA_Graph4 lsize(co2_spec)=2,rgb(co2_spec)=(0,65280,65280)
//CO2
	Duplicate/O X_CO2__ppm,Smooth_co2;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_co2
	AppendToGraph/W=FGGA_Graph3 Smooth_co2 vs TimeW
	ModifyGraph/W=FGGA_Graph3 rgb(Smooth_co2)=(0,0,0)
	Wavestats/Q Smooth_co2
	Variable co2_ave = V_avg
//Pressure
	Duplicate/O GasP_torr,Smooth_pres;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_pres
	Wavestats/Q Smooth_pres
	Variable pres_ave = V_avg
//Temperature
	Duplicate/O GasT_C,Smooth_GasT_C;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_GasT_C
	Wavestats/Q Smooth_GasT_C
	Variable temp_ave = V_avg
//RD0	
	Duplicate/O RD0_us,Smooth_RD0_us;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_RD0_us
	Wavestats/Q Smooth_RD0_us
	Variable RD0_ave = V_avg
//RD1	
	Duplicate/O RD1_us,Smooth_RD1_us;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_RD1_us
	Wavestats Smooth_RD1_us
	Variable RD1_ave = V_avg

//Std Err or Std dev
	if(exists("X_CH4__ppm_se") == 1)
	Duplicate/O X_CH4__ppm_se,Smooth_ch4_se;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_ch4_se
	WaveStats/Q Smooth_ch4_se
	Variable ch4_num = ch4_ave/V_avg
	ch4_noise = Smooth_ch4/Smooth_ch4_se

	Duplicate/O X_CO2__ppm_se,Smooth_co2_se;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_co2_se
	Wavestats/Q Smooth_co2_se
	Variable co2_num = co2_ave/V_avg
	co2_noise = Smooth_co2/Smooth_co2_se

	Duplicate/O GasP_torr_se,Smooth_pres_se;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_pres_se
	Wavestats/Q Smooth_pres_se
	Variable pres_num = pres_ave/V_avg
	pres_noise = Smooth_pres/Smooth_pres_se

	Duplicate/O GasT_C_se,Smooth_GasT_C_se;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_GasT_C_se
	Wavestats Smooth_GasT_C_se
	Variable temp_num = temp_ave/V_avg
	temp_noise = Smooth_GasT_C/Smooth_GasT_C_se

	Duplicate/O RD0_us_se,Smooth_RD0_us_se;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_RD0_us_se
	Wavestats/Q Smooth_RD0_us_se
	Variable RD0_num = RD0_ave/V_avg
	rd0_noise = Smooth_RD0_us/Smooth_RD0_us_se

	Duplicate/O RD1_us_se,Smooth_RD1_us_se;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_RD1_us_se
	Wavestats/Q Smooth_RD1_us_se
	Variable RD1_num = RD1_ave/V_avg
	rd1_noise = Smooth_RD1_us/Smooth_RD1_us_se
	
	else
	
	Duplicate/O X_CH4__ppm_sd,Smooth_ch4_sd;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_ch4_sd
	WaveStats/Q Smooth_ch4_sd
	Variable ch4_num = ch4_ave/V_avg
	ch4_noise = Smooth_ch4/Smooth_ch4_sd
	
	Duplicate/O X_CO2__ppm_sd,Smooth_co2_sd;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_co2_sd
	Wavestats/Q Smooth_co2_sd
	Variable co2_num = co2_ave/V_avg
	co2_noise = Smooth_co2/Smooth_co2_sd
	
	Duplicate/O GasP_torr_sd,Smooth_pres_sd;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_pres_sd
	Wavestats/Q Smooth_pres_sd
	Variable pres_num = pres_ave/V_avg
	pres_noise = Smooth_pres/Smooth_pres_sd

	Duplicate/O GasT_C_sd,Smooth_GasT_C_sd;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_GasT_C_sd
	Wavestats Smooth_GasT_C_sd
	Variable temp_num = temp_ave/V_avg
	temp_noise = Smooth_GasT_C/Smooth_GasT_C_sd

	Duplicate/O RD0_us_sd,Smooth_RD0_us_sd;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_RD0_us_sd
	Wavestats/Q Smooth_RD0_us_sd
	Variable RD0_num = RD0_ave/V_avg
	rd0_noise = Smooth_RD0_us/Smooth_RD0_us_sd

	Duplicate/O RD1_us_sd,Smooth_RD1_us_sd;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_RD1_us_sd
	Wavestats/Q Smooth_RD1_us_sd
	Variable RD1_num = RD1_ave/V_avg
	rd1_noise = Smooth_RD1_us/Smooth_RD1_us_sd
	endif
	
	do
		if (Smooth_ch4[i] < MIN1 && GasT_C[i] > 5 && GasT_C[i] < 45)
			MIN1 = Smooth_ch4[i]
			xloca = i
		endif
		i = i+incr
	while (i < nmpoints)
	i=0
	do
		if (Smooth_ch4[i] > MAX1 && GasT_C[i] > 5 && GasT_C[i] < 45)
			MAX1 = Smooth_ch4[i]
			xlocb = i
		endif
		i = i+incr
	while (i < nmpoints)
	i=0
	do
		if (Smooth_co2[i] < MIN2 && GasT_C[i] > 5 && GasT_C[i] < 45)
			MIN2 = Smooth_co2[i]
			xlocc = i
		endif
		i = i+incr
	while (i < nmpoints)
	i=0
	do
		if (Smooth_co2[i] > MAX2 && GasT_C[i] > 5 && GasT_C[i] < 45)
			MAX2 = Smooth_co2[i]
			xlocd = i
		endif
		i = i+incr
	while (i < nmpoints)
		
	mean1 = (MAX1+MIN1)/2
	mean2 = (MAX2+MIN2)/2
	percent_diff1 = (((MAX1-MIN1)/mean1)*100)/2
	percent_diff2 = (((MAX2-MIN2)/mean2)*100)/2

	AppendtoGraph/W=FGGA_Graph1/R GasT_C vs TimeW
	ModifyGraph/W=FGGA_Graph1 rgb(GasT_C)=(0,0,0)
	AppendtoGraph/W=FGGA_Graph3/R GasT_C vs TimeW
	ModifyGraph/W=FGGA_Graph3 rgb(GasT_C)=(0,0,0)

	Tag/W=FGGA_Graph1 /C/N=texta, Smooth_ch4, xlocb,"CH4 Max"
	Tag/W=FGGA_Graph1 /C/N=textb Smooth_ch4, xloca,"CH4 Min"
	Tag/W=FGGA_Graph3 /C/N=textc Smooth_co2, xlocd,"CO2 Max"
	Tag/W=FGGA_Graph3 /C/N=textd Smooth_co2, xlocc,"CO2 Min"
	
	DisplayGraph(5, 9, "FGGA_Results", "ch4_noise", "TimeW", "Measured Values / Std Err", "Date and Time")
	AppendToGraph co2_noise,rd0_noise,rd1_noise, pres_noise vs TimeW
	AppendToGraph/R temp_noise vs TimeW
	Label right "Temp Noise"
	ModifyGraph rgb(co2_noise)=(0,15872,65280) // blue
	ModifyGraph rgb(pres_noise)=(0,65280,0) // green
	ModifyGraph rgb(temp_noise)=(0,0,0) // black
	ModifyGraph mode=0,rgb(rd0_noise)=(65280,0,52224) // purple
	ModifyGraph rgb(rd1_noise)=(2816,62464,61184) // light blue
	ModifyGraph nticks(left)=10
	Variable location = (numpnts(TimeW))-200
      Tag/W=FGGA_Results_Graph5/N=results /L=0/I=0 /A=RT pres_noise, location, "CH4 %Diff: \{percent_diff1}\rCO2 %Diff: \{percent_diff2}"

	Legend/C/N=noise/J "\\Z08\\s(ch4_noise) ch4_noise\r\\s(co2_noise) co2_noise\r\\s(pres_noise) pres_noise\r\\s(temp_noise) temp_noise\r\\s(rd0_noise) rd0_noise\r\\s(rd1_noise) rd1_noise\r\\s"
	Legend/C/N=noise/A=MC
	Legend/C/N=noise/J/X=-60.16/Y=-56.40

	print "-------------------------------------------------FGGA RESULTS----------------------------------------------------------------"
	print "CH4 MAX: ", MAX1
	print "CH4 MIN: ", MIN1
	print "CH4 Percent Difference: ", percent_diff1
	print "CO2 MAX: ", MAX2
	print "CO2 MIN: ", MIN2
	print "CO2 Percent Difference: ", percent_diff2
	Print "Ch4 Noise: ", ch4_num
	Print "CO2 Noise: ", co2_num
	Print "Pressure Noise: ", pres_num
	Print "Temp Noise: ", temp_num
	Print "RD0 Noise: ", RD0_num
	Print "RD1 Noise: ", RD1_num
	print "------------------------------------------------------------------------------------------------------------------------------------------"
End
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Macro Percent_Diff_N2O()
	Variable points = numpnts(X_N2O__ppm)
	Variable increment = points*.01
	Variable n2omax= -100
	Variable n2omin = 100
	Variable comax = -100
	Variable comin = 100
	Variable q = 0
	Variable n2operdiff
	Variable coperdiff
	Variable n2omean
	Variable comean
	Variable xloc1
	Variable xloc2
	Variable xloc3
	Variable xloc4
	do
		if (X_N2O__ppm[q] < n2omin)
			n2omin = X_N2O__ppm[q]
			xloc1 = q
		endif
		if (X_N2O__ppm[q] > n2omax)
			n2omax = X_N2O__ppm[q]
			xloc2 = q
		endif
		if (X_CO__ppm[q] < comin)
			comin = X_CO__ppm[q]
			xloc3 = q
		endif
		if (X_CO__ppm[q] > comax)
			comax = X_CO__ppm[q]
			xloc4 = q
		endif
		q = q+increment
	while(q < points)

	n2omean = (n2omax+n2omin)/2
	comean = (comax+comin)/2
	n2operdiff = (((n2omax-n2omin)/n2omean)*100)/2
	coperdiff = (((comax-comin)/comean)*100)/2
		
	Tag/W=N2O_Graph1 /C/N=text0, X_N2O__ppm, xloc2,"N2O Max"
	Tag/W=N2O_Graph1 /C/N=text1 X_N2O__ppm, xloc1,"N2O Min"
	Tag/W=N2O_Graph2 /C/N=text2 X_CO__ppm, xloc4,"CO Max"
	Tag/W=N2O_Graph2 /C/N=text3 X_CO__ppm, xloc3,"CO Min"
	
	Print "---------------------------------------------------------------------------------------------------"
	Print "N2O Max: ", n2omax
	Print "N2O Min: ", n2omin
	Print "CO Max: ", comax
	Print "CO Min: ", comin
	Print "---------------------------------------------------------------------------------------------------"
	Print "Percent Difference of N2O and CO:"
	Print "N2O: ", n2operdiff
	Print "CO: ", coperdiff
	Print "---------------------------------------------------------------------------------------------------"
End	
	
//------------------------------------------------------------------------------------------------Conversion to laser temperature--------------------------------------------------------------------------------------------------------------------	
Macro CalcTemps()
	Duplicate /O AIN6 lasertemp
	Duplicate /O AIN5 supertemp
	lasertemp=1.1479e-3+2.3429e-4*(ln (ain6*1e4))+8.7298e-08*(ln(ain6*1e4))^3
	supertemp=1.1479e-3+2.3429e-4*(ln (ain5*1e4))+8.7298e-08*(ln(ain5*1e4))^3
	lasertemp=1/lasertemp
	supertemp=1/supertemp
	lasertemp=lasertemp-273.15
	supertemp=supertemp-273.15
	Display lasertemp vs TimeW	
	AppendToGraph/R supertemp vs TimeW
	ModifyGraph rgb(supertemp)=(0,15872,65280)
	ModifyGraph axRGB(right)=(0,15872,65280),tlblRGB(right)=(0,15872,65280)
	ModifyGraph alblRGB(right)=(0,15872,65280)
	ModifyGraph lstyle(lasertemp)=8
	ReorderTraces lasertemp,{supertemp}
	ModifyGraph lsize(supertemp)=5
End

//----------------------------------------------------------------------------------------------Precision Section for Overnight N2O Runs---------------------------------------------------------------------------------------------------

Function sav()
	Save/T X_CO__ppm, X_N2O__ppm as "X_CO__ppm++.itx"
	Edit
End

Function renam()
	Rename Tau, Tau_co; Rename ADEV, ADEV_co; Rename ADEV_Min, ADEV_Min_co; Rename ADEV_Max, ADEV_Max_co
End

Function doit()
	Display ADEV_co, ADEV vs Tau
	ModifyGraph log=1
	ModifyGraph mode=4, marker(ADEV_co)=16, marker(ADEV)=19; DelayUpdate
	ModifyGraph rgb(ADEV) = (24576, 24576, 65280)
	ModifyGraph grid(left)=1
	ModifyGraph grid=1
	Label left "PPB"; DelayUpdate
	Label bottom "Seconds"
End

Function SaveJPEG()

	SavePICT/E=-6/B=288
	
End
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

