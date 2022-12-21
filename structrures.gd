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
		'parent' : 0,#indicate level of nesting, 0 can the parent if the next element is 1
		'SourceLibrary':'',#Libraries['Nameunique'] (First name is editor assigned to prevent library collision)+':'+Libraries['Name']  +':'+ ElementStructure['GroupPath'] +':'+ ElementStructure['GroupPath']
		'Enabled' : true,
		'BreakingPoint': false,
		'ActiveMorphs' :['Base'],
		'Properties':{#loop-able keys are not fixed
			#'Edited_Properties_Name' :'Value'#set_values
			},
		'FlowVariable':{#loop-able keys are not fixed
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
		'Inheritables':{#loop-able keys are not fixed
			'SourceLibrary':{
				'Enabled' : true,
				'Properties':{#loop-able keys are not fixed
					#'Edited_Properties_Name' :'Value'
					}
				}
			}
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
	'FileState' : 'Library',#Flow,app -->'app' filestate is reserved for deployed clients
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
	'ElementUpdatePatterns':{#loop-able keys are not fixed
		#Intended for libraries to be able to be updated atleast in minorEditor releases
		#TOBE DEFINED
		}
	}
	
var custom_user_folders={
		'user://Library' : {
			"built_in.benchpress":"res://Library/builtIn.benchpress",
			},
		'user://Editor' : {},
		'user://enve':{},
		'user://Flows' : {},
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
	

