extends Node

var Runfilepath = ''
func constructPyFile(benchpress = Global.current_project):
	Global.create_dir()
	#global variable
	for flow in benchpress['Flows']:
		var PyfunctionStr = constructpyfunction(benchpress['Flows'][str(flow)],benchpress['ElementStructures'])
		
func constructpyfunction(ElementProperties,elementStructures,numberOfTab = 0,continuingString = ''):
	var PyfunctionStr = continuingString
	for element in ElementProperties:
		var elementStructure  = elementStructures[str(ElementProperties[str(element)]['SourceLibrary'])]
	return PyfunctionStr
