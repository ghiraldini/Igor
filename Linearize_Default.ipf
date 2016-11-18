#pragma rtGlobals=1		// Use modern global access method.

// This macro along with the helper functions, finds the edges of 4 bottles and calculates the pressure width coefficients to match all concentrations

Macro LinearizeDefault(bottles, backoff, lowBottleOrder, midBottleOrder, cmdlBottleOrder, mid3BottleOrder,mid2BottleOrder, highBottleOrder, high2BottleOrder)
	// Changeable parameters for the user
	Prompt bottles, "Enter number of bottles used:"
	Variable bottles = 7
	Variable backoff = 30				// small decease in edge point to land on flat part before next curve
	Variable lowBottleOrder = 0
	Variable midBottleOrder = 1
	Variable cmdlBottleOrder = 2
	Variable mid3BottleOrder = 99	
	Variable mid2BottleOrder = 3
	Variable highBottleOrder = 4
	Variable high2BottleOrder = 5
	Silent 1
	// Hard Coded Variables that may have to be adjusted accordingly
	
	Variable increasecorrect = 100		// larger increases for next edge	
	Variable increasewrong = 100		// small increment to find next correct edge
	Variable avepoints = 5				// number of points to avereage along edge, bigger avepoints = larger backoff value to not average edge drop off
	Variable startpoint = 50			// where to start scanning for edge, value is increased every edge
	Variable endpoint = 200			// endpoint where to scan edge, always much much larger than next edge point      
			
	// Hard coded parameters + variables - should be universal enough to not adjust
	Variable curves
	Variable offset = 0				// offset to jump to rest of concentration edges
	Variable pointA = 0 				// cursor points of where averaging is being done
	Variable pointB = 0 				// "   "

	Variable scanpoints = curves*bottles	// scan points = "Bottle Edges"; 5 = (high, mid1, low, cmdl)
	Variable bool = 0
	Variable edge_value = 0
	
	Variable i = 0 					// counter for pwc column of table
	Variable count = 0 				// counter for edge scanning of curves
	Variable reset = 0					// counter resets every curve to place values with correct bottles
	
	Variable high2index = 0			// counters for indexing each column
	Variable highindex = 0				
	Variable mid3index = 0	
	Variable mid2index = 0
	Variable mid1index = 0
	Variable lowindex = 0
	Variable cmdlindex = 0
	
	Variable high2pointA				// Variables used for storage of average values for each bottle
	Variable high2pointB
	Variable highpointA
	Variable highpointB
	Variable mid3pointA
	Variable mid3pointB
	Variable mid2pointA
	Variable mid2pointB
	Variable mid1pointA
	Variable mid1pointB
	Variable lowpointA
	Variable lowpointB
	Variable cmdlpointA
	Variable cmdlpointB
	
	//----------------------------------------------------------CMDL Limits--------------------------------------------------//
	Variable cmdln2ohigh = .50
	Variable cmdln2olow = .25
	
	Variable cmdlcohigh = .20
	Variable cmdlcolow = .10
	
	//----------------------------------------------------------Bottles Limits when searching-------------------------//
	Variable high2limithigh = 4
	Variable high2limitlow = 1.55
	
	Variable highlimithigh = 1.5
	Variable highlimitlow = 1.0				
	
	Variable mid3limithigh = .90
	Variable mid3limitlow = .50
	
	Variable mid2limithigh = .65
	Variable mid2limitlow = .30
	
	Variable mid1limithigh = .50
	Variable mid1limitlow = .21
	
	Variable lowlimithigh = .25
	Variable lowlimitlow = .10
		
	String next_nonvariable
	String novalue = "----"
	
	//----------------------------------------------------------------Start of Code-----------------------------------------------//
		
	if(exists("X_CO__ppm") != 1) 
		LoadAndClipPoints(1,2,0)
	endif
	
	Make/O n2oMeasuredValues, n2oActualValues, n2oDiff, coMeasuredValues, coActualValues, coDiff, n2oPD, coPD, n2oPDcorrected, coPDcorrected,bottlenums
	Variable pt_limit = numpnts(X_CO__ppm)
	
	do
		do
			EdgeStats/Q/R=(startpoint, endpoint)/P X_CO__ppm
			if((abs(V_EdgeLvl0-V_EdgeLvl2) < .002) || (V_EdgeLvl0 > 1 && (abs(V_EdgeLvl0-V_EdgeLvl2) < .01)))// allows for small edge detection at low concentrations and discards small edges at the high concentration
				startpoint+=2
				endpoint+=increasewrong
				bool = 0 //not an edge
