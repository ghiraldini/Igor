#pragma rtGlobals=1		// Use modern global access method.

Macro WVIA_H2O_Linearity(steps, ave_time, backoff)
	Variable steps = 5
	Variable ave_time = 30
	Variable backoff = 25
	
	Variable startpt = 50
	Variable endpt = 100
	
	Variable offset = 100
	Variable bool = 0
	Variable i,j = 0
	
	
	if(exists("TimeW") == 0)
		LoadAndClipPoints(1,2,0)
	endif
	Variable maxpoints = numpnts(TimeW)	
	Silent 1
	make/N=(steps)/O level_pt, level, ave_vals_h2o, sdev, actual_h2o, percentDiff, upper_limit, low_limit
	do	
		do
			EdgeStats/Q/R=(startpt, endpt)/P H2O_ppm      
			if(V_Flag == 0 && abs(V_EdgeAmp4_0) > 250)
				startpt = endpt+offset
				endpt+= 30+offset
				bool = 1 // correct edge
			else
				startpt = endpt-25
				endpt+= 30
				bool = 0 // not an ege
			endif
			if(endpt >= maxpoints)
				bool = 1
				break
			endif
			if (bool == 1)
				break
			endif			
		while(bool == 0)	
		if(endpt >= maxpoints)
			level_pt[j] = maxpoints
			break
		else
		level_pt[j] = V_EdgeLoc1-backoff
		j+=1
		endif
	while(j < steps)
	j = 0	
	
	do
		WaveStats/Q/R=[level_pt[j],level_pt[j]-ave_time] H2O_ppm
		ave_vals_h2o[j] = V_avg
		sdev[j] = V_sdev
		level[j] = j
		j+=1		
	while(j<steps)

	actual_h2o[0] = 6600
	actual_h2o[1] = 10060
	actual_h2o[2] = 15030
	actual_h2o[3] = 20720
	actual_h2o[4] = 25400
	
	upper_limit = 1
	low_limit = -1
	i=0
	do
	percentDiff[i] = ((ave_vals_h2o[i]-actual_h2o[i])/actual_h2o[i])*100
	i+=1
	while(i<steps)
	edit level_pt, level, ave_vals_h2o, sdev, actual_h2o, percentDiff
	
	DisplayGraph(1, 9, "H2O", "H2O_ppm", "TimeW", "H2O", "Time / Date")
	
	Tag/W=H2O_Graph1 /C/N=texta/X=0/Y=15.00 H2O_ppm, level_pt[0],"B"
	Tag/W=H2O_Graph1 /C/N=textb/X=0/Y=15.00 H2O_ppm, level_pt[0]-ave_time,"A"
	
	Tag/W=H2O_Graph1 /C/N=textc/X=0/Y=15.00 H2O_ppm, level_pt[1],"B"
	Tag/W=H2O_Graph1 /C/N=textd/X=0/Y=15.00 H2O_ppm, level_pt[1]-ave_time,"A"

	Tag/W=H2O_Graph1 /C/N=texte/X=0/Y=15.00 H2O_ppm, level_pt[2],"B"
	Tag/W=H2O_Graph1 /C/N=textf/X=0/Y=15.00 H2O_ppm, level_pt[2]-ave_time,"A"	
	
	Tag/W=H2O_Graph1 /C/N=textg/X=0/Y=15.00 H2O_ppm, level_pt[3],"B"
	Tag/W=H2O_Graph1 /C/N=texth/X=0/Y=15.00 H2O_ppm, level_pt[3]-ave_time,"A"
	
	Tag/W=H2O_Graph1 /C/N=texti/X=0/Y=15.00 H2O_ppm, level_pt[4],"B"
	Tag/W=H2O_Graph1 /C/N=textj/X=0/Y=15.00 H2O_ppm, level_pt[4]-ave_time,"A"

	DisplayGraph(2,9,"H2O", "ave_vals_h2o", "actual_h2o", "Measured H2O", "Actual H2O")
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10
	ErrorBars ave_vals_h2o Y,wave=(sdev,sdev)
	CurveFit/M=2/W=0 line, ave_vals_h2o/X=actual_h2o/D
	ModifyGraph rgb(fit_ave_vals_h2o)=(0,0,0)
	Tag /L=0/N=textk/I=0/X=1/Y=10 ave_vals_h2o 2,"Y-Intercept: \{ W_coef[0]} trSlope \{W_coef[1]} "
	
	DisplayGraph(3,9,"H2O", "percentDIff", "level", "H2O", "Ave Points")
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10
	AppendtoGraph upper_limit
	AppendtoGraph low_limit
	ModifyGraph mode(upper_limit)=0,mode(low_limit)=0

