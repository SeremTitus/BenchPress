extends MarginContainer
#onready var content = $'Control/content'
var ElementStructureReference = '' :set=set_ElementStructureReference
var ElementProperties :Dictionary = {}

func set_ElementStructureReference(newvalue):
	ElementStructureReference = newvalue
	create_prop()
	
func create_prop(ElementStructure = Global.LibraryElementStructure[ElementStructureReference]):
	for child in $"%morph_data".get_children():
		child.queue_free()
	$"%Title".text = ElementStructure['Title']
	$"%doc".text = ElementStructure['Doc']
	for morphkey in ElementStructure['Morphs']:
		var morph_data =load("res://scenes/elementUI/morph_data.tscn").instantiate()
		morph_data.morph = morphkey
		morph_data.active = false
		for i in ElementProperties['ActiveMorphs']:
			if i == morphkey:
				morph_data.active=true
		morph_data.Properties_set_values = ElementProperties['Properties']
		morph_data.Properties = ElementStructure['Morphs'][morphkey]['Properties']
		$"%parameter".add_child(morph_data)
		createOutputVar(ElementStructure)

func createOutputVar(ElementStructure=Global.LibraryElementStructure[ElementStructureReference]):
	$"%OutputVar".visible = false
	for child in $"%OutputVar".get_children():
		if child.name == 'lable': continue
		child.queue_free()
	for morphkey in ElementStructure['Morphs']:
		for propertyName in ElementStructure['Morphs'][morphkey]['Properties']:
			if ElementStructure['Morphs'][morphkey]['Properties'][propertyName]['InputOutput'] == 'Output':
				$"%OutputVar".visible = true
				var item =$"%flowVariables".duplicate()
				item.visible=true
				item.name = propertyName
				for glovar in Global.FlowVariables:
					if propertyName == glovar: 
						propertyName = glovar
				if ElementProperties['Properties'].has(propertyName):
					propertyName = ElementProperties['FlowVariable'][propertyName]
				item.text = propertyName
				$"%OutputVar".add_child(item)

func get_value():
	return $"%morph_data".call('get_value')	

