#pragma rtGlobals=1		// Use modern global access method.

Macro LeakRate(version)
	String version
	Prompt version, "Please select instrument type", popup "Gas Instrument;NO2"

	If (CmpStr(version, "Gas Instrument") == 0)
		LoadWave/J/D/W/E=1/K=0/L={1,2,0,0,0}
		Display GasP_torr vs TimeW

		WaveStats/Q TimeW
		Variable maxTime = V_max
		Variable minTime = V_min

		WaveStats/Q GasP_torr
		Variable maxTorr = V_max
		Variable minTorr = V_min
	
		Variable/G LeakRateNum = (maxTorr-minTorr)/(maxTime-minTime)*60
		Variable/G TimeDiff = (maxTime-minTime)/60
		Print "Leak Rate: ", LeakRateNum, "Torr/Min"
		Print "Time Elapsed: ", (maxTime-minTime)/60, "minutes"

		Tag /L=0/N=texta/I=0/X=1/Y=10 GasP_torr, 2,"Leak Rate: \{ LeakRateNum} torr/min\rTime Elapsed: \{TimeDiff}  mins"
		
	endif


	If (CmpStr(version, "NO2") == 0)
	
		if(exists("Pressure__Torr_")==0)
		LoadWave/J/D/W/E=1/K=0/L={2,3,0,0,0}
		endif
		Display Pressure__Torr_ vs Relative_Time__s_

		WaveStats/Q Relative_Time__s_
		Variable maxTime = V_max
		Variable minTime = V_min

		WaveStats/Q Pressure__Torr_
		Variable maxTorr = V_max
		Variable minTorr = V_min
	
		Variable/G LeakRateNum = (maxTorr-minTorr)/(maxTime-minTime)*60
		Variable/G TimeDiff = (maxTime-minTime)/60
		Print "Leak Rate: ", LeakRateNum, "Torr/Min"
		Print "Time Elapsed: ", (maxTime-minTime)/60, "minutes"

		Tag /L=0/N=texta/I=0/X=1/Y=10 Pressure__Torr_, 2,"Leak Rate: \{ LeakRateNum} torr/min\rTime Elapsed: \{TimeDiff}  mins"

	endif
	

END
