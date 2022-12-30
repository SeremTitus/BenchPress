extends Node
#onready var content = $'Control/content'
var flowElementStruct:Dictionary ={
	'Library' : '',
	'Type':'Element',#Inheritable,errorhandler
	'Title' : 'ADD VARIABLE',
	'Description' : '',
	'Doc':'Doc Example',
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
					'VariableName':'n',
					'Type':'n',
					'Display':'Options',
					'DisplayType':'n',
					'subtype':['s','t'],
					'DefaultValue':'',
					'InputOutput':'Input'
					},
				'Static':{#fixed keys
					'VariableName':'n',
					'Type':'n',
					'Display':'Options',
					'DisplayType':'n',
					'subtype':['s','t'],
					'DefaultValue':'',
					'InputOutput':'Output'
					}
				}
			}
		}
	}
var Properties_set_values = {#loop-able keys are not fixed
				'Edited_Properties_Name' :'Value'#set_values
				}
var enabled_morphs = ['Base']
var linkingID = ''

func _ready():
	pass
	#create_prop()

func create_prop():
	for child in $"%morph_data".get_children():
		child.queue_free()
	$"%Title".text = flowElementStruct['Title']
	$"%doc".text = flowElementStruct['Doc']
	for morphkey in flowElementStruct['Morphs']:
		var morph_data =load("res://scenes/elementUI/morph_data.tscn").instance()
		morph_data.morph = morphkey
		morph_data.active = false
		for i in enabled_morphs:
			if i == morphkey:
				morph_data.active=true
		morph_data.Properties_set_values=Properties_set_values
		morph_data.Properties =flowElementStruct['Morphs'][morphkey]['Properties']
		$"%parameter".add_child(morph_data)
		createOutputVar()

func createOutputVar():
	$"%OutputVar".visible = false
	for child in $"%OutputVar".get_children():
		if child.name == 'lable': continue
		child.queue_free()
	for morphkey in flowElementStruct['Morphs']:
		for propertyName in flowElementStruct['Morphs'][morphkey]['Properties']:
			if flowElementStruct['Morphs'][morphkey]['Properties'][propertyName]['InputOutput'] == 'Output':
				$"%OutputVar".visible = true
				var item =$"%flowVariables".duplicate()
				item.visible=true
				item.name = propertyName
				for glovar in Global.FlowVariables:
					if propertyName == glovar: 
						propertyName = glovar
				
				if Properties_set_values.has(propertyName):
					propertyName = Properties_set_values[propertyName]
				item.get_child(0).text = propertyName
				$"%OutputVar".add_child(item)

