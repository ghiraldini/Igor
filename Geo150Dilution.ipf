#pragma rtGlobals=1		// Use modern global access method.

// Data Types: X_12CH4__ppm, X_13CH4__ppm, X_CH4__ppm, X_NH3__ppm, delta, RD0_us

Macro Geo150Dilution()
	Silent 1
	Variable MIN1 = 1000 // make user defineable
	Variable MAX1 = -1000
	Variable i=0
	Variable xlocMax = 0
	Variable xlocMin = 0
	Variable numCols = 0
	String cmd
	
	If (exists("X_CH4__ppm") != 1)//Test to see if the data file has already been loaded
		LoadAndClipPoints(1,2)
		numCols = numpnts(ImportedWaveNames)
	Endif

	do
		if (X_CH4__ppm[i] > MAX1)
			MAX1 = X_CH4__ppm[i]
			xlocMax = i
		endif
		i+=1
	while (i < numpnts(TimeW))
	i = 0
	do
		if (X_CH4__ppm[i] < MIN1 && i > xlocMax)
			MIN1 = X_CH4__ppm[i]
			xlocMin = i
		endif
		i+=1
	while (i < numpnts(TimeW))
	
		Print "Max: ", MAX1
		Print "xlocationMax: ", xlocMax
		Print "Min: ", MIN1
		Print "xlocationMin: ", xlocMin
	i=0
	do // delete beginning
		sprintf cmd, "DeletePoints %g, %g, %s" 0, xlocMax, ImportedWaveNames[i-1]
		Execute cmd
		i+=1
	while(i < numCols)
	i=0
	do // delete end
		sprintf cmd, "DeletePoints %g, %g, %s" xlocMin, numpnts(TimeW), ImportedWaveNames[i-1]
		Execute cmd
		i+=1
	while(i < numCols)
	GetAverage(20)
	DisplayGraph(1, 9, "GEO", "RD0_us", "X_CH4__ppm", "Tau (us)", "CH4 ppm")
	DisplayGraph(4, 9, "GEO", "delta", "X_CH4__ppm", "Delta", "CH4 ppm")	
	DisplayGraph(2, 9, "GEO", "X_CH4__ppm", "TimeW", "CH4 ppm", "Time/Date")	
	

END

Function GetAverage(ave_time)
	Variable ave_time
	Variable i = ave_time
	Silent 1
	If (exists("delta") == 0)
		LoadAndClipPoints(1,2,0)
	endif
	Make/N=(numpnts(TimeW)/ave_time-1)/O average_vals, data_stdev, x_axis_points
	do
		average_vals[i/ave_time] = mean(delta, i-ave_time, i)
		WaveStats/Q/R=(i-ave_time, i) delta
		data_stdev[i/ave_time] = V_sdev
		x_axis_points[i/ave_time] = i
		i+=ave_time
	while(i < numpnts(TimeW))
	Edit/N=Table_Averages average_vals, data_stdev
	DeletePoints 0,1, average_vals,data_stdev
	DisplayGraph(5, 9, "Ave", "average_vals", "x_axis_points", "Averages", "points")
	ModifyGraph mode=2,lsize=5;DelayUpdate
	ModifyGraph rgb=(0,0,0)
	ErrorBars average_vals Y,wave=(data_stdev,data_stdev)		
	SetAxis/A/R bottom
End

Macro C2effect()
	Variable ave_time = 180
	Variable i = ave_time
	Variable start = 1
	Variable endp = 300
	Variable Lev1
	Variable Lev2
	Variable Lev3
	
	do
	EdgeStats/Q/R=(start,endp)/P delta 
	endp = endp + 20
	while(V_Flag != 0)
		Lev1 = V_EdgeLoc1
		start = Lev1 + 5
		endp = start+500
	do
	EdgeStats/Q/R=(start,endp)/P delta 
	endp = endp + 20
	while(V_Flag != 0)
		Lev2 = V_EdgeLoc1
		start = Lev2 + 5
		endp = start+500
	do
	EdgeStats/Q/R=(start,endp)/P delta 
	endp = endp + 20
	while(V_Flag != 0)
		Lev3 = V_EdgeLoc1

//	Print "--------------------------------------------------------------------"
//	Print "Edge Location 1: ", Lev1
//	Print "Edge Location 2: ", Lev2
//	Print "Edge Location 3: ", Lev3
		
	Make/N=(5)/O C2nums, average_vals, data_stdev
	average_vals[0] = 0
	data_stdev[0] = 0
	WaveStats/Q/R=[10,Lev1-10] delta
	average_vals[1] = V_avg
	data_stdev[1] = V_sdev	
	WaveStats/Q/R=[Lev1+25,Lev2-10] delta
	average_vals[2] = V_avg
	data_stdev[2] = V_sdev	
	WaveStats/Q/R=[Lev2+25,Lev3-10] delta
	average_vals[3] = V_avg
	data_stdev[3] = V_sdev
	WaveStats/Q/R=[Lev3+25,(numpnts(delta)-10)] delta
	average_vals[4] = V_avg	
	data_stdev[4] = V_sdev
	
	Edit/N=Table_Averages C2nums, average_vals, data_stdev

	C2nums[0] = 0
	C2nums[1] = 0
	C2nums[2] = .1532
	C2nums[3] = .305
	C2nums[4] = 0
	DeletePoints 0,1, C2nums, average_vals,data_stdev
	DisplayGraph(1, 9, "OneHzData", "delta", "TimeW", "Delta", "Time and Date")
	DisplayGraph(2, 9, "Ave", "average_vals", "C2nums", "Delta13C", "[C2H6]/[CH4]")
	ModifyGraph mode=2,lsize=5;DelayUpdate
	ModifyGraph rgb=(0,0,0)
	ErrorBars average_vals Y,wave=(data_stdev,data_stdev)	
	CurveFit/Q/M=2/W=0 line, average_vals /X=C2nums /D
      Tag/W=Ave_Graph2 /L=0/I=0 /X=50/Y=75 average_vals, 50, "Slope    =   \{W_coef[1]} \rIntercept =  \{W_coef[0]} "
	ModifyGraph mode(fit_average_vals)=0,lsize(fit_average_vals)=1
	ModifyGraph rgb(fit_average_vals)=(65280,0,0)
	ModifyGraph grid=1,sep(left)=10
End