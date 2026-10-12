from abaqus import *
from abaqusConstants import *

stepName = "STEP1"
frameId = 1
fieldOutput = "S"
# E - strain; S - stress
component = 0
# from Abaqus Analysis User's Manual - 1.2.2 Conventions - Convention used for stress and strain components 
# ABAQUS uses Nye-Notation:               11-22-33-12-13-23
# components are therefore definded with: 0  1  2  3  4  5

odb = session.odbs.values()[0]
frame = odb.steps["first step"].frames[1]

fo = frame.fieldOutputs[fieldOutput]
foVolumes = frame.fieldOutputs["IVOL"]

def average(averagingField, volumesField, component):
	fieldValues = averagingField.values
	volumesValues = volumesField.values
	
	aveValue = 0.0
	totalVolume = 0.0
	for vi in range(len(fieldValues)):
		totalVolume += volumesValues[vi].data
		
	for vi in range(len(fieldValues)):
		ipValue = fieldValues[vi].data[component]
		ipVolume = volumesValues[vi].data
		aveValue += ipValue*ipVolume/totalVolume
		
	return aveValue

print average(fo, foVolumes, component)
