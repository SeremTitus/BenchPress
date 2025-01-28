extends VBoxContainer

var morph = '' :set=set_subtitle
var active = false :set=_on_active_toggled
var Properties_set_values = {#loop-able keys are not fixed
				'Edited_Properties_Name' :'Value'#set_values
				}
var Properties= {#loop-able keys are not fixed
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
				} :set=adding_properties

var propertiesDisplay ={
'LineEdit' :'res://scenes/ActionCallUI/PropertiesDispay/LineEdit.tscn',
'RadiButton':"res://scenes/ActionCallUI/PropertiesDispay/RadioButton.tscn",
'Options' : "res://scenes/ActionCallUI/PropertiesDispay/Option.tscn",
'TextEdit' : "res://scenes/ActionCallUI/PropertiesDispay/TextEdit.tscn",
'List' : "res://scenes/ActionCallUI/PropertiesDispay/list.tscn",
'Dictionary' : "res://scenes/ActionCallUI/PropertiesDispay/list.tscn"
}

func adding_properties(input):
	Properties = input
	for child in $"%content".get_children():
		child.queue_free()
	for propertyName in Properties:
		if Properties[propertyName]['InputOutput'] == 'Input':
			var value =''
			if Properties_set_values.has(propertyName):value = Properties_set_values[propertyName]
			if propertiesDisplay.has(Properties[propertyName]['Display']):
				var subtype = Properties[propertyName]['subtype']
				add_item(propertiesDisplay[Properties[propertyName]['Display']],propertyName,Properties[propertyName]['DisplayType'],Properties[propertyName]['DefaultValue'],value,subtype)				

func set_subtitle(subtitle):
	morph = subtitle
	if subtitle == 'Base':
		subtitle = 'Select Properties'
		$"%content".visible = true
		$"%active".visible = false
	$"%subtitle".text = subtitle

func get_value():
	var values = {}
	for child in $"%content".get_children():
		values[child.propertyName] = child.get_value()
	return values

func _on_active_toggled(button_pressed):
	active = button_pressed
	$"%content".visible = button_pressed

func add_item(instpath,propertyName,displayType,defaultvalue='',value='',subtype=''):
	var item = load(instpath).instantiate()
	item.propertyName = propertyName
	item.displayType = displayType
	item.subtype = subtype
	item.value = defaultvalue
	if value != '':
		item.value = value
	$"%content".add_child(item)
