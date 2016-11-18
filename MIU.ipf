#pragma rtGlobals=1		// Use modern global access method.

Macro MIU_Data(ave_time, valve_1_plot, valve_2_plot) // - added another valve but have not added the functionality to make another table!! - 03-01-2013
	Variable ave_time = 30
	Variable valve_1_plot = 1
	Variable valve_2_plot = 2
	Variable scan_increment = 200
		Silent 1
		If (exists("TimeW") == 0)
			LoadAndClipPoints(1,2,0)
		endif
			//--------------------------------get average value and std dev of last X seconds of sample-----------------------------------------------//		
			Variable i = 0
			Variable order_num
			Variable k = 0
			Make/O ave_values_n2o, ave_values_co, ave_values_h2o, n2o_sdev, co_sdev, h2o_sdev, n2o_slope_a, n2o_slope_b, n2o_slope_a_sdev, n2o_slope_b_sdev, co_slope_a, co_slope_b, co_slope_a_sdev, co_slope_b_sdev, h2o_slope_a, h2o_slope_b, h2o_slope_a_sdev, h2o_slope_b_sdev, x_axis_points, delta_between_valves
						
			do	//------------------------------------------------------------------------------------------------main loop to ave till no more data-------------------------------//
				order_num = MIU_valve[i+1]
				do	//------------------------------------------------scan in large increments till over shoot----//
					i+=scan_increment
					if(i >= numpnts(X_N2O__ppm))
						break
					endif	
					if (MIU_valve[i] != order_num)
						i = i-scan_increment
						break
					endif
				while(MIU_valve[i] == order_num)	//----------scan till valve changes--------------------//
				do	//--------------------------------------------------------back off and scan every pt--------------//
					if(i >= numpnts(X_N2O__ppm))
						break
					endif	
					i+=1
				while(MIU_valve[i] == order_num)	//----------scan till valve changes--------------------//
				if(i > numpnts(X_N2O__ppm))
					i = numpnts(X_N2O__ppm)
					break
				endif
				//--------------------------------------Put average values of Xseconds in Table--------------------------------------//
				if (MIU_valve[i-1] == valve_1_plot)
					ave_values_n2o[k] = mean(X_N2O__ppm, i-ave_time-1, i-1) //--------------N2O--------------//
					WaveStats/Q/R=(i-1-ave_time, i-1) X_N2O__ppm
					n2o_sdev[k] = V_sdev
					CurveFit/Q/M=2/W=0 line, X_N2O__ppm[i-ave_time,i]/X=TimeW[i-ave_time,i]/D
					n2o_slope_a[k] = W_coef[0]
					n2o_slope_b[k] = W_coef[1]
					n2o_slope_a_sdev[k] = W_sigma[0]
					n2o_slope_b_sdev[k] = W_sigma[1]
					
					//---------------CO_Average----------------------------------------------------------------------------------------//
					ave_values_co[k] = mean(X_CO__ppm, i-ave_time-1, i-1)
					WaveStats/Q/R=(i-1-ave_time, i-1) X_CO__ppm
					co_sdev[k] = V_sdev
					CurveFit/Q/M=2/W=0 line, X_CO__ppm[i-ave_time, i]/X=TimeW[i-ave_time,i]/D
					co_slope_a[k] = W_coef[0]
					co_slope_b[k] = W_coef[1]
					co_slope_a_sdev[k] = W_sigma[0]
					co_slope_b_sdev[k] = W_sigma[1]

					//---------------H2O_Average----------------------------------------------------------------------------------------//
					ave_values_h2o[k] = mean(X_H2O__ppm, i-ave_time-1, i-1)
					WaveStats/Q/R=(i-1-ave_time, i-1) X_H2O__ppm
					h2o_sdev[k] = V_sdev
					CurveFit/Q/M=2/W=0 line, X_H2O__ppm[i-ave_time, i]/X=TimeW[i-ave_time,i]/D
					h2o_slope_a[k] = W_coef[0]
					h2o_slope_b[k] = W_coef[1]
					h2o_slope_a_sdev[k] = W_sigma[0]
					h2o_slope_b_sdev[k] = W_sigma[1]

					x_axis_points[k] = k
					k+=1 
				endif
			while(i<numpnts(X_N2O__ppm))	//---------------------------------------------------------------------------main loop kill----------------------------------//
			
			Edit/N=Table_V1/I/W=(0,0,13,3) ave_values_n2o, ave_values_co, ave_values_h2o, n2o_sdev, co_sdev, h2o_sdev, n2o_slope_a, n2o_slope_b, n2o_slope_a_sdev, n2o_slope_b_sdev, co_slope_a, co_slope_b, co_slope_a_sdev, co_slope_b_sdev, h2o_slope_a, h2o_slope_b, h2o_slope_a_sdev, h2o_slope_b_sdev, x_axis_points, delta_between_valves
			DeletePoints k, 128, ave_values_n2o, ave_values_co, ave_values_h2o, n2o_sdev, co_sdev, h2o_sdev, n2o_slope_a, n2o_slope_b, n2o_slope_a_sdev, n2o_slope_b_sdev, co_slope_a, co_slope_b, co_slope_a_sdev, co_slope_b_sdev, h2o_slope_a, h2o_slope_b, h2o_slope_a_sdev, h2o_slope_b_sdev, x_axis_points
			Variable n2o_average_val				
			Variable n2o_average_sdev 			
			DisplayGraph(1, 9, "N2O", "X_N2O__ppm", "TimeW", "N2O_ppm", "Date and Time")			
			DisplayGraph(4, 9, "N2O", "X_CO__ppm", "TimeW", "CO_ppm", "Date and Time")	
			DisplayGraph(7, 9, "N2O", "X_H2O__ppm", "TimeW", "H2O_ppm", "Date and Time")				
		
			DisplayGraph(3, 20, "N2O", "ave_values_n2o", "x_axis_points", "N2O", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars ave_values_n2o Y,wave=(n2o_sdev,n2o_sdev)		
			WaveStats/Q ave_values_n2o
			n2o_average_val = V_avg
			n2o_average_sdev = V_sdev
			Tag/W=N2O_Graph3 /L=0/N=texta/I=0/X=1/Y=10 ave_values_n2o, 2, "ave value: \{n2o_average_val} \rStdev: \{n2o_average_sdev} "

			DisplayGraph(4, 20, "N2O_", "ave_values_co", "x_axis_points", "CO", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars ave_values_co Y,wave=(co_sdev,co_sdev)		
			Tag/W=N2O__Graph4 /L=0/N=texta/I=0/X=1/Y=10 ave_values_co, 2, "ave value: \{mean(ave_values_co)}"

			DisplayGraph(5, 20, "N2O", "ave_values_h2o", "x_axis_points", "H2O", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars ave_values_h2o Y,wave=(h2o_sdev,h2o_sdev)		
			Tag/W=N2O_Graph5 /L=0/N=texta/I=0/X=1/Y=10 ave_values_h2o, 2, "ave value: \{mean(ave_values_h2o)}"
				
			DisplayGraph(8, 20, "N2O", "n2o_slope_b", "x_axis_points", "N2O slope", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars n2o_slope_b Y,wave=(n2o_slope_b_sdev, n2o_slope_b_sdev)		
				
			DisplayGraph(9, 20, "N2O", "co_slope_b", "x_axis_points", "CO Slope", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars co_slope_b Y,wave=(co_slope_b_sdev, co_slope_b_sdev)

			DisplayGraph(10, 20, "N2O", "h2o_slope_b", "x_axis_points", "H2O Slope", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars h2o_slope_b Y,wave=(h2o_slope_b_sdev, h2o_slope_b_sdev)

			//-------------------------MIU_valve Second Valve to plot---------------------------//
		Make/O ave_values_n2o_v2, ave_values_co_v2, ave_values_h2o_v2, n2o_sdev_v2, co_sdev_v2, h2o_sdev_v2, n2o_slope_a_v2, n2o_slope_b_v2, n2o_slope_a_v2_sdev, n2o_slope_b_v2_sdev, co_slope_a_v2, co_slope_b_v2, co_slope_a_v2_sdev, co_slope_b_v2_sdev, h2o_slope_a_v2, h2o_slope_b_v2, h2o_slope_a_v2_sdev, h2o_slope_b_v2_sdev, x_axis_points, delta_between_valves_v2
			i = 0
			k = 0
			do	//------------------------------------------------------------------------------------------------main loop to ave till no more data-------------------------------//
				order_num = MIU_valve[i+1]
				do	//------------------------------------------------scan in large increments till over shoot----//
					i+=scan_increment
					if(i >= numpnts(X_N2O__ppm))
						break
					endif	
					if (MIU_valve[i] != order_num)
						i = i-scan_increment
						break
					endif
				while(MIU_valve[i] == order_num)	//----------scan till valve changes--------------------//
				do	//--------------------------------------------------------back off and scan every pt--------------//
					if(i >= numpnts(X_N2O__ppm))
						break
					endif	
					i+=1
				while(MIU_valve[i] == order_num)	//----------scan till valve changes--------------------//
				if(i > numpnts(X_N2O__ppm))
					i = numpnts(X_N2O__ppm)
					break
				endif
				//--------------------------------------Put average values of Xseconds in Table--------------------------------------//
				if (MIU_valve[i-1] == valve_2_plot)
					ave_values_n2o_v2[k] = mean(X_N2O__ppm, i-ave_time-1, i-1) //--------------N2O--------------//
					WaveStats/Q/R=(i-1-ave_time, i-1) X_N2O__ppm
					n2o_sdev_v2[k] = V_sdev
					CurveFit/Q/M=2/W=0 line, X_N2O__ppm[i-ave_time,i]/X=TimeW[i-ave_time,i]/D
					n2o_slope_a_v2[k] = W_coef[0]
					n2o_slope_b_v2[k] = W_coef[1]
					n2o_slope_a_v2_sdev[k] = W_sigma[0]
					n2o_slope_b_v2_sdev[k] = W_sigma[1]
					
					//---------------CO_Average----------------------------------------------------------------------------------------//
					ave_values_co_v2[k] = mean(X_CO__ppm, i-ave_time-1, i-1)
					WaveStats/Q/R=(i-1-ave_time, i-1) X_CO__ppm
					co_sdev_v2[k] = V_sdev
					CurveFit/Q/M=2/W=0 line, X_CO__ppm[i-ave_time, i]/X=TimeW[i-ave_time,i]/D
					co_slope_a_v2[k] = W_coef[0]
					co_slope_b_v2[k] = W_coef[1]
					co_slope_a_v2_sdev[k] = W_sigma[0]
					co_slope_b_v2_sdev[k] = W_sigma[1]

					//---------------H2O_Average----------------------------------------------------------------------------------------//
					ave_values_h2o_v2[k] = mean(X_H2O__ppm, i-ave_time-1, i-1)
					WaveStats/Q/R=(i-1-ave_time, i-1) X_H2O__ppm
					h2o_sdev_v2[k] = V_sdev
					CurveFit/Q/M=2/W=0 line, X_H2O__ppm[i-ave_time, i]/X=TimeW[i-ave_time,i]/D
					h2o_slope_a_v2[k] = W_coef[0]
					h2o_slope_b_v2[k] = W_coef[1]
					h2o_slope_a_v2_sdev[k] = W_sigma[0]
					h2o_slope_b_v2_sdev[k] = W_sigma[1]

					x_axis_points[k] = k
					k+=1 
				endif
			while(i<numpnts(X_N2O__ppm))	//---------------------------------------------------------------------------main loop kill----------------------------------//
			
			Edit/N=Table_V2/I ave_values_n2o_v2, ave_values_co_v2, ave_values_h2o_v2, n2o_sdev_v2, co_sdev_v2, h2o_sdev_v2, n2o_slope_a_v2, n2o_slope_b_v2, n2o_slope_a_v2_sdev, n2o_slope_b_v2_sdev, co_slope_a_v2, co_slope_b_v2, co_slope_a_v2_sdev, co_slope_b_v2_sdev, h2o_slope_a_v2, h2o_slope_b_v2, h2o_slope_a_v2_sdev, h2o_slope_b_v2_sdev, x_axis_points, delta_between_valves_v2
			DeletePoints k, 128, ave_values_n2o_v2, ave_values_co_v2, ave_values_h2o_v2, n2o_sdev_v2, co_sdev_v2, h2o_sdev_v2, n2o_slope_a_v2, n2o_slope_b_v2, n2o_slope_a_v2_sdev, n2o_slope_b_v2_sdev, co_slope_a_v2, co_slope_b_v2, co_slope_a_v2_sdev, co_slope_b_v2_sdev, h2o_slope_a_v2, h2o_slope_b_v2, h2o_slope_a_v2_sdev, h2o_slope_b_v2_sdev, x_axis_points

			DisplayGraph(13, 20, "N2O", "ave_values_n2o_v2", "x_axis_points", "N2O", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars ave_values_n2o_v2 Y,wave=(n2o_sdev_v2,n2o_sdev_v2)		
			Tag/W=N2O_Graph13 /L=0/N=textb/I=0/X=1/Y=10 ave_values_n2o_v2, 2, "ave value: \{mean(ave_values_n2o_v2)} "

			DisplayGraph(14, 20, "N2O", "ave_values_co_v2", "x_axis_points", "CO", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars ave_values_co_v2 Y,wave=(co_sdev_v2,co_sdev_v2)		
			Tag/W=N2O_Graph14 /L=0/N=textb/I=0/X=1/Y=10 ave_values_co_v2, 2, "ave value: \{mean(ave_values_co_v2)}"

			DisplayGraph(15, 20, "N2O", "ave_values_h2o_v2", "x_axis_points", "H2O", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars ave_values_h2o_v2 Y,wave=(h2o_sdev_v2,h2o_sdev_v2)		
			Tag/W=N2O_Graph15 /L=0/N=textb/I=0/X=1/Y=10 ave_values_h2o_v2, 2, "ave value: \{mean(ave_values_h2o_v2)}"
				
			DisplayGraph(18, 20, "N2O", "n2o_slope_b_v2", "x_axis_points", "N2O slope", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars n2o_slope_b_v2 Y,wave=(n2o_slope_b_v2_sdev, n2o_slope_b_v2_sdev)		
				
			DisplayGraph(19, 20, "N2O", "co_slope_b_v2", "x_axis_points", "CO Slope", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars co_slope_b_v2 Y,wave=(co_slope_b_v2_sdev, co_slope_b_v2_sdev)

			DisplayGraph(20, 20, "N2O", "h2o_slope_b_v2", "x_axis_points", "H2O Slope", "points")
			ModifyGraph mode=2,lsize=5;DelayUpdate
			ErrorBars h2o_slope_b_v2 Y,wave=(h2o_slope_b_v2_sdev, h2o_slope_b_v2_sdev)
END
