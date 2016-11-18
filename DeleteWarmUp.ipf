#pragma rtGlobals=1		// Use modern global access method.

Macro DeleteWarmUp(percent)
	Variable pnts
	Variable total = numpnts(TimeW)
	String percent
	Prompt percent, "Select percentage of warm up data to delete: ", popup "1%;2%;5%;10%;25%;50%"
	Variable i = 0
	Variable numCols = numpnts(ImportedWaveNames)
	Print "Number of Columns: ", numCols

	if(CmpStr(percent, "1%")==0)
		pnts = total*.01
	endif
	if(CmpStr(percent, "2%")==0)
		pnts = total*.02
	endif
	if(CmpStr(percent, "5%")==0)
		pnts = total*.05
	endif
	if(CmpStr(percent, "10%")==0)
		pnts = total*.1
	endif
	if(CmpStr(percent, "25%")==0)
		pnts = total*.25
	endif
	if(CmpStr(percent, "50%")==0)
		pnts = total*.5
	endif

	String cmd
	do 
		sprintf cmd, "DeletePoints %g, %g, %s" 0, pnts, ImportedWaveNames[i]
		Execute cmd
		i+=1
	while(i < numCols)

End