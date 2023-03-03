extends Node


# Once major version 1 is reached this file is not changed ....else backward compatability may be lost   
var ElementStructure:Dictionary ={
	'Library' : '',
	'LibraryVersion' :'',
	'Type':'Element',#Inheritable,errorhandler
	'Title' : 'ADD VARIABLE',
	'Description' : '',
	'Doc':'',
	'Icon':'',
	'GroupPath':'',
	'Dependencies':[],
	'Inherit':[],
	'Iniciator':[],
	'AntiIniciator':[],
	'Parent':false,
	'Morphs':{#loop-able, keys are not fixed
		#Placeholder key but Base maybe found in most elements
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
	
var ElementProperties :Dictionary = {#loop-able keys are not fixed
	'position_index':{#fixed keys
		'children' : {},#children ElementProperties
		'SourceLibrary':'',#Libraries['Nameunique'] (First name is editor assigned to prevent library collision)+':'+Libraries['Name']  +':'+ ElementStructure['GroupPath'] +':'+ ElementStructure['GroupPath']
		'Enabled' : true,
		'BreakingPoint': false,
		'ActiveMorphs' :['Base'],
		'Properties':{#loop-able keys are not fixed
			#'Edited_Properties_Name' :'Value'#set_values
			},
		'ElementVariable':{#loop-able keys are not fixed
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
	
var FlowStructure:Dictionary ={#loop-able, keys are not fixed
	'main' : ElementProperties
	}
	
var flowElementslist:Dictionary ={
	'SourceLibrary': ElementStructure# Nameunique = Libraries['Name'] or (First name is editor assigned to prevent library collision but not include in library files)+':'+Libraries['Name']  +':'+ ElementStructure['GroupPath'] +':'+ ElementStructure['GroupPath']
	}
	
var BenchPress :Dictionary = {
	'Version' : '0.0.1.Dev',
	'FileState' : 'Library',#Flow,App -->'App' filestate is reserved for deployed clients
	'LibrariesVersion' :{#loop-able keys are not fixed
		'built-in': '0.0.1.Alfa',
		},
	'Globals':{#loop-able keys are not fixed
		'Globalsid':{
			'Type':'',
			'Value':''
			}
		},
	'Flows': FlowStructure,
	'ElementStructures':flowElementslist, # if FileState is Flow flowElementslist only include used elements
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
	'ElementUpdatePatterns':{#loop-able keys are not fixed
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
		'user://Flows' : {},#created project folders:::('user://Flows/'+uniquefoldername+'/projectname.benchpress') ,('user://Flows/'+uniquefoldername+'/Runfile') 
		'user://Running' : {},
	}
	
func some_notes():
	pass
# > Flow is Python function ,
	#(is just a collection of FlowElement)
	#visible in Editor.FlowContainer
# > Element.type = 'Element' is Python Snippet, 
	#visible in Editor.ElementsContainer 
	#and Constructor.ElementManager 
	#(it properties are editable in FlowElementProprertiesEdit)
# > Element.type = 'Inheritable' are Python Classes,
	#visible in Constructor.ElementCreate
# > Element.type = 'Errorhandler' is Python Exception Handling,
	#visible in in FlowElementProprertiesEdit Dock 
	#and Constructor.ElementManager
	
