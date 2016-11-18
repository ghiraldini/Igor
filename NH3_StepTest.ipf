#pragma rtGlobals=1		// Use modern global access method.
Macro NH3_steps(steps, ave_time,backoff)
	Variable steps = 5
	Variable ave_time = 30
	Variable backoff = 25
	Variable i = ave_time
	Variable j = 0
	Variable start = 1
	Variable endp = 50
	Variable loopcount = 0
	Variable bool = 0
	Variable offset = 100
	Variable pt_limit = numpnts(TimeW)

	Silent 1
	Make/N=(steps)/O Stept, Level, average_vals, sdev, ave_vals_h2o
	Duplicate/O X_NH3_b_ppm NH3_dry
	NH3_dry = X_NH3_b_ppm/(1-(X_H2O_a_ppm)/10^6)
	do	
		do
			EdgeStats/Q/R=(start, endp)/P X_H2O_a_ppm      
			if(V_Flag == 0 && abs(V_EdgeAmp4_0) > 500)
				start = endp+offset
				endp+= 30+offset
				bool = 1 // correct edge
			else
				start = endp-25
				endp+= 30
				bool = 0 // not an ege
			endif
			if(endp >= pt_limit)
				bool = 1
				break
			endif
			if (bool == 1)
				break
			endif			
		while(bool == 0)	
		if(endp >= pt_limit)
			Stept[j] = pt_limit
			break
		else
		Stept[j] = V_EdgeLoc1-backoff
		j+=1
		endif
	while(j < steps)
	j = 0	
	
	do
		WaveStats/Q/R=[Stept[j],Stept[j]-ave_time] NH3_dry
		average_vals[j] = V_avg
		sdev[j] = V_sdev	
		WaveStats/Q/R=[Stept[j],Stept[j]-ave_time] X_H2O_a_ppm
		ave_vals_h2o[j] = V_avg
		Level[j] = j
		j+=1		
	while(j<steps)

// Make Table
	Edit/N=Table_Averages Stept, Level, average_vals, sdev, ave_vals_h2o
	
	DisplayGraph(1, 9, "H2O", "X_H2O_a_ppm", "TimeW", "H2O", "Time / Date")
	AppendToGraph/R X_NH3_b_ppm vs TimeW
	AppendToGraph/R NH3_dry vs TimeW
	ModifyGraph rgb(X_NH3_b_ppm)=(24576,24576,65280)
	ModifyGraph rgb(NH3_dry)=(0,0,0)
	Legend/C/N=text0/A=MC
	
	Tag/W=H2O_Graph1 /C/N=texta/X=0/Y=15.00 X_H2O_a_ppm, Stept[0],"B"
	Tag/W=H2O_Graph1 /C/N=textb/X=0/Y=15.00 X_H2O_a_ppm, Stept[0]-ave_time,"A"
	
	Tag/W=H2O_Graph1 /C/N=textc/X=0/Y=15.00 X_H2O_a_ppm, Stept[1],"B"
	Tag/W=H2O_Graph1 /C/N=textd/X=0/Y=15.00 X_H2O_a_ppm, Stept[1]-ave_time,"A"

	Tag/W=H2O_Graph1 /C/N=texte/X=0/Y=15.00 X_H2O_a_ppm, Stept[2],"B"
	Tag/W=H2O_Graph1 /C/N=textf/X=0/Y=15.00 X_H2O_a_ppm, Stept[2]-ave_time,"A"	
	
	Tag/W=H2O_Graph1 /C/N=textg/X=0/Y=15.00 X_H2O_a_ppm, Stept[3],"B"
	Tag/W=H2O_Graph1 /C/N=texth/X=0/Y=15.00 X_H2O_a_ppm, Stept[3]-ave_time,"A"
	
	Tag/W=H2O_Graph1 /C/N=texti/X=0/Y=15.00 X_H2O_a_ppm, Stept[4],"B"
	Tag/W=H2O_Graph1 /C/N=textj/X=0/Y=15.00 X_H2O_a_ppm, Stept[4]-ave_time,"A"

	DisplayGraph(2,9,"NH3", "average_vals", "Level", "NH3", "Ave Points")
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10
	ErrorBars average_vals Y,wave=(sdev,sdev)

	DisplayGraph(3,9,"NH3", "average_vals", "ave_vals_h2o", "NH3", "H2O")
	ModifyGraph mode=3,marker=8, grid(left)=1,nticks(left)=10
	
End