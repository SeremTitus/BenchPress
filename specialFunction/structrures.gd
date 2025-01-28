extends Node


# Once major version 1 is reached this file is not changed ....else backward compatability may be lost   
var ActionCallAction:Dictionary ={
	'Library' : '',
	'LibraryVersion' :'',
	'Type':'ActionCall',#Inheritable,errorhandler
	'Title' : 'ADD VARIABLE',
	'Description' : '',
	'Doc':'',
	'Icon':'',
	'GroupPath':'',
	'Dependencies':[],
	'Inherit':[],
	'Parent':false,
	'Morphs':{#loop-able, keys are not fixed
		#Placeholder key but Base maybe found in most ActionCalls
		'Base' :{#fixed keys
			'Feature' : '',
			'Code' : '',
			'Properties':{#loop-able keys are not fixed
				#Placeholder key
				'Enter Variable Name':{#fixed keys
					'VariableName':'',
					'Type':'',
					'Display':'',
					'DisplayType':'',
					'subtype':'',
					'DefaultValue':'',
					'InputOutput':''
					}
				}
			}
		}
	}
	
var ActionCallProperties :Dictionary = {#loop-able keys are not fixed
	'position_index':{#fixed keys
		'children' : {},#children ActionCallProperties
		'SourceLibrary':'',#Libraries['Nameunique'] (First name is editor assigned to prevent library collision)+':'+Libraries['Name']  +':'+ ActionCallAction['GroupPath'] +':'+ ActionCallAction['GroupPath']
		'Enabled' : true,
		'BreakingPoint': false,
		'ActiveMorphs' :['Base'],
		'Properties':{#loop-able keys are not fixed
			#'Edited_Properties_Name' :'Value'#set_values
			},
		'ActionCallVariable':{#loop-able keys are not fixed
			#'Edited_Properties_Name' :'Name'#set_values
			},
		'errorhandlers':{#loop-able keys are not fixed
			'SourceLibrary':{
				'Enabled' : true,
				'Properties':{#loop-able keys are not fixed
					#'Edited_Properties_Name' :'Value'
					}
				}
			},
		}
	}
	
var SubroutineAction:Dictionary ={#loop-able, keys are not fixed
	'main' : ActionCallProperties
	}
	
var SubroutineActionCallslist:Dictionary ={
	'SourceLibrary': ActionCallAction# Nameunique = Libraries['Name'] or (First name is editor assigned to prevent library collision but not include in library files)+':'+Libraries['Name']  +':'+ ActionCallAction['GroupPath'] +':'+ ActionCallAction['GroupPath']
	}
	
var BenchPress :Dictionary = {
	'Version' : '0.0.1.Dev',
	'FileState' : 'Library',#Subroutine,App -->'App' filestate is reserved for deployed clients
	'LibrariesVersion' :{#loop-able keys are not fixed
		'built-in': '0.0.1.Alfa',
		},
	'Globals':{#loop-able keys are not fixed
		'Globalsid':{
			'Type':'',
			'Value':''
			}
		},
	'Subroutines': SubroutineAction,
	'ActionCallActions':SubroutineActionCallslist, # if FileState is Subroutine SubroutineActionCallslist only include used ActionCalls
	'Schedule':{#loop-able keys are not fixed
		'file path':{ 
			'single/repeat':{
				'day/date':{
					'Active':true,
					'ActivationRule':{
						'startDate': '',
						'endDate': '',
						'pattern':{
							0 :{
								'Active':true,
								'deactivateSchedule':false,
								'deactivateScheduleValue':[],
								'deactivatePattern':false,
								'deactivatePatternValue':[],
								'name':'even/odd/skip/prime',
								'skipValue':0,
								'based':false,
								},
						},
					},
					'DeactivationRule':{
						'startDate': '',
						'endDate': '',
						'pattern':{
							0 :{
								'Active':true,
								'deactivateSchedule':false,
								'deactivateScheduleValue':[],
								'deactivatePattern':false,
								'deactivatePatternValue':[],
								'name':'even/odd/skip/prime',
								'skipValue':0,
								'based':false,
								},
						},
					},
					'ActivationTimes':0,
					'hour':'',
					'min':'',
				}
			}
		},
	},
	'ActionCallUpdatePatterns':{#loop-able keys are not fixed
		#Intended for libraries to be able to be updated atleast in minorEditor releases
		#TOBE DEFINED
		}
	}
	
var custom_user_folders={
		'user://Library' : {
			"built_in.benchpress":"res://Library/builtIn.benchpress",
			},
		'user://Editor' : {},#Editor settings
		'user://enve':{},#python enveronment
		'user://Subroutines' : {},#created project folders:::('user://Subroutines/'+uniquefoldername+'/projectname.benchpress') ,('user://Subroutines/'+uniquefoldername+'/Runfile') 
		'user://Running' : {},
	}
	
func some_notes():
	pass
# > Subroutine is Python function ,
	#(is just a collection of SubroutineActionCall)
	#visible in Editor.SubroutineContainer
# > ActionCall.type = 'ActionCall' is Python Snippet, 
	#visible in Editor.ActionCallsContainer 
	#and Constructor.ActionCallManager 
	#(it properties are editable in SubroutineActionCallProprertiesEdit)
# > ActionCall.type = 'Inheritable' are Python Classes,
	#visible in Constructor.ActionCallCreate
# > ActionCall.type = 'Errorhandler' is Python Exception Handling,
	#visible in in SubroutineActionCallProprertiesEdit Dock 
	#and Constructor.ActionCallManager
	
