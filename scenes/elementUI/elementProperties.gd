extends MarginContainer
#onready var content = $'Control/content'
var ActionCall_ActionReference = '' :set=set_ActionCall_ActionReference
var ActionCallProperties :Dictionary = {}

func set_ActionCall_ActionReference(newvalue):
	ActionCall_ActionReference = newvalue
	create_prop()
	
func create_prop(ActionCall_Action = {}):#Global.LibraryActionCall_Action[ActionCall_ActionReference]):
	for child in $"%morph_data".get_children():
		child.queue_free()
	$"%Title".text = ActionCall_Action['Title']
	$"%doc".text = ActionCall_Action['Doc']
	for morphkey in ActionCall_Action['Morphs']:
		var morph_data =load("res://scenes/ActionCallUI/morph_data.tscn").instantiate()
		morph_data.morph = morphkey
		morph_data.active = false
		for i in ActionCallProperties['ActiveMorphs']:
			if i == morphkey:
				morph_data.active=true
		morph_data.Properties_set_values = ActionCallProperties['Properties']
		morph_data.Properties = ActionCall_Action['Morphs'][morphkey]['Properties']
		$"%parameter".add_child(morph_data)
		createOutputVar(ActionCall_Action)

func createOutputVar(ActionCall_Action={}):#Global.LibraryActionCall_Action[ActionCall_ActionReference]):
	$"%OutputVar".visible = false
	for child in $"%OutputVar".get_children():
		if child.name == 'lable': continue
		child.queue_free()
	for morphkey in ActionCall_Action['Morphs']:
		for propertyName in ActionCall_Action['Morphs'][morphkey]['Properties']:
			if ActionCall_Action['Morphs'][morphkey]['Properties'][propertyName]['InputOutput'] == 'Output':
				$"%OutputVar".visible = true
				var item =$"%SubroutineVariables".duplicate()
				item.visible=true
				item.name = propertyName
				for glovar in []:#Global.SubroutineVariables:
					if propertyName == glovar: 
						propertyName = glovar
				if ActionCallProperties['Properties'].has(propertyName):
					propertyName = ActionCallProperties['SubroutineVariable'][propertyName]
				item.text = propertyName
				$"%OutputVar".add_child(item)

func get_value():
	return $"%morph_data".call('get_value')	

