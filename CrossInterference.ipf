#pragma rtGlobals=1		// Use modern global access method.

Macro CrossInterference(polyNum)
	Variable polyNum = 4;
	
	if(exists("X_N2O__ppm") != 1)	
	LoadAndClipPoints(1,2,0)
	endif
	
	DisplayGraph(1, 8, "N2O", "X_N2O__ppm", "TimeW", "N2O ppm", "Date and Time")
	DisplayGraph(2, 8, "N2O", "X_CO__ppm", "TimeW", "CO ppm", "Date and Time")
	DisplayGraph(3, 8, "N2O", "X_N2O__ppm", "X_CO__ppm", "PPB", "PPB")
	Label left "\\Z24N\\B2\\M\\Z24O (ppb)"
	Label bottom "\\Z24CO (ppm)"
	ModifyGraph mode=3,marker=8
	DisplayGraph(4, 8, "N2O", "LTC0_v", "TimeW", "Line lock voltage", "Date and Time")
	DisplayGraph(5, 8, "N2O", "BL0T", "TimeW", "Baseline 0", "Date and Time")
	DisplayGraph(6, 8, "N2O", "BL1T", "TimeW", "Baseline 1", "Date and Time")
	
	CurveFit/M=2/W=0 poly polyNum, X_N2O__ppm/X=X_CO__ppm/D
	print "Y Intercept: ",   W_coef[0]
	
	Duplicate/O X_N2O__ppm N2O_correctionFactor
	N2O_correctionFactor = N2O_correctionFactor/W_coef[0]
	
	DisplayGraph(8, 8, "N2O", "N2O_correctionFactor", "X_CO__ppm", "CalFactor", "PPM")
	
	K0=1
	CurveFit/H="1000"/NTHR=0/TBOX=0 poly polyNum, N2O_correctionFactor /X=X_CO__ppm /D
	
	Make/O Coeffs
	Edit/N=FitCoeffs/I/W=(0,5,3,7) Coeffs

if(polyNum == 4)
	Coeffs[0] = K0
	Coeffs[1] = K1
	Coeffs[2] = K2
	Coeffs[3] = K3
endif	
if(polyNum == 5)	
	Coeffs[0] = K0
	Coeffs[1] = K1
	Coeffs[2] = K2
	Coeffs[3] = K3
	Coeffs[4] = K4
endif	
if(polyNum == 6)	
	Coeffs[0] = K0
	Coeffs[1] = K1
	Coeffs[2] = K2
	Coeffs[3] = K3
	Coeffs[4] = K4
	Coeffs[5] = K5		
endif
if(polyNum == 7)
	Coeffs[0] = K0
	Coeffs[1] = K1
	Coeffs[2] = K2
	Coeffs[3] = K3
	Coeffs[4] = K4
	Coeffs[5] = K5		
	Coeffs[6] = K6
endif
if(polyNum == 8)
	Coeffs[0] = K0
	Coeffs[1] = K1
	Coeffs[2] = K2
	Coeffs[3] = K3
	Coeffs[4] = K4
	Coeffs[5] = K5		
	Coeffs[6] = K6
	Coeffs[7] = K7	
endif	
	ModifyGraph mode(N2O_correctionFactor)=3,marker(N2O_correctionFactor)=8
	ModifyGraph rgb(fit_N2O_correctionFactor)=(0,0,0)

	Duplicate/O X_N2O__ppm n2oNew
	n2oNew = X_N2O__ppm / ( K0 + K1*X_CO__ppm + K2*X_CO__ppm*X_CO__ppm + K3*X_CO__ppm*X_CO__ppm*X_CO__ppm)
	Display n2oNew vs X_CO__ppm
	
End