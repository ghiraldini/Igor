#pragma rtGlobals=1		// Use modern global access method.

Macro FitEtalon(InstrType)
	String InstrType
	Prompt InstrType, "Please select instrument type", popup "N2O"
	String cmd
	Printf "\r"	
	If (CmpStr(InstrType, "N2O") == 0)
//		sprintf cmd, "LoadNewLGRDataFile(\"%s\")", InstrType, 
		LoadNewLGRDataFile(InstrType, 0)
		Execute /Q cmd

		DisplayGraph(1, 5, InstrType, "Xaxis0", "TimeW", "Etalon A", "Date and Time")
		DisplayGraph(2, 5, InstrType, "Xaxis1", "TimeW", "Etalon B", "Date and Time")
		DisplayGraph(3, 5, InstrType, "Xaxis2", "TimeW", "Etalon C", "Date and Time")
//		DisplayGraph(4, 5, InstrType, "Xaxis3", "TimeW", "Etalon D", "Date and Time")
//		DisplayGraph(5, 5, InstrType, "Xaxis4", "TimeW", "Etalon E", "Date and Time")


	print "-------------------------------------------------------------------"		
	print "Average Etalon Coefficients, last 20 points:"
	print "-------------------------------------------------------------------"
	print "Etalon A Average: " , mean(Xaxis0, numpnts(Xaxis0), numpnts(Xaxis0)-20)
	print "-------------------------------------------------------------------"
	print "Etalon B Average: " , mean(Xaxis1, numpnts(Xaxis1), numpnts(Xaxis1)-20)
	print "-------------------------------------------------------------------"
	print "Etalon C Average: " , mean(Xaxis2, numpnts(Xaxis2), numpnts(Xaxis2)-20)
	print "-------------------------------------------------------------------"
		
	Endif

End