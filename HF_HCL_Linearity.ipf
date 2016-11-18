#pragma rtGlobals=1		// Use modern global access method.
Macro HF_HCL_Linearity(ave_time,steps,offset)
	Variable ave_time = 30
	Variable steps = 6 // Number of Dilution Levels	
	Variable offset = 200	
	Variable i = ave_time
	Variable j = 0
	Variable start = 1
	Variable endp = 100
	Variable loopcount = 0
	Variable bool = 0


	
	If (exists("X_HF__ppm") != 1)
		LoadAndClipPoints(1,2,0)
	endif
	Silent 1
	Variable pt_limit = numpnts(TimeW)	
	Make/N=(steps)/O average_vals_hf, data_stdev_hf, average_vals_hcl, data_stdev_hcl, Level, actual_hf, actual_hcl, Stept

	do	
		do
			EdgeStats/R=(start, endp)/P X_HF__ppm      
			Print "Edge Amp:", V_EdgeAmp4_0
			if(V_Flag == 0 && abs(V_EdgeAmp4_0) > 0.001)
				start = endp+offset
				endp+= 30+offset
				bool = 1 // correct edge
				Print "Edge Correct"
				Print "Start", start, "End:", endp
			else
				start = endp-25
				endp+= 30
				bool = 0 // not an ege
				Print "Keep Looking"
				Print "Start", start, "End:", endp
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
		Print "Level:",j
		Stept[j] = V_EdgeLoc1
		j+=1
		endif
	while(j < steps-1)
	j = 0	
	
	do
		WaveStats/Q/R=[Stept[j]-5,Stept[j]-5-ave_time] X_HF__ppm
		average_vals_hf[j] = V_avg
		data_stdev_hf[j] = V_sdev
		WaveStats/Q/R=[Stept[j]-5,Stept[j]-5-ave_time] X_HCL__ppm
		average_vals_hcl[j] = V_avg
		data_stdev_hcl[j] = V_sdev	
		Level[j] = j
		j+=1		
	while(j<steps-1)

	actual_hf[0] = 44.06
	actual_hf[1] = 35.248
	actual_hf[2] = 29.3733
	actual_hf[3] = 25.1771
	actual_hf[4] = 22.03
	actual_hf[5] = 44.06
	
	actual_hcl[0] = 43.6
	actual_hcl[1] = 34.88
	actual_hcl[2] = 29.0667
	actual_hcl[3] = 24.9142
	actual_hcl[4] = 21.8			
	actual_hcl[5] = 43.6					
	

	Edit/N=Table_Averages average_vals_hf, data_stdev_hf, average_vals_hcl, data_stdev_hcl, Level, actual_hf, actual_hcl, Stept
	
	DisplayGraph(1, 9, "HF", "X_HF__ppm", "TimeW", "HF (ppb)", "Time / Date")
	
	DisplayGraph(2, 9, "HCl", "X_HCL__ppm", "TimeW", "HCl (ppb)", "Time / Date")
	DisplayGraph(3, 9, "HF_ave", "average_vals_hf", "Level", "HF (ppb)", "Time / Date")		
	ModifyGraph mode=3,marker=8;DelayUpdate
	ErrorBars average_vals_hf Y,wave=(data_stdev_hf,data_stdev_hf)
	DisplayGraph(4, 9, "HCL_ave", "average_vals_hcl", "Level", "HCl (ppb)", "Time / Date")		
	ModifyGraph mode=3,marker=8;DelayUpdate
	ErrorBars average_vals_hcl Y,wave=(data_stdev_hcl,data_stdev_hcl)
	DisplayGraph(5, 9, "HF_ave", "average_vals_hf", "actual_hf", "HF (ppb)", "Time / Date")	
	ModifyGraph mode=3,marker=8;DelayUpdate
	ErrorBars average_vals_hf Y,wave=(data_stdev_hf,data_stdev_hf)
	DisplayGraph(6, 9, "HCL_ave", "average_vals_hcl", "actual_hcl", "HCl (ppb)", "Time / Date")		
	ModifyGraph mode=3,marker=8;DelayUpdate
	ErrorBars average_vals_hcl Y,wave=(data_stdev_hcl,data_stdev_hcl)
	
	Tag/W=HF_Graph1 /C/N=texta/X=0/Y=15.00 X_HF__ppm, Stept[0]-5-ave_time,"A"
	Tag/W=HF_Graph1 /C/N=textb/X=0/Y=15.00 X_HF__ppm, Stept[0]-5,"B"

	Tag/W=HF_Graph1 /C/N=textc/X=0/Y=15.00 X_HF__ppm, Stept[1]-5-ave_time,"A"
	Tag/W=HF_Graph1 /C/N=textd/X=0/Y=15.00 X_HF__ppm, Stept[1]-5,"B"

	Tag/W=HF_Graph1 /C/N=texte/X=0/Y=15.00 X_HF__ppm, Stept[2]-5-ave_time,"A"
	Tag/W=HF_Graph1 /C/N=textf/X=0/Y=15.00 X_HF__ppm, Stept[2]-5,"B"

	Tag/W=HF_Graph1 /C/N=textg/X=0/Y=15.00 X_HF__ppm, Stept[3]-5-ave_time,"A"
	Tag/W=HF_Graph1 /C/N=texth/X=0/Y=15.00 X_HF__ppm, Stept[3]-5,"B"

	Tag/W=HF_Graph1 /C/N=texti/X=0/Y=15.00 X_HF__ppm, Stept[4]-5-ave_time,"A"
	Tag/W=HF_Graph1 /C/N=textj/X=0/Y=15.00 X_HF__ppm, Stept[4]-5,"B"
		
//	Tag/W=HF_Graph1 /C/N=textk/X=0/Y=15.00 X_HF__ppm, Stept[5]-5-ave_time,"A"
//	Tag/W=HF_Graph1 /C/N=textl/X=0/Y=15.00 X_HF__ppm, Stept[5]-5,"B"
	
End