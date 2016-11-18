#pragma rtGlobals=1		// Use modern global access method.

Macro Set_Parameters(float)
	String float
	Prompt float, "Select analyzer and parameter being floated", popup, "N2O Baseline;FGGA Baseline;TIWA Baseline;HF HCL Baseline;FGGA Pressure CH4;FGGA Pressure CO2;FGGA Pressure H2O;FMA Baseline;FMA Pressure CH4;FMA Pressure H2O;"
		
	if(CmpStr(float, "FGGA Pressure CH4") == 0)
	CH4_Pressure()
	endif		
	if(CmpStr(float, "FGGA Pressure CO2") == 0)
	CO2_Pressure()
	endif	
	if(CmpStr(float, "FGGA Pressure H2O") == 0)
	H2O_Pressure()	
	endif			
	if(CmpStr(float, "FMA Pressure CH4") == 0)
	CH4_Pressure2()
	endif
	if(CmpStr(float, "FMA Pressure H2O") == 0)
	H2O_Pressure2()
	endif
	if(CmpStr(float, "FGGA Baseline") == 0)
	Set_GGA_Baseline()
	endif
	if(CmpStr(float, "FMA Baseline") == 0)
	Fma_Baseline()
	endif
	if(CmpStr(float, "N2O Baseline") == 0)
	N2O_Baseline()
	endif
	if(CmpStr(float, "TIWA Baseline") == 0)
	TIWA_Baseline()
	endif
	if(CmpStr(float, "HF HCL Baseline") == 0)
	HF_HCL_Baseline()
	endif
	
	
	
	
end
//------------------------------------------------------------------------------FGGA Pressure---------------------------------------------------------------------------

Function CH4_Pressure()
	Variable TWEAKS_ColumnLabelLine = 1
	Variable TWEAKS_FirstDataLine = 2
	
	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)
	
	If (exists("X12CH4_4_PT") == 1) //new code
	Display /I/W=(0,3.5,6,7) X12CH4_4_PT
	print "CH4 Pressure Width Coefficient: " , mean(X12CH4_4_PT, numpnts(X12CH4_4_PT), numpnts(X12CH4_4_PT)-20)
	endif
	If (exists("CH4_4_PT_A") == 1) //old code
	Display /I/W=(0,3.5,6,7) CH4_4_PT_A
	print "CH4 Pressure Width Coefficient: " , mean(CH4_4_PT_A, numpnts(CH4_4_PT_A), numpnts(CH4_4_PT_A)-20)
	endif

End

Function CO2_Pressure()

	Variable TWEAKS_ColumnLabelLine = 1
	Variable TWEAKS_FirstDataLine = 2

	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)
	
	If (exists("CO2_0_PT_B") == 1) //old code
	Display /I/W=(12,3.5,18,7) CO2_0_PT_B
	print "CO2 Pressure Width Coefficient: " , mean(CO2_0_PT_B, numpnts(CO2_0_PT_B), numpnts(CO2_0_PT_B)-20)
	endif
	If (exists("X12CO2_0_PT_B") == 1) //new code
	Display /I/W=(12,3.5,18,7) X12CO2_0_PT_B
	print "CO2 Pressure Width Coefficient: " , mean(X12CO2_0_PT_B, numpnts(X12CO2_0_PT_B), numpnts(X12CO2_0_PT_B)-20)
	endif
	
End

Function H2O_Pressure()

	Variable TWEAKS_ColumnLabelLine = 1
	Variable TWEAKS_FirstDataLine = 2

	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)
	
	if(exists("H2O_12_PT_A")==1)//old code
	Display /I/W=(6,3.5,12,7) H2O_12_PT_A
	print "H2O Pressure Width Coefficient: " , mean(H2O_12_PT_A, numpnts(H2O_12_PT_A), numpnts(H2O_12_PT_A)-20)	
	endif
	if(exists("H2O_12_PT")==1)//new code
	Display /I/W=(6,3.5,12,7) H2O_12_PT
	print "H2O Pressure Width Coefficient: " , mean(H2O_12_PT, numpnts(H2O_12_PT), numpnts(H2O_12_PT)-20)	
	endif

End
//--------------------------------------------FMA Pressure-------------------------------------------------------------------------------------------------

Function CH4_Pressure2()

	Variable TWEAKS_ColumnLabelLine = 1
	Variable TWEAKS_FirstDataLine = 2

	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)
	
	Display /I/W=(0,3.5,6,7) CH4_4_PT
	
	print "CH4 Pressure Width Coefficient: " , mean(CH4_4_PT, numpnts(CH4_4_PT), numpnts(CH4_4_PT)-20)	
End

Function H2O_Pressure2()

	Variable TWEAKS_ColumnLabelLine = 1
	Variable TWEAKS_FirstDataLine = 2

	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)
	
	Display /I/W=(6,3.5,12,7) H2O_12_PT
		
	print "H2O Pressure Width Coefficient: " , mean(H2O_12_PT, numpnts(H2O_12_PT), numpnts(H2O_12_PT)-20)	