END



Macro WVIA_Accuracy_Test(steps, ave_time, backoff)
	Variable steps = 5
	Variable ave_time = 30
	Variable backoff = 75
	
	Variable startpt = 50
	Variable endpt = 100
	
	Variable offset = 100
	Variable bool = 0
	Variable i,j = 0
	
	
	if(exists("TimeW") == 0)
		LoadAndClipPoints(1,2,0)
	endif
	Variable maxpoints = numpnts(TimeW)	
	Silent 1
	make/N=(steps)/O level_pt, level, ave_vals_D, sdev_D, ave_vals_17, sdev_17, ave_vals_18, sdev_18, actual_D, actual_17, actual_18, dD, d17, d18, upper_limit, low_limit
	do	
		do
			EdgeStats/Q/R=(startpt, endpt)/P D_Del     
			if(V_Flag == 0 && abs(V_EdgeAmp4_0) > 25)
				startpt = endpt+offset
				endpt+= 30+offset
				bool = 1 // correct edge
			else
				startpt = endpt-25
				endpt+= 30
				bool = 0 // not an ege
			endif
			if(endpt >= maxpoints)
				bool = 1
				break
			endif
			if (bool == 1)
				break
			endif			
		while(bool == 0)	
		if(endpt >= maxpoints)
			level_pt[j] = maxpoints
			break
		else
		level_pt[j] = V_EdgeLoc1-backoff
		j+=1
		endif
	while(j < steps)
	j = 0	
	
	do
		WaveStats/Q/R=[level_pt[j],level_pt[j]-ave_time] D_del
		ave_vals_D[j] = V_avg
		sdev_D[j] = V_sdev
		WaveStats/Q/R=[level_pt[j],level_pt[j]-ave_time] O17_del
		ave_vals_17[j] = V_avg
		sdev_17[j] = V_sdev
		WaveStats/Q/R=[level_pt[j],level_pt[j]-ave_time] O18_del
		ave_vals_18[j] = V_avg
		sdev_18[j] = V_sdev
		level[j] = j
		j+=1		
	while(j<steps)

	actual_D[0] = 	-40.43		// Cal Bottle
	actual_D[1] = 	-154.0		// 1C
	actual_D[2] = 	-97.3		// 3C
	actual_D[3] = 	-51.6		// 4C
	actual_D[4] = 	-40.43		// Cal Bottle
	
	actual_17[0] = 	-3.44		// Cal Bottle
	actual_17[1] = 	-10.30		// 1C
	actual_17[2] = 	-8.56		// 3C
	actual_17[3] = 	-4.17		// 4C
	actual_17[4] = 	-3.44		// Cal Bottle

	actual_18[0] = 	-6.58		// Cal Bottle
	actual_18[1] = 	-19.49		// 1C
	actual_18[2] = 	-13.39		// 3C
	actual_18[3] = 	-7.94		// 4C
	actual_18[4] = 	-6.58		// Cal Bottle

	upper_limit = 1
	low_limit = -1
	i=0
	do
	dD[i] = (ave_vals_D[i]-actual_D[i])
	d17[i] = (ave_vals_17[i]-actual_17[i])
	d18[i] = (ave_vals_18[i]-actual_18[i])
	i+=1
	while(i<steps)
	edit  level_pt, level, ave_vals_D, sdev_D, ave_vals_17, sdev_17, ave_vals_18, sdev_18, actual_D, actual_17, actual_18, dD, d17, d18, upper_limit, low_limit
	DisplayGraph(2, 9, "H2O", "D_del", "TimeW", "D_Del", "Time / Date")
		
	Tag/W=H2O_Graph2 /C/N=texta/X=0/Y=15.00 H2O_ppm, level_pt[0],"B"
	Tag/W=H2O_Graph2 /C/N=textb/X=0/Y=15.00 H2O_ppm, level_pt[0]-ave_time,"A"
	
	Tag/W=H2O_Graph2 /C/N=textc/X=0/Y=15.00 D_Del, level_pt[1],"B"
	Tag/W=H2O_Graph2 /C/N=textd/X=0/Y=15.00 D_Del, level_pt[1]-ave_time,"A"

	Tag/W=H2O_Graph2 /C/N=texte/X=0/Y=15.00 D_Del, level_pt[2],"B"
	Tag/W=H2O_Graph2 /C/N=textf/X=0/Y=15.00 D_Del, level_pt[2]-ave_time,"A"	
	
	Tag/W=H2O_Graph2 /C/N=textg/X=0/Y=15.00 D_Del, level_pt[3],"B"
	Tag/W=H2O_Graph2 /C/N=texth/X=0/Y=15.00 D_Del, level_pt[3]-ave_time,"A"
	
	Tag/W=H2O_Graph2 /C/N=texti/X=0/Y=15.00 D_Del, level_pt[4],"B"
	Tag/W=H2O_Graph2 /C/N=textj/X=0/Y=15.00 D_Del, level_pt[4]-ave_time,"A"
	
	Tag/W=H2O_Graph2 /C/N=texty/X=0/Y=15.00 D_Del, level_pt[5],"B"
	Tag/W=H2O_Graph2 /C/N=textz/X=0/Y=15.00 D_Del, level_pt[5]-ave_time,"A"

	Print "----------------------------------------------------------------------------------"
	Print "				Curve Fit Results						"
	Print "----------------------------------------------------------------------------------"
	DisplayGraph(4,9,"H2O", "ave_vals_D", "actual_D", "Measured H2O", "Actual H2O")
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10
	ErrorBars ave_vals_D Y,wave=(sdev_D,sdev_D)
	CurveFit/Q/M=2/W=0 line, ave_vals_D/X=actual_D/D
	ModifyGraph rgb(fit_ave_vals_D)=(0,0,0)
	Print "Y Intercept D:	", W_coef[0], "  Slope: ", W_coef[1]
	
	DisplayGraph(5,9,"H2O", "ave_vals_17", "actual_17", "Measured H2O", "Actual H2O")
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10
	ErrorBars ave_vals_17 Y,wave=(sdev_17,sdev_17)
	CurveFit/Q/M=2/W=0 line, ave_vals_17/X=actual_17/D
	ModifyGraph rgb(fit_ave_vals_17)=(0,0,0)
	Print "Y Intercept O17:	", W_coef[0], "Slope: ", W_coef[1]
	
	DisplayGraph(6,9,"H2O", "ave_vals_18", "actual_18", "Measured H2O", "Actual H2O")
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10
	ErrorBars ave_vals_18 Y,wave=(sdev_18,sdev_18)
	CurveFit/Q/M=2/W=0 line, ave_vals_18/X=actual_18/D
	ModifyGraph rgb(fit_ave_vals_18)=(0,0,0)
	Print "Y Intercept O18:	", W_coef[0], "Slope: ", W_coef[1]	
	
	DisplayGraph(8,9,"H2O", "dD", "level", "H2O", "Ave Points")
	AppendtoGraph upper_limit vs level
	AppendtoGraph low_limit vs level
	AppendtoGraph d17 vs level
	AppendtoGraph d18 vs level
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10, mode(upper_limit)=0,mode(low_limit)=0, marker(d17)=5,rgb(d17)=(0,43520,65280), marker(d18)=6,rgb(d18)=(32768,65280,0)
	Legend/C/N=text0/J/A=MC "\\s(dD) dD\r\\s(d17) d17\r\\s(d18) d18\r\\s(upper_limit) upper_limit"
	SetAxis left -1.5000,1.5000

