#pragma rtGlobals=1		// Use modern global access method.

Macro WaterBroadening(type)
	String type
	Prompt type, "Please select instrument type", popup "N2O;FGGA"
	Variable startpoint = 0
	Variable ep = 0
	Variable i = 0
	Variable h2omax =0
	Variable h2ostart = 0
	Variable numCols
	Variable endData
	Silent 1
	
	If (CmpStr(type, "N2O") == 0)
	
		LoadAndClipPoints(1,2,0)
		numCols = numpnts(ImportedWaveNames)
		endData = numpnts(TimeW)
		
			i=0
		do
			if (X_H2O__ppm[i] > 5000)
				h2ostart = X_H2O__ppm[i]
				startpoint = i
				break
			endif
			i+=1
		while(X_H2O__ppm[i] < 6000)

		i=0		
		do
			if (X_H2O__ppm[i] > h2omax)
				h2omax = X_H2O__ppm[i]
				ep = i
			endif
			i+=1
		while(i < endData)

		String cmd
		i=0
		ep = ep-165
		do // delete beginning
			sprintf cmd, "DeletePoints %g, %g, %s" 0, startpoint, ImportedWaveNames[i-1]
			Execute cmd
			i+=1
		while(i < numCols)

		i=0
		do // delete end
			sprintf cmd, "DeletePoints %g, %g, %s" ep, endData, ImportedWaveNames[i-1]
			Execute cmd
			i+=1
		while(i < numCols)
			
			
		if(exists("X_CO__ppm_sd") == 1)

		DisplayGraph(4, 9, type, "X_CO_d_ppm", "X_H2O__ppm", "CO Dry ppm", "H2O ppm")
			ModifyGraph mode=3,marker=8
		DisplayGraph(5, 9, type, "X_N2O_d_ppm", "X_H2O__ppm", "N2O Dry ppm", "H2O ppm")
			ModifyGraph mode=3,marker=8
		DisplayGraph(6, 9, type, "X_H2O__ppm", "TimeW", "H2O ppm", "Time and Date")

		else
			
		DisplayGraph(4, 9, type, "X_CO_dry__ppm", "X_H2O__ppm", "CO Dry ppm", "H2O ppm")
		
		DisplayGraph(5, 9, type, "X_N2O_dry__ppm", "X_H2O__ppm", "N2O Dry ppm", "H2O ppm")
		
		DisplayGraph(6, 9, type, "X_H2O__ppm", "TimeW", "H2O ppm", "Time and Date")
		
		
		endif
	endif

	If (CmpStr(type, "FGGA") == 0)
		startpoint = 0
		ep = 0
		
		LoadAndClipPoints(1,2,0)
		numCols = numpnts(ImportedWaveNames)
		endData = numpnts(TimeW)

		i=0
		do
			if (X_H2O__ppm[i] > 5000 && X_H2O__ppm[i] < 6000)
				h2ostart = X_H2O__ppm[i]
				startpoint = i
				break
			endif
			i+=1
		while(X_H2O__ppm[i] < 8000)

		i=0		
		do
			if (X_H2O__ppm[i] > h2omax)
				h2omax = X_H2O__ppm[i]
				ep = i
			endif
			i+=1
		while(i < endData)

		ep = ep-165

		if (startpoint == 0)
			startpoint +=1
		endif

		String cmd
		i=0

		do // delete beginning
			sprintf cmd, "DeletePoints %g, %g, %s" 0, startpoint, ImportedWaveNames[i-1]
			Execute cmd
			i+=1
		while(i < numCols)

		i=0
		do // delete end
			sprintf cmd, "DeletePoints %g, %g, %s" ep, endData, ImportedWaveNames[i-1]
			Execute cmd
			i+=1
		while(i < numCols)

		if(exists("X_CH4_d_ppm")==1)
		DisplayGraph(4, 9, type, "X_CH4_d_ppm", "X_H2O__ppm", "CH4 Dry ppm", "H2O ppm")
		
		DisplayGraph(5, 9, type, "X_CO2_d_ppm", "X_H2O__ppm", "CO2 Dry ppm", "H2O ppm")
		
		DisplayGraph(6, 9, type, "X_H2O__ppm", "TimeW", "H2O ppm", "Time and Date")
		else
		
		DisplayGraph(4, 9, type, "X_CH4_DRY__ppm", "X_H2O__ppm", "CH4 Dry ppm", "H2O ppm")
		
		DisplayGraph(5, 9, type, "X_CO2_DRY__ppm", "X_H2O__ppm", "CO2 Dry ppm", "H2O ppm")
		
		DisplayGraph(6, 9, type, "X_H2O__ppm", "TimeW", "H2O ppm", "Time and Date")
		endif
		
	endif
	
	
End