End
		
//--------------------------------------------BASELINES-----------------------------------------------------------------------------------------------------		
	
Function Set_GGA_Baseline()

	Variable TWEAKS_ColumnLabelLine = 1
	Variable TWEAKS_FirstDataLine = 2

	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)

	if(exists("BL0T_A")==1)
	DisplayGraph(1,6,"FGGA", "BL0T_A", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(2,6,"FGGA", "BL1T_A", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(3,6,"FGGA", "BL2T_A", "TimeW", "Baseline 2", "Date & Time")
	DisplayGraph(4,6,"FGGA", "BL0T_B", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(5,6,"FGGA", "BL1T_B", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(6,6,"FGGA", "BL2T_B", "TimeW", "Baseline 2", "Date & Time")

	Print "---------------------------------CH4 Baseline Results-------------------------------------------"
	Print "Baseline BL0T: ", mean(BL0T_A, numpnts(BL0T_A), numpnts(BL0T_A)-20)
	Print "Baseline BL1T: ", mean(BL1T_A, numpnts(BL1T_A), numpnts(BL1T_A)-20)
	Print "Baseline BL2T: ", mean(BL2T_A, numpnts(BL2T_A), numpnts(BL2T_A)-20)


	Print "---------------------------------CO2 Baseline Results-------------------------------------------"	
	Print "Baseline BL0T: ", mean(BL0T_B, numpnts(BL0T_B), numpnts(BL0T_B)-20)
	Print "Baseline BL1T: ", mean(BL1T_B, numpnts(BL1T_B), numpnts(BL1T_B)-20)
	Print "Baseline BL2T: ", mean(BL2T_B, numpnts(BL2T_B), numpnts(BL2T_B)-20)
	Print "-------------------------------------------------------------------------------------------------------------"
	endif

	if(exists("BL0T")==1)
	DisplayGraph(1,6,"FGGA", "BL0T", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(2,6,"FGGA", "BL1T", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(3,6,"FGGA", "BL2T", "TimeW", "Baseline 2", "Date & Time")
	DisplayGraph(4,6,"FGGA", "BL0T_B", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(5,6,"FGGA", "BL1T_B", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(6,6,"FGGA", "BL2T_B", "TimeW", "Baseline 2", "Date & Time")

	Print "---------------------------------CH4 Baseline Results-------------------------------------------"
	Print "Baseline BL0T: ", mean(BL0T, numpnts(BL0T), numpnts(BL0T)-20)
	Print "Baseline BL1T: ", mean(BL1T, numpnts(BL1T), numpnts(BL1T)-20)
	Print "Baseline BL2T: ", mean(BL2T, numpnts(BL2T), numpnts(BL2T)-20)


	Print "---------------------------------CO2 Baseline Results-------------------------------------------"	
	Print "Baseline BL0T: ", mean(BL0T_B, numpnts(BL0T_B), numpnts(BL0T_B)-20)
	Print "Baseline BL1T: ", mean(BL1T_B, numpnts(BL1T_B), numpnts(BL1T_B)-20)
	Print "Baseline BL2T: ", mean(BL2T_B, numpnts(BL2T_B), numpnts(BL2T_B)-20)
	Print "-------------------------------------------------------------------------------------------------------------"
	endif

End

Function FMA_Baseline()

	Variable TWEAKS_ColumnLabelLine = 1
	Variable TWEAKS_FirstDataLine = 2

	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)
	
	DisplayGraph(1,3,"FMA", "BL0T", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(2,3,"FMA", "BL1T", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(3,3,"FMA", "BL2T", "TimeW", "Baseline 2", "Date & Time")
	
	Print "---------------------------------CH4 Baseline Results-------------------------------------------"
	Print "Baseline BL0T: ", mean(BL0T, numpnts(BL0T), numpnts(BL0T)-20)
	Print "Baseline BL1T: ", mean(BL1T, numpnts(BL1T), numpnts(BL1T)-20)
	Print "Baseline BL2T: ", mean(BL2T, numpnts(BL2T), numpnts(BL2T)-20)
	
End
	
//---------------------------------------------------------------------------------------HF-HCL--------------------------------------------------------------------------------------------------------------------------------------------------	
Function HF_HCL_Baseline()

	Variable TWEAKS_ColumnLabelLine = 1
	Variable TWEAKS_FirstDataLine = 2

	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)

	
	if(exists("BL2T_A") == 1)
	DisplayGraph(1,6,"HF_HCL", "BL0T_A", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(2,6,"HF_HCL", "BL1T_A", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(3,6,"HF_HCL", "BL2T_A", "TimeW", "Baseline 2", "Date & Time")
	DisplayGraph(4,6,"HF_HCL", "BL0T_B", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(5,6,"HF_HCL", "BL1T_B", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(6,6,"HF_HCL", "BL2T_B", "TimeW", "Baseline 2", "Date & Time")

	Print "---------------------------------HF 1st Baseline Results-------------------------------------------"
	Print "Baseline BL0T: ", mean(BL0T_A, numpnts(BL0T_A), numpnts(BL0T_A)-20)
	Print "Baseline BL1T: ", mean(BL1T_A, numpnts(BL1T_A), numpnts(BL1T_A)-20)
	Print "Baseline BL2T: ", mean(BL2T_A, numpnts(BL2T_A), numpnts(BL2T_A)-20)


	Print "---------------------------------HCL 1st Baseline Results-------------------------------------------"	
	Print "Baseline BL0T: ", mean(BL0T_B, numpnts(BL0T_B), numpnts(BL0T_B)-20)
	Print "Baseline BL1T: ", mean(BL1T_B, numpnts(BL1T_B), numpnts(BL1T_B)-20)
	Print "Baseline BL2T: ", mean(BL2T_B, numpnts(BL2T_B), numpnts(BL2T_B)-20)
	Print "-------------------------------------------------------------------------------------------------------------"
	endif

	if(exists("BL2T2_A") == 1)
	DisplayGraph(1,6,"HF_HCL", "BL0T2_A", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(2,6,"HF_HCL", "BL1T2_A", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(3,6,"HF_HCL", "BL2T2_A", "TimeW", "Baseline 2", "Date & Time")
	DisplayGraph(4,6,"HF_HCL", "BL0T2_B", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(5,6,"HF_HCL", "BL1T2_B", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(6,6,"HF_HCL", "BL2T2_B", "TimeW", "Baseline 2", "Date & Time")

	Print "---------------------------------HF 2nd Baseline Results-------------------------------------------"
	Print "Baseline BL0T2: ", mean(BL0T2_A, numpnts(BL0T2_A), numpnts(BL0T2_A)-20)
	Print "Baseline BL1T2: ", mean(BL1T2_A, numpnts(BL1T2_A), numpnts(BL1T2_A)-20)
	Print "Baseline BL2T2: ", mean(BL2T2_A, numpnts(BL2T2_A), numpnts(BL2T2_A)-20)


	Print "---------------------------------HCL 2nd Baseline Results-------------------------------------------"	
	Print "Baseline BL0T2: ", mean(BL0T2_B, numpnts(BL0T2_B), numpnts(BL0T2_B)-20)
	Print "Baseline BL1T2: ", mean(BL1T2_B, numpnts(BL1T2_B), numpnts(BL1T2_B)-20)
	Print "Baseline BL2T2: ", mean(BL2T2_B, numpnts(BL2T2_B), numpnts(BL2T2_B)-20)
	Print "-------------------------------------------------------------------------------------------------------------"
	endif

END
	
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	
	
Function N2O_Baseline()

	Variable TWEAKS_ColumnLabelLine = 1
	Variable TWEAKS_FirstDataLine = 2

	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)
	
	Display /I/W=(0,3.5,6,7) BL0T
	
	Display /I/W=(6,3.5,12,7) BL1T
	
	Display /I/W=(12,3.5,18,7) BL2T
	
	print "Average Baseline Coefficients, last 20 points:"
	print "-------------------------------------------------------------------"
	
	print "BLOT Average: " , mean(BL0T, numpnts(BL0T), numpnts(BL0T)-20)
	
	print "BL1T Average: " , mean(BL1T, numpnts(BL1T), numpnts(BL1T)-20)

	print "BL2T Average: " , mean(BL2T, numpnts(BL2T), numpnts(BL2T)-20)

End

Function TIWA_Baseline()

	Variable TWEAKS_ColumnLabelLine = 1
	Variable TWEAKS_FirstDataLine = 2

	LoadWave/J/Q/D/E=1/W/O/K=0/V={"\t,"," $",0,1}/L={TWEAKS_ColumnLabelLine,TWEAKS_FirstDataLine,0,0,0}
	Make/O/T/N=(V_flag) ImportedWaveNames= StringFromList(p,S_waveNames)

	DisplayGraph(1,6,"TIWA", "BL0T", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(2,6,"TIWA", "BL1T", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(3,6,"TIWA", "BL2T", "TimeW", "Baseline 2", "Date & Time")
	DisplayGraph(4,6,"TIWA", "BL0T_B", "TimeW", "Baseline 0", "Date & Time")
	DisplayGraph(5,6,"TIWA", "BL1T_B", "TimeW", "Baseline 1", "Date & Time")
	DisplayGraph(6,6,"TIWA", "BL2T_B", "TimeW", "Baseline 2", "Date & Time")

	Print "---------------------------------Laser 1 Baseline Results-------------------------------------------"
	Print "Baseline BL0T: ", mean(BL0T)
	Print "Baseline BL1T: ", mean(BL1T)
	Print "Baseline BL2T: ", mean(BL2T)

	Print "---------------------------------Laser 2 Baseline Results-------------------------------------------"	
	Print "Baseline BL0T: ", mean(BL0T_B)
	Print "Baseline BL1T: ", mean(BL1T_B)
	Print "Baseline BL2T: ", mean(BL2T_B)
	Print "-------------------------------------------------------------------------------------------------------------"

End