END

Macro WVIA_Iso_Linearity(steps, ave_time, backoff, verify)
	Variable steps = 13
	Prompt steps, "Number of H2O steps in test"
	Variable ave_time = 30
	Prompt ave_time, "Number of seconds to average"
	Variable backoff = 50
	Prompt backoff, "Number of points to back off from edge"
	Variable verify = 0
	Prompt verify, "If Linearity Verification: verify = 1, regular plot (verify = 0)"
	
	Variable startpt = 10
	Variable endpt = 50
	
	Variable offset = 250
	Variable bool = 0
	Variable i,j = 0
	
	
	if(exists("TimeW") == 0)
		LoadAndClipPoints(1,2,0)
	endif
	Variable maxpoints = numpnts(TimeW)	
	Silent 1
	Variable numCols = numpnts(ImportedWaveNames)
	Silent 1
	String cmd
	do 
		sprintf cmd, "DeletePoints %g, %g, %s" 0, 300, ImportedWaveNames[i]
		Execute cmd
		i+=1
	while(i < numCols)
	i=0
	if(maxpoints > 6200)	
		do 
			sprintf cmd, "DeletePoints %g, %g, %s" 6300, maxpoints, ImportedWaveNames[i]
			Execute cmd
			i+=1
		while(i < numCols)
	endif
	i=0
	maxpoints = numpnts(TimeW)	
	make/N=(steps)/O level_pt, level, ave_vals_D, sdev_D, ave_vals_17, sdev_17, ave_vals_18, sdev_18, actual_D_low, actual_D_high, actual_17_low, actual_17_high, actual_18_low, actual_18_high
	do	
		do
			EdgeStats/Q/R=(startpt, endpt)/P H2O_ppm     
			if(V_Flag == 0 && abs(V_EdgeAmp4_0) > 600)
				startpt = endpt+offset
				endpt+= 50+offset
				bool = 1 // correct edge
			else
				startpt = endpt-30
				endpt+= 20
				bool = 0 // not an ege
			endif
			if (bool == 1)
				level_pt[j] = V_EdgeLoc1-backoff				
				break
			endif		
			if(endpt > maxpoints)
				level_pt[j] = maxpoints
				j = steps
				bool = 1
				break	
			endif
		while(bool == 0)	
		
		WaveStats/Q/R=[level_pt[j],level_pt[j]-ave_time] D_del
		ave_vals_D[j] = V_avg
		sdev_D[j] = V_sdev
		WaveStats/Q/R=[level_pt[j],level_pt[j]-ave_time] O17_del
		ave_vals_17[j] = V_avg
		sdev_17[j] = V_sdev
		WaveStats/Q/R=[level_pt[j],level_pt[j]-ave_time] O18_del
		ave_vals_18[j] = V_avg
		sdev_18[j] = V_sdev
		
		level[j] = j
		j+=1
	while(j<steps)
	actual_D_low = -40.43-1
	actual_D_high = -40.43+1
	actual_17_low = -3.44-1
	actual_17_high = -3.44+1
	actual_18_low = -6.58-1
	actual_18_high = -6.58+1
	edit level_pt, level, ave_vals_D, sdev_D, ave_vals_17, sdev_17, ave_vals_18, sdev_18, actual_D_low, actual_D_high, actual_17_low, actual_17_high, actual_18_low, actual_18_high
	
	DisplayGraph(2, 9, "H2O", "H2O_ppm", "TimeW", "H2O", "Time / Date")
	
	Tag/W=H2O_Graph2 /C/N=texta/X=0/Y=15.00 H2O_ppm, level_pt[0],"B"
	Tag/W=H2O_Graph2 /C/N=textb/X=0/Y=15.00 H2O_ppm, level_pt[0]-ave_time,"A"
	
	Tag/W=H2O_Graph2 /C/N=textc/X=0/Y=15.00 H2O_ppm, level_pt[1],"B"
	Tag/W=H2O_Graph2 /C/N=textd/X=0/Y=15.00 H2O_ppm, level_pt[1]-ave_time,"A"

	Tag/W=H2O_Graph2 /C/N=texte/X=0/Y=15.00 H2O_ppm, level_pt[2],"B"
	Tag/W=H2O_Graph2 /C/N=textf/X=0/Y=15.00 H2O_ppm, level_pt[2]-ave_time,"A"	
	
	Tag/W=H2O_Graph2 /C/N=textg/X=0/Y=15.00 H2O_ppm, level_pt[3],"B"
	Tag/W=H2O_Graph2 /C/N=texth/X=0/Y=15.00 H2O_ppm, level_pt[3]-ave_time,"A"
	
	Tag/W=H2O_Graph2 /C/N=texti/X=0/Y=15.00 H2O_ppm, level_pt[4],"B"
	Tag/W=H2O_Graph2 /C/N=textj/X=0/Y=15.00 H2O_ppm, level_pt[4]-ave_time,"A"
	
	Tag/W=H2O_Graph2 /C/N=textk/X=0/Y=15.00 H2O_ppm, level_pt[5],"B"
	Tag/W=H2O_Graph2 /C/N=textl/X=0/Y=15.00 H2O_ppm, level_pt[5]-ave_time,"A"
	
	Tag/W=H2O_Graph2 /C/N=textm/X=0/Y=15.00 H2O_ppm, level_pt[6],"B"
	Tag/W=H2O_Graph2 /C/N=textn/X=0/Y=15.00 H2O_ppm, level_pt[6]-ave_time,"A"
	
	Tag/W=H2O_Graph2 /C/N=texto/X=0/Y=15.00 H2O_ppm, level_pt[7],"B"
	Tag/W=H2O_Graph2 /C/N=textp/X=0/Y=15.00 H2O_ppm, level_pt[7]-ave_time,"A"

	Tag/W=H2O_Graph2 /C/N=textq/X=0/Y=15.00 H2O_ppm, level_pt[8],"B"
	Tag/W=H2O_Graph2 /C/N=textr/X=0/Y=15.00 H2O_ppm, level_pt[8]-ave_time,"A"	
	
	Tag/W=H2O_Graph2 /C/N=texts/X=0/Y=15.00 H2O_ppm, level_pt[9],"B"
	Tag/W=H2O_Graph2 /C/N=textt/X=0/Y=15.00 H2O_ppm, level_pt[9]-ave_time,"A"
	
	Tag/W=H2O_Graph2 /C/N=textu/X=0/Y=15.00 H2O_ppm, level_pt[10],"B"
	Tag/W=H2O_Graph2 /C/N=textv/X=0/Y=15.00 H2O_ppm, level_pt[10]-ave_time,"A"
	
	Tag/W=H2O_Graph2 /C/N=textw/X=0/Y=15.00 H2O_ppm, level_pt[11],"B"
	Tag/W=H2O_Graph2 /C/N=textx/X=0/Y=15.00 H2O_ppm, level_pt[11]-ave_time,"A"

	Tag/W=H2O_Graph2 /C/N=texty/X=0/Y=15.00 H2O_ppm, level_pt[12],"B"
	Tag/W=H2O_Graph2 /C/N=textz/X=0/Y=15.00 H2O_ppm, level_pt[12]-ave_time,"A"
	
	DisplayGraph(4, 9, "H2O", "ave_vals_D", "level", "D_del", "H2O Level")
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10, rgb=(0,0,0)
	ErrorBars ave_vals_D Y,wave=(sdev_D,sdev_D)
	if(verify == 1)
	AppendtoGraph actual_D_high vs level
	AppendtoGraph actual_D_low vs level
	ModifyGraph lsize(actual_D_high)=2,lsize(actual_D_low)=2
	SetAxis left -43,-38
	endif
	DisplayGraph(5, 9, "H2O", "ave_vals_17", "level", "O17_del", "H2O Level")
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10, rgb = (0,0,0)
	ErrorBars ave_vals_17 Y,wave=(sdev_17,sdev_17)
	if(verify == 1)	
	AppendtoGraph actual_17_high vs level
	AppendtoGraph actual_17_low vs level
	ModifyGraph lsize(actual_17_high)=2,lsize(actual_17_low)=2
	SetAxis left -5,-2
	endif
	DisplayGraph(6, 9, "H2O", "ave_vals_18", "level", "O18_del", "H2O Level")
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10, rgb = (0,0,0)
	ErrorBars ave_vals_18 Y,wave=(sdev_18,sdev_18)
	if(verify == 1)	
	AppendtoGraph actual_18_high vs level
	AppendtoGraph actual_18_low vs level
	ModifyGraph lsize(actual_18_high)=2,lsize(actual_18_low)=2
	SetAxis left -8,-5
	endif
END