//				print "end point", endpoint
//				print "start", startpoint
//				print "not edge"
			else
				bool = 1 //edge is correct
//				print "end point", endpoint
//				print "start", startpoint
//				print "found edge"
			endif

			if (bool == 1)
				break
			endif
			if(endpoint >= pt_limit)
				bool = 1
				break
			endif
			
		while(bool == 0)		
		pointA = V_EdgeLoc1-backoff 
		pointB = pointA+avepoints
//		print "A", pointA
//		print "B", pointB
		if(endpoint >= pt_limit)
			pointA = pt_limit-10
			pointB = pt_limit
			endif
		do
			if(reset == high2BottleOrder) // 2ppm		
				if (mean(X_N2O__ppm, pointA, pointB) > high2limitlow && mean(X_CO__ppm, pointA, pointB) > high2limitlow)
					edge_value = 0
				else
					edge_value = 1
					endpoint+=increasewrong
					break
				endif
				n2oMeasuredValues[high2BottleOrder] = mean(X_N2O__ppm, pointA, pointB)
				coMeasuredValues[high2BottleOrder] = mean(X_CO__ppm, pointA, pointB)
				high2index+=1
				high2pointA = pointA
				high2pointB = pointB
//				n2oActualValues[reset] = 1.968
//				coActualValues[reset] = 1.905
				n2oActualValues[reset] = 1.9718
				coActualValues[reset] = 1.8681

			endif
			if(reset == highBottleOrder) // 1ppm
				if (mean(X_N2O__ppm, pointA, pointB) > highlimitlow && mean(X_CO__ppm, pointA, pointB) < highlimithigh)
					edge_value = 0
				else
					edge_value = 1
					endpoint+=increasewrong
					break
				endif
				n2oMeasuredValues[highBottleOrder] = mean(X_N2O__ppm, pointA, pointB)
				coMeasuredValues[highBottleOrder] = mean(X_CO__ppm, pointA, pointB)
				highindex+=1
				highpointA = pointA
				highpointB = pointB
//				n2oActualValues[reset] = 1.245
//				coActualValues[reset] = 1.210
				n2oActualValues[reset] = 1.1921
				coActualValues[reset] = 1.1360

			endif
			if(reset == mid3BottleOrder) // 700ppb
				if (mean(X_N2O__ppm, pointA, pointB) > mid3limitlow && mean(X_N2O__ppm, pointA, pointB) < mid3limithigh && mean(X_CO__ppm, pointA, pointB) < mid3limithigh && mean(X_CO__ppm, pointA, pointB) > mid3limitlow)
					edge_value = 0
				else
					edge_value = 1	
					endpoint+=increasewrong
					break
				endif
				n2oMeasuredValues[mid3BottleOrder] = mean(X_N2O__ppm, pointA, pointB) 
				coMeasuredValues[mid3BottleOrder] = mean(X_CO__ppm, pointA, pointB)
				mid3index+=1
				mid3pointA = pointA
				mid3pointB = pointB
				coActualValues[reset] = .7000
				n2oActualValues[reset] = .7000
			endif
			if(reset == mid2BottleOrder) // 400ppb
				if (mean(X_N2O__ppm, pointA, pointB) > mid2limitlow && mean(X_N2O__ppm, pointA, pointB) < mid2limithigh && mean(X_CO__ppm, pointA, pointB) < mid2limithigh && mean(X_CO__ppm, pointA, pointB) > mid2limitlow)
					edge_value = 0
				else
					edge_value = 1
					endpoint+=increasewrong
					break
				endif
				n2oMeasuredValues[mid2BottleOrder] = mean(X_N2O__ppm, pointA, pointB) 
				coMeasuredValues[mid2BottleOrder] = mean(X_CO__ppm, pointA, pointB)
				mid2index+=1
				mid2pointA = pointA
				mid2pointB = pointB
				coActualValues[reset] = .3891
				n2oActualValues[reset] = .4042
			endif
			if(reset == midBottleOrder) // 250ppb
				if (mean(X_N2O__ppm, pointA, pointB) > mid1limitlow && mean(X_N2O__ppm, pointA, pointB) < mid1limithigh && mean(X_CO__ppm, pointA, pointB) < mid1limithigh && mean(X_CO__ppm, pointA, pointB) > mid1limitlow)
					edge_value = 0
				else
					edge_value = 1
					endpoint+=increasewrong
					break
				endif
				n2oMeasuredValues[midBottleOrder] = mean(X_N2O__ppm, pointA, pointB) 
				coMeasuredValues[midBottleOrder] = mean(X_CO__ppm, pointA, pointB)
				mid1index+=1
				mid1pointA = pointA
				mid1pointB = pointB
