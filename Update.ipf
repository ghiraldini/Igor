#pragma rtGlobals=1		// Use modern global access method.

Macro AddMoreData()
	UpDate()
End
 

Function UpDate()

	SVAR fullpath = root:gfullpath

	Print "Fullpath taken from Load and Clip points function: ", fullpath

	LoadWave/J/D/W/O/K=0/L={1,2,0,0,0} fullpath

End


//root:tmpLoadAndClipPointsDF:tmpLoadAndClipPointsDF:gfullpath