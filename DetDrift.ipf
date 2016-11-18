#pragma rtGlobals=1		// Use modern global access method.

Macro DetectorDrift()
	if(Exists("DetOff")==0)
	LoadWave/J/D/W/E=1/K=0/L={99,100,0,0,0}
	else
	
	WaveStats/Q TimeW
	Variable maxTime = V_max
	Variable minTime = V_min

	WaveStats/Q DetOff
	Variable maxVolt = V_max
	Variable minVolt = V_min
	
	Variable DriftRate = (maxVolt-minVolt)/(maxTime-minTime)/60
	Variable DriftRateHr = (maxVolt-minVolt)/((maxTime-minTime)/3600)
	Print "Total Drift: ", (maxVolt-minVolt), "Volts"
	Print "Drift Rate: ", DriftRate, "Volts/Min"
	Print "Time Elapsed: ", (maxTime-minTime)/60, "minutes"
	Print "Drift Rate: ", DriftRateHr, "Volts/Hr"
	Print "Time Elapsed: ", (maxTime-minTime)/3600, "hours"
	Print "Drift Rate: ",((maxVolt-minVolt)*1000)/((maxTime-minTime)/3600), "mV/Hr"
	endif

END