//				n2oActualValues[reset] = .2521
//				coActualValues[reset] = .2439				
				n2oActualValues[reset] = .2535
				coActualValues[reset] = .2447		

			endif
			if(reset == lowBottleOrder) // 150ppb
				if (mean(X_N2O__ppm, pointA, pointB) > lowlimitlow && mean(X_N2O__ppm, pointA, pointB) < lowlimithigh && mean(X_CO__ppm, pointA, pointB) < lowlimithigh && mean(X_CO__ppm, pointA, pointB) > lowlimitlow)
					edge_value = 0
				else
					edge_value = 1
					endpoint+=increasewrong					
					break
				endif
				n2oMeasuredValues[lowBottleOrder] = mean(X_N2O__ppm, pointA, pointB)
				coMeasuredValues[lowBottleOrder] = mean(X_CO__ppm, pointA, pointB)
				lowindex+=1
				lowpointA = pointA
				lowpointB = pointB
				n2oActualValues[reset] = .1545
				coActualValues[reset] = .1470			
			endif
			if(reset == cmdlBottleOrder) // CO = 150ppb, N2O = 300ppb
				if (mean(X_N2O__ppm, pointA, pointB) > cmdln2olow && mean(X_N2O__ppm, pointA, pointB) < cmdln2ohigh && mean(X_CO__ppm, pointA, pointB) < cmdlcohigh && mean(X_CO__ppm, pointA, pointB) > cmdlcolow)
					edge_value = 0
				else
					edge_value = 1		
					endpoint+=increasewrong					
					break
				endif
				n2oMeasuredValues[cmdlBottleOrder] = mean(X_N2O__ppm, pointA, pointB)
				coMeasuredValues[cmdlBottleOrder] = mean(X_CO__ppm, pointA, pointB)
				cmdlindex+=1
				cmdlpointA = pointA
				cmdlpointB = pointB
//				coActualValues[reset] = .1463
//				n2oActualValues[reset] = .3041
				coActualValues[reset] = .1478
				n2oActualValues[reset] = .3126

			endif
			reset+=1
			if(reset == bottles)
				reset = 0
			endif

			count+=1
//			startpoint = endpoint+(increasecorrect)
//			endpoint = pointB+(2*increasecorrect)
			startpoint = pointB+increasecorrect
			endpoint = pointB+(2*increasecorrect)
			print "Found edge:", count
