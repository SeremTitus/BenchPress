extends Node

var SubroutineActionCallStruct:Dictionary ={
	'Library' : '',
	'Type':'ActionCall',#Inheritable,errorhandler
	'Title' : 'ADD onready varIABLE',
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
		#Placeholder key but Base maybe found in most ActionCalls
		'Base' :{#fixed keys
			'Feature' : '',
			'Code' : '',
			'Properties':{#loop-able keys are not fixed
				#Placeholder key
				'Enter onready variable Name':{#fixed keys
					'variableName':'',
					'Type':'',
					'Display':'',
					'DisplayType':'',
					'DefaultValue':'',
					'InputOutput':''
					}
				}
			}
		}
	}
	
#details
onready var LibraryItem = $"%Library"
onready var TypeItem = $"%Type"
onready var TitleItem = $"%Title"
onready var DescriptionItem = $"%Description"
onready var DocItem = $"%Doc"
onready var IconItem = $"%icon"
onready var GroupPathItem =$"%GroupPath"
onready var DependenciesItem = $"%Dependencies"
onready var InheritItem = $"%Inherit"
onready var IniciatorItem =$"%Iniciator"
onready var AntiIniciatorItem =$"%AntiIniciator"
onready var ParentItem = $"%Parent"
#morphs and properties
onready var morphItems = $"%MorphsList"
onready var propertyItems = $"%propertiesList"

func _ready():
	changesmade()

func changesmade(_change=0):
	propertyItems.callv('morph_temp_list',[])
	SubroutineActionCallStruct = {}
	SubroutineActionCallStruct['Library'] = LibraryItem.text
	SubroutineActionCallStruct['Type'] = TypeItem.get_item_text(TypeItem.get_selected_id())
	SubroutineActionCallStruct['Title'] = TitleItem.text
	SubroutineActionCallStruct['Description'] = DescriptionItem.text
	SubroutineActionCallStruct['Doc'] = DocItem.text
	SubroutineActionCallStruct['Icon'] = IconItem.texture
	SubroutineActionCallStruct['GroupPath'] = GroupPathItem.text
	SubroutineActionCallStruct['Dependencies'] =strtoarray(DependenciesItem.text)
	SubroutineActionCallStruct['Inherit'] = strtoarray(InheritItem.text)
	SubroutineActionCallStruct['Iniciator'] = strtoarray(IniciatorItem.text)
	SubroutineActionCallStruct['AntiIniciator'] = strtoarray(AntiIniciatorItem.text)
	SubroutineActionCallStruct['Parent'] = ParentItem.pressed
	SubroutineActionCallStruct['morphs'] = {}
	for morph in morphItems.get_children():
		if morph.name == 'lable': 
			continue
		var morph_data = morph.callv('get_morph_data',[])
		if morph_data.empty(): continue
		SubroutineActionCallStruct['morphs'][morph_data[0]]={}
		SubroutineActionCallStruct['morphs'][morph_data[0]]['Feature']=morph_data[1]
		SubroutineActionCallStruct['morphs'][morph_data[0]]['Code']=morph_data[2]
		SubroutineActionCallStruct['morphs'][morph_data[0]]['Properties']={}
		var properties_data = propertyItems.callv('get_properties_data',[morph_data[0]])
		for key in properties_data:
			SubroutineActionCallStruct['morphs'][morph_data[0]]['Properties'][properties_data[key][0]] = {}
			SubroutineActionCallStruct['morphs'][morph_data[0]]['Properties'][properties_data[key][0]]['variableName'] = properties_data[key][1]
			SubroutineActionCallStruct['morphs'][morph_data[0]]['Properties'][properties_data[key][0]]['Type'] = properties_data[key][2]
			SubroutineActionCallStruct['morphs'][morph_data[0]]['Properties'][properties_data[key][0]]['Display'] = properties_data[key][3]
			SubroutineActionCallStruct['morphs'][morph_data[0]]['Properties'][properties_data[key][0]]['DisplayType'] = properties_data[key][4]
			SubroutineActionCallStruct['morphs'][morph_data[0]]['Properties'][properties_data[key][0]]['DefaultValue'] = properties_data[key][5]
			SubroutineActionCallStruct['morphs'][morph_data[0]]['Properties'][properties_data[key][0]]['InputOutput'] = properties_data[key][6]
	print('\n'+str(SubroutineActionCallStruct)+'\n')
	#update preview
	

func strtoarray(text):
	var rArray :Array = []
	var newtext = ''
	for i in text:
		if i == ',':
			rArray.append(newtext)
			newtext = ''
			continue
		newtext = i
	return rArray
	
	
func _on_Doc_text_changed():
	changesmade(0)
