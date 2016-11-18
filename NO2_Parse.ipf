#pragma rtGlobals=1		// Use modern global access method.

Macro NO2_Sample(ave_time, sample_valve, scrubbed_valve) 
	Variable ave_time = 30
	Variable sample_valve = 1
	Variable scrubbed_valve = 0
	Variable scan_increment = 50
		Silent 1
		If (exists("Tau__s_") == 0)
			LoadAndClipPoints(2,3,0)
		endif
			//--------------------------------get average value and std dev of last X seconds of sample-----------------------------------------------//		
			Variable i,k = 0
			Make/O/N=2000 NO2_num_sample, NO2_sdev_sample, NO2_slope_sample, Tau_num_sample, Tau_sdev_sample,Tau_slope_sample, x_axis_points, Time_minutes
			do	//------------------------------------------------------------------------------------------------main loop to ave till no more data-------------------------------//
				do	//------------------------------------------------scan in large increments till over shoot----//
					i+=scan_increment
					if(i >= numpnts(Tau__s_))
						break
					endif	
					if (Valve_Number[i] != sample_valve)
						i = i-scan_increment
						break
					endif
				while(Valve_Number[i] == sample_valve)	//----------scan till valve changes--------------------//
				do	//--------------------------------------------------------back off and scan every pt--------------//
					if(i >= numpnts(Tau__s_))
						break
					endif	
					i+=1
				while(Valve_Number[i] == sample_valve)	//----------scan till valve changes--------------------//
				if(i > numpnts(Tau__s_))
					i = numpnts(Tau__s_)
					break
				endif
				//--------------------------------------Put average values of Xseconds in Table--------------------------------------//
				//-----------------------NO2 Sample--------------------------------------------------------------------------------------------//
				if (Valve_Number[i-1] == sample_valve)
					Tau_num_sample[k] = mean(Tau__s_, i-ave_time-1, i-1) 
					WaveStats/Q/R=(i-1-ave_time, i-1) Tau__s_
					Tau_sdev_sample[k] = V_sdev
					CurveFit/Q/M=2/W=0 line, Tau__s_[i-ave_time,i]/X=Measurement_Time_Stamp[i-ave_time,i]/D
					Tau_slope_sample[k] = W_coef[1]
					
					//---------------Tau Sample Average----------------------------------------------------------------------------------------//
					NO2_num_sample[k] = mean(Concentration__ppb_, i-ave_time-1, i-1)
					WaveStats/Q/R=(i-1-ave_time, i-1) Concentration__ppb_
					NO2_sdev_sample[k] = V_sdev
					CurveFit/Q/M=2/W=0 line, Concentration__ppb_[i-ave_time, i]/X=Measurement_Time_Stamp[i-ave_time,i]/D
					NO2_slope_sample[k] = W_coef[1]

					x_axis_points[k] = k
					k+=1 
				endif
			while(i<numpnts(Tau__s_))	//---------------------------------------------------------------------------main loop kill----------------------------------//			
			
			//---------------------------------------------------------------------FIND SCRUBBED AIR------------------------------------------------------------------------------------//
			i = 200
			k = 0
			Make/O/N=2000 NO2_num_zero, NO2_sdev_zero, NO2_slope_zero, Tau_num_zero, Tau_sdev_zero,Tau_slope_zero, x_axis_points, Time_minutes_zero
			do	//------------------------------------------------------------------------------------------------main loop to ave till no more data-------------------------------//
				do	//------------------------------------------------scan in large increments till over shoot----//
					i+=scan_increment
					if(i >= numpnts(Tau__s_))
						break
					endif	
					if (Valve_Number[i] != scrubbed_valve)
						i = i-scan_increment
						break
					endif
				while(Valve_Number[i] == scrubbed_valve)	//----------scan till valve changes--------------------//
				do	//--------------------------------------------------------back off and scan every pt--------------//
					if(i >= numpnts(Tau__s_))
						break
					endif	
					i+=1
				while(Valve_Number[i] == scrubbed_valve)	//----------scan till valve changes--------------------//
				if(i > numpnts(Tau__s_))
					i = numpnts(Tau__s_)
					break
				endif
				//--------------------------------------Put average values of Xseconds in Table--------------------------------------//
				//-----------------------NO2 zero--------------------------------------------------------------------------------------------//
				if (Valve_Number[i-1] == scrubbed_valve)
					Tau_num_zero[k] = mean(Tau__s_, i-ave_time-1, i-1) 
					WaveStats/Q/R=(i-1-ave_time, i-1) Tau__s_
					Tau_sdev_zero[k] = V_sdev
					CurveFit/Q/M=2/W=0 line, Tau__s_[i-ave_time,i]/X=Measurement_Time_Stamp[i-ave_time,i]/D
					Tau_slope_zero[k] = W_coef[1]
					
					//---------------Tau zero Average----------------------------------------------------------------------------------------//
					NO2_num_zero[k] = mean(Concentration__ppb_, i-ave_time-1, i-1)
					WaveStats/Q/R=(i-1-ave_time, i-1) Concentration__ppb_
					NO2_sdev_zero[k] = V_sdev
					CurveFit/Q/M=2/W=0 line, Concentration__ppb_[i-ave_time, i]/X=Measurement_Time_Stamp[i-ave_time,i]/D
					NO2_slope_zero[k] = W_coef[1]

					x_axis_points[k] = k
					k+=1 
				endif
			while(i<numpnts(Tau__s_))	//---------------------------------------------------------------------------main loop kill----------------------------------//
			
			Edit NO2_num_sample, NO2_sdev_sample, NO2_slope_sample, Tau_num_sample, Tau_sdev_sample,Tau_slope_sample, x_axis_points, Time_minutes
			DeletePoints k, 2000,  NO2_num_sample, NO2_sdev_sample, NO2_slope_sample, Tau_num_sample, Tau_sdev_sample, Tau_slope_sample, x_axis_points, Time_minutes
			
			WaveStats/Q Relative_Time__s_
			Variable maxTime = V_max
			Variable minTime = V_min
			Variable/G TimeDiff = (maxTime-minTime)/60
			Variable multiplier = TimeDiff/(numpnts(x_axis_points))
			Time_minutes = x_axis_points*multiplier
			Time_minutes_zero = Time_minutes
			Print "Time Elapsed: ", (maxTime-minTime)/60, "minutes"
			
			DisplayGraph(1, 12, "NO2_ave_", "NO2_num_sample", "Time_minutes", "NO2 sample", "Minutes")
			Label left "NO\\B2\\M sample (ppb)"
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars NO2_num_sample Y,wave=(NO2_sdev_sample,NO2_sdev_sample)		

			DisplayGraph(2,12,"NO2_ave_", "NO2_slope_sample", "Time_minutes", "Slope of Sample", "Minutes")
			Label left "NO\\B2\\M slope of sample (ppb)"
			ModifyGraph mode=3,marker=8

			DisplayGraph(3, 12, "NO2_ave_", "Tau_num_sample", "Time_minutes", "Tau during sample", "Minutes")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars Tau_num_sample Y,wave=(Tau_sdev_sample,Tau_sdev_sample)		

			DisplayGraph(4,12,"NO2_ave_", "Tau_slope_sample", "Time_minutes", "Slope of Tau", "Minutes")
			ModifyGraph mode=3,marker=8
			
			
			Edit NO2_num_zero, NO2_sdev_zero, NO2_slope_zero, Tau_num_zero, Tau_sdev_zero,Tau_slope_zero, x_axis_points, Time_minutes_zero
			DeletePoints k, 2000,  NO2_num_zero, NO2_sdev_zero, NO2_slope_zero, Tau_num_zero, Tau_sdev_zero, Tau_slope_zero, x_axis_points, Time_minutes_zero
			
			DisplayGraph(5, 12, "NO2_ave_", "NO2_num_zero", "Time_minutes_zero", "NO2 zero", "Minutes")
			Label left "NO\\B2\\M zero (ppb)"
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars NO2_num_zero Y,wave=(NO2_sdev_zero,NO2_sdev_zero)		

			DisplayGraph(6,12,"NO2_ave_", "NO2_slope_zero", "Time_minutes_zero", "Slope of zero", "points")
			Label left "NO\\B2\\M slope of zero (ppb)"
			ModifyGraph mode=3,marker=8

			DisplayGraph(7, 12, "NO2_ave_", "Tau_num_zero", "Time_minutes_zero", "Tau during zero", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars Tau_num_zero Y,wave=(Tau_sdev_zero,Tau_sdev_zero)		

			DisplayGraph(8,12,"NO2_ave_", "Tau_slope_zero", "Time_minutes_zero", "Slope of Tau", "points")
			ModifyGraph mode=3,marker=8
			
END
