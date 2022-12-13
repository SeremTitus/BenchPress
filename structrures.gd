extends Node


var ElementStructure:Dictionary ={
	'Library' : '',
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
	'Added_ElementID':{#fixed keys
		'parent' : '.',
		'SourceLibrary':'',
		'Enabled' : 'True',
		'BreakingPoint': 'False',
		'morphs' :['Base'],
		'Properties':{#loop-able keys are not fixed
			'Edited_Properties_Name' :'Value'#set_values
			},
		'ElementVariable':{#loop-able keys are not fixed
			'Edited_Properties_Name' :'Name'#set_values
			},
		'errorhandlers':{#loop-able keys are not fixed
			'Added_errorhandlerID':{
				'Enabled' : 'True',
				'Properties':{#loop-able keys are not fixed
					'Edited_Properties_Name' :'Value'
					}
				}
			}
		}
		}

var FlowStructure:Dictionary ={#loop-able, keys are not fixed
	'main' : ElementProperties
	
	}

var flowElementslist:Dictionary ={
	'Added_ElementID': ElementStructure
	}

var BenchPress :Dictionary = {
	'Version' : '0.0.1',
	'Patch' :'Alfa',# beta,Version,stable
	'FileState' : 'Library',#Flow,app -->'app' filestate is reserved for deployed clients
	'Libraries' :{#loop-able keys are not fixed
		'built-in':{
			'Version' : '0.0.1',
			'Patch' :'Alfa'
			}
		},
	'Globals':{#loop-able keys are not fixed
		'Globalsid':{
			'Type':'',
			'Value':''
			}
		},
	'Flows': FlowStructure,
	'ElementStructures':flowElementslist, # if FileState is Flow flowElementslist only include used elements
	'Resourses':{#loop-able keys are not fixed
		'Resourseid': {
			'Name:':'',
			'Type':'',
			'Data':''
			# Resourses are considered object(image and its type may vary
			}
		}
	}

var some_notes
# > Flow is Python function ,
	#(is just a collection of FlowElement) 	#visible in FlowEdit dock and FlowSelect Dock 

# > FlowElement.Element is Python Snippet, 
	#visible in FlowElementSelect Dock 
	#and Constructor.FlowElementManager 
	#(it properties are editable in FlowElementProprertiesEdit)
# > FlowElement.Inheritable are Python Classes,
	#visible in Constructor.FlowElement
# > FlowElement.Errorhandler is Python Exception Handling,
	#visible in in FlowElementProprertiesEdit Dock 
	#and Constructor.FlowElementManager
