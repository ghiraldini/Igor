#pragma rtGlobals=1		// Use modern global access method.

Macro Smooooth(smoothpoints)
	Variable smoothpoints = 900

	checksmooth()
	
	if(exists("X_N2O__ppm_sd")==1)
	Make/O/N=1 N2O_ave, N2O_sdev, N2O_max, N2O_min, N2O_drift, CO_ave, CO_sdev, CO_max, CO_min, CO_drift
	//-------------------------------Smooth N2O------------------------------------------------
	Duplicate/O X_N2O__ppm,Smooth_n2o;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_n2o
	AppendToGraph/W=N2O_Graph1 Smooth_n2o vs TimeW
	ModifyGraph/W=N2O_Graph1 rgb(Smooth_n2o)=(0,0,0)
	WaveStats/Q Smooth_n2o
	N2O_ave = V_avg
	N2O_sdev = V_sdev
	N2O_max = V_max
	N2O_min = V_min
	N2O_drift = V_max-V_min
	//-------------------------------Smooth CO------------------------------------------------
	Duplicate/O X_CO__ppm,Smooth_co;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_co
	AppendToGraph/W=N2O_Graph2 Smooth_co vs TimeW
	ModifyGraph/W=N2O_Graph2 rgb(Smooth_co)=(0,0,0)
	WaveStats/Q Smooth_co
	CO_ave = V_avg
	CO_sdev = V_sdev
	CO_max = V_max
	CO_min = V_min
	CO_drift = V_max-V_min
	Edit N2O_ave, N2O_sdev, N2O_max, N2O_min, N2O_drift, CO_ave, CO_sdev, CO_max, CO_min, CO_drift
	//------------------------------Smooth H2O--------------------------------------------
	Duplicate/O X_H2O__ppm, Smooth_h2o; DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_h2o
	AppendToGraph/W=N2O_Graph3 Smooth_h2o vs TimeW
	ModifyGraph/W=N2O_Graph3 rgb(Smooth_h2o)=(0,0,0)

	//-------------------------------Smooth AmbT_C------------------------------------------------
	Duplicate/O AmbT_C,Smooth_AmbT_C;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_AmbT_C
	AppendToGraph/W=N2O_Graph4 Smooth_AmbT_C vs TimeW
	ModifyGraph/W=N2O_Graph4 rgb(Smooth_AmbT_C)=(0,0,0)
	
	//-------------------------------Smooth GasP_torr------------------------------------------------
	Duplicate/O GasP_torr,Smooth_GasP_torr;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_GasP_torr
	AppendToGraph/W=N2O_Graph11 Smooth_GasP_torr vs TimeW
	ModifyGraph/W=N2O_Graph11 rgb(Smooth_GasP_torr)=(0,0,0)
	
	//-------------------------------Smooth Peak Position-------------------------------------
	Duplicate/O Peak0,Smooth_Peak0;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_Peak0
	AppendToGraph/W=N2O_Graph10 Smooth_Peak0 vs TimeW
	ModifyGraph/W=N2O_Graph10 rgb(Smooth_Peak0)=(0,0,0)
	

	
	else

	//-------------------------------Smooth N2O------------------------------------------------
	Duplicate/O X_N2O__ppm,Smooth_n2o;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_n2o
	AppendToGraph/W=N2O_Graph1 Smooth_n2o vs TimeW
	ModifyGraph/W=N2O_Graph1 rgb(Smooth_n2o)=(0,0,0)

	//-------------------------------Smooth CO------------------------------------------------
	Duplicate/O X_CO__ppm,Smooth_co;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_co
	AppendToGraph/W=N2O_Graph2 Smooth_co vs TimeW
	ModifyGraph/W=N2O_Graph2 rgb(Smooth_co)=(0,0,0)

	//-------------------------------Smooth AIN5 (supercool)------------------------------
	Duplicate/O AIN5,Smooth_AIN5;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_AIN5
	AppendToGraph/W=N2O_Graph3 Smooth_AIN5 vs TimeW
	ModifyGraph/W=N2O_Graph3 rgb(Smooth_AIN5)=(0,0,0)

	//-------------------------------Smooth AIN6 (laser)-------------------------------------
	Duplicate/O AIN6,Smooth_AIN6;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_AIN6
	AppendToGraph/W=N2O_Graph4 Smooth_AIN6 vs TimeW
	ModifyGraph/W=N2O_Graph4 rgb(Smooth_AIN6)=(0,0,0)
	
	//-------------------------------Smooth Peak Position-------------------------------------
	Duplicate/O Peak0,Smooth_Peak0;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_Peak0
	AppendToGraph/W=N2O_Graph6 Smooth_Peak0 vs TimeW
	ModifyGraph/W=N2O_Graph6 rgb(Smooth_Peak0)=(0,0,0)
	

	//-------------------------------Smooth AmbT_C------------------------------------------------
	Duplicate/O AmbT_C,Smooth_AmbT_C;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_AmbT_C
	AppendToGraph/W=N2O_Graph7 Smooth_AmbT_C vs TimeW
	ModifyGraph/W=N2O_Graph7 rgb(Smooth_AmbT_C)=(0,0,0)

	//-------------------------------Smooth GasT_C------------------------------------------------
	Duplicate/O GasT_C,Smooth_GasT_C;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_GasT_C
	AppendToGraph/W=N2O_Graph8 Smooth_GasT_C vs TimeW
	ModifyGraph/W=N2O_Graph8 rgb(Smooth_GasT_C)=(0,0,0)

	//-------------------------------Smooth GasP_torr------------------------------------------------
	Duplicate/O GasP_torr,Smooth_GasP_torr;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_GasP_torr
	AppendToGraph/W=N2O_Graph9 Smooth_GasP_torr vs TimeW
	ModifyGraph/W=N2O_Graph9 rgb(Smooth_GasP_torr)=(0,0,0)

	//-------------------------------Smooth Gnd------------------------------------------------
	Duplicate/O Gnd,Smooth_Gnd;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_Gnd
	AppendToGraph/W=N2O_Graph10 Smooth_Gnd vs TimeW
	ModifyGraph/W=N2O_Graph10 rgb(Smooth_Gnd)=(0,0,0)

	//-------------------------------Smooth BL0T------------------------------------------------
	Duplicate/O BL0T,Smooth_BL0T;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_BL0T
	AppendToGraph/W=N2O_Graph15 Smooth_BL0T vs TimeW
	ModifyGraph/W=N2O_Graph15 rgb(Smooth_BL0T)=(0,0,0)

	//-------------------------------Smooth BL1T------------------------------------------------
	Duplicate/O BL1T,Smooth_BL1T;DelayUpdate
	Smooth/EVEN/B smoothpoints, Smooth_BL1T
	AppendToGraph/W=N2O_Graph16 Smooth_BL1T vs TimeW
	ModifyGraph/W=N2O_Graph16 rgb(Smooth_BL1T)=(0,0,0)
	endif

End


Function checksmooth()

	if (WaveExists(Smooth_n2o)==1)

		RemoveFromGraph/W=N2O_Graph1 Smooth_n2o
		RemoveFromGraph/W=N2O_Graph2 Smooth_co

		RemoveFromGraph/W=N2O_Graph3 Smooth_AIN5
		RemoveFromGraph/W=N2O_Graph4 Smooth_AIN6
		RemoveFromGraph/W=N2O_Graph6 Smooth_Peak0
		RemoveFromGraph/W=N2O_Graph7 Smooth_AmbT_C
		RemoveFromGraph/W=N2O_Graph8 Smooth_GasT_C

		RemoveFromGraph/W=N2O_Graph9 Smooth_GasP_torr
		RemoveFromGraph/W=N2O_Graph10 Smooth_Gnd
		RemoveFromGraph/W=N2O_Graph15 Smooth_BL0T
		RemoveFromGraph/W=N2O_Graph16 Smooth_BL1T

	endif

End