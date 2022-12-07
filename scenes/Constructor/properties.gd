extends Node

onready var item = preload("res://scenes/Constructor/properties_template.tscn")


func _on_Add_button_down():
	var propitem = item.instance()
	propitem.connect("changesmade",$"../../../../../../../../../../..","changesmade")
	add_child(propitem)
	morph_temp_list()

func get_properties_data(morph):
	var properties_data:Dictionary = {}
	for property in get_children():
		if property.name == 'lable':continue
		var prop_list = property.callv('get_property_list',[])
		if  not prop_list.empty() and morph == prop_list[2]:
			prop_list.remove(2)
			if properties_data.empty():
				properties_data[0]= prop_list
			else:
				properties_data[properties_data.keys().back()+1]=prop_list
	return properties_data
	

func morph_temp_list():
	var morph_list:Array =[]
	for morph in $"%MorphsList".get_children():
		if morph.get_child(0).get_child(0).name == 'lable':continue
		var val = morph.callv('get_morph_data',[])
		if not val.empty():
			morph_list.append(val[0])
	for property in get_children():
		if property.name == 'lable':continue
		property.callv('update_Morph',[morph_list])
