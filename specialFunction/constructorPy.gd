extends Node

var Runfilepath = ''
func constructPyFile(benchpress = Global.current_project):
	Global.create_dir()
	#global variable
	for Subroutine in benchpress['Subroutines']:
		var PyfunctionStr = constructpyfunction(benchpress['Subroutines'][str(Subroutine)],benchpress['ActionCallActions'])
		
func constructpyfunction(ActionCallProperties,ActionCallActions,numberOfTab = 0,continuingString = ''):
	var PyfunctionStr = continuingString
	for ActionCall in ActionCallProperties:
		var ActionCallAction  = ActionCallActions[str(ActionCallProperties[str(ActionCall)]['SourceLibrary'])]
	return PyfunctionStr
