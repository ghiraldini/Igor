#pragma rtGlobals=1		// Use modern global access method.

Macro Get_Data(numDays,tweak1,tweak2)
	String numDays
	Prompt numDays, "Select Number of days to collect: ", popup "2;3;4;5"
	Variable tweak1 = 1
	Variable tweak2 = 2
	
	if(CmpStr(numDays, "2") == 0)
	LoadAndClipPoints(tweak1,tweak2,0)
	second(tweak1, tweak2)
	endif
	
	if(CmpStr(numDays, "3") == 0)
	LoadAndClipPoints(tweak1, tweak2,0)
	second(tweak1, tweak2)
	third(tweak1, tweak2)
	endif

	if(CmpStr(numDays, "4") == 0)
	LoadAndClipPoints(tweak1, tweak2,0)
	second(tweak1, tweak2)
	third(tweak1, tweak2)
	fourth(tweak1, tweak2)
	endif

	if(CmpStr(numDays, "5") == 0)
	LoadAndClipPoints(tweak1, tweak2,0)
	second(tweak1, tweak2)
	third(tweak1, tweak2)
	fourth(tweak1, tweak2)
	fifth(tweak1, tweak2)
	endif

End

Function second(tweak1, tweak2)
	Variable tweak1
	Variable tweak2
	LoadWave /A=SECOND/N/O/J/Q/D/E=1/K=0/V={"\t,"," $",0,1}/L={tweak1, tweak2,0,0,0}
End

Function third(tweak1, tweak2)
	Variable tweak1
	Variable tweak2
	LoadWave /A=THIRD/N/O/J/Q/D/E=1/K=0/V={"\t,"," $",0,1}/L={tweak1, tweak2,0,0,0}
End

Function fourth(tweak1, tweak2)
	Variable tweak1
	Variable tweak2
	LoadWave /A=FOURTH/N/O/J/Q/D/E=1/K=0/V={"\t,"," $",0,1}/L={tweak1, tweak2,0,0,0}
End

Function fifth(tweak1, tweak2)
	Variable tweak1
	Variable tweak2
	LoadWave /A=FIFTH/N/O/J/Q/D/E=1/K=0/V={"\t,"," $",0,1}/L={tweak1, tweak2,0,0,0}
End