//			print "reset", reset
		while (edge_value == 0)
	while(count < bottles)	
	
	bottlenums[0] = 1
	bottlenums[1] = 2
	bottlenums[2] = 3
	bottlenums[3] = 4
	bottlenums[4] = 5
	bottlenums[5] = 6
	bottlenums[6] = 7
	
	
	Variable j = 0
	do	
	n2oDiff[j] = n2oActualValues[j] - n2oMeasuredValues[j]
	n2oPD[j] = (n2oDiff[j]/n2oActualValues[j])*100
	coDiff[j] = coActualValues[j] - coMeasuredValues[j]
	coPD[j] = (coDiff[j]/coActualValues[j])*100
	j+=1
	while(j<6)

	Variable n2o_cmdl = n2oPD[2]
	Variable co_cmdl = coPD[0]
	i=0
	do	//Bottle Adjustment for CMDL being off on CMDL after calibrating (unknown bug)
		n2oPDcorrected[i] = n2oPD[i]-n2o_cmdl
		coPDcorrected[i] = coPD[i]-co_cmdl
		i+=1
	while(i < 6)
	

	DeletePoints bottles,122, n2oMeasuredValues, coMeasuredValues, n2oDiff, coDiff, n2oActualValues, coActualValues, n2oPD, coPD,  n2oPDcorrected, coPDcorrected,bottlenums
	
	Edit/N=MeasuredValues n2oMeasuredValues, n2oActualValues, n2oDiff, coMeasuredValues, coActualValues, coDiff, n2oPD, coPD,n2oPDcorrected, coPDcorrected,bottlenums	
	DisplayGraph(3, 12, "N2O", "n2oMeasuredValues", "n2oActualValues", "Measured Values", "Actual Values")	
	ModifyGraph mode(n2oMeasuredValues)=3,marker=8
	CurveFit/M=2/W=0 line, n2oMeasuredValues/X=n2oActualValues/D

	DisplayGraph(4, 12, "CO", "coMeasuredValues", "coActualValues", "Measured Values", "Actual Values")
	ModifyGraph mode(coMeasuredValues)=3,marker=8
	CurveFit/M=2/W=0 line, coMeasuredValues/X=coActualValues/D
	
	DisplayGraph(7, 12, "N2O", "n2oPD", "bottlenums", "Percent Difference", "Bottle Number")	
	ModifyGraph mode=3,marker=8,nticks(left)=10,grid(left)=2
	AppendToGraph n2oPDcorrected vs bottlenums
	ModifyGraph mode=3,marker=8,rgb(n2oPDcorrected)=(0,43520,65280)
	Legend/C/N=text0/A=MC
	
	DisplayGraph(8, 12, "CO", "coPD", "bottlenums", "Percent Difference", "Bottle Number")
	ModifyGraph mode=3,marker=8,nticks(left)=10,grid(left)=2
	AppendToGraph coPDcorrected vs bottlenums
	ModifyGraph mode=3,marker=8,rgb(coPDcorrected)=(0,43520,65280)
	Legend/C/N=text0/A=MC
	
	DisplayGraph(1, 4, "N2O_CO", "X_N2O__ppm", "TImeW", "N2O & CO", "Time and Date")
	AppendToGraph X_CO__ppm vs TimeW
	ModifyGraph mode(X_CO__ppm)=0,marker(X_CO__ppm)=9,rgb(X_CO__ppm)=(0,0,0)

	Tag/W=N2O_CO_Graph1 /C/N=textj/X=0/Y=15.00 X_N2O__ppm, high2pointA,"point A"
	Tag/W=N2O_CO_Graph1 /C/N=textk/X=0/Y=15.00 X_N2O__ppm, high2pointB,"point B"
	
	Tag/W=N2O_CO_Graph1 /C/N=texts/X=0/Y=15.00 X_N2O__ppm, highpointA,"point A"
	Tag/W=N2O_CO_Graph1 /C/N=textt/X=0/Y=15.00 X_N2O__ppm, highpointB,"point B"
	
	Tag/W=N2O_CO_Graph1 /C/N=textu/X=0/Y=15.00 X_N2O__ppm, mid3pointA,"point A"
	Tag/W=N2O_CO_Graph1 /C/N=textv/X=0/Y=15.00 X_N2O__ppm, mid3pointB,"point B"
	
	Tag/W=N2O_CO_Graph1 /C/N=textu/X=0/Y=15.00 X_N2O__ppm, mid2pointA,"point A"
	Tag/W=N2O_CO_Graph1 /C/N=textv/X=0/Y=15.00 X_N2O__ppm, mid2pointB,"point B"
	
	Tag/W=N2O_CO_Graph1 /C/N=textw/X=0/Y=15.00 X_N2O__ppm, mid1pointA,"point A"
	Tag/W=N2O_CO_Graph1 /C/N=textx/X=0/Y=15.00 X_N2O__ppm, mid1pointB,"point B"

	Tag/W=N2O_CO_Graph1 /C/N=textm/X=0/Y=15.00, X_N2O__ppm, lowpointA,"point A"
	Tag/W=N2O_CO_Graph1 /C/N=textn/X=0/Y=15.00, X_N2O__ppm, lowpointB,"point B"

	Tag/W=N2O_CO_Graph1 /C/N=textq/X=0/Y=15.00 X_N2O__ppm, cmdlpointA,"point A"
	Tag/W=N2O_CO_Graph1 /C/N=textr/X=0/Y=15.00 X_N2O__ppm, cmdlpointB,"point B"	
	
	
	
End
