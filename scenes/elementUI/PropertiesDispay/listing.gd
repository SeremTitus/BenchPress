extends Node

var listingitem = preload("res://scenes/elementUI/PropertiesDispay/ListingItem.tscn")
var listingItemSiblingNo =-1

var subtype = 'List'#'Dictionary'
var value = {} :set=set_value
var propertyName = '' :set=setpropertyName
var displayType =''

func setpropertyName(newvalue):
	propertyName = newvalue
	$"%lable".text = propertyName

func set_value(newvalue):
	value = newvalue
	if not value.empty():
		for child in $"%listing".get_children():
			if child.name == 'lable':continue
			child.queue_free()
		for i in value:
			var item = listingitem.instantiate()
			item.subtype  = subtype
			if displayType != '':
				item.displayType = displayType
			item.get_child(0).get_child(0).text = str(i)
			item.get_child(1).get_child(0).text = str(value[i])
			if subtype  == 'List':
				item.get_child(0).get_child(0).editable = false
			$"%listing".add_child(item)
	
func get_value():
	var setvalue = {}
	for child in $"%listing".get_children():
		if child.name == 'lable':continue
		if child.get_child(0).get_child(0).text == 'lable' or child.get_child(0).get_child(0).text != '':
			setvalue[str(child.get_child(0).get_child(0).text)] = child.get_child(1).get_child(0).text
	return  setvalue
	
func _on_add_button_down():
	var item = listingitem.instantiate()
	item.subtype  = subtype
	if displayType != '':
		item.displayType = displayType
	if subtype  == 'List':
		listingItemSiblingNo+=1
		item.get_child(0).text = str(listingItemSiblingNo)
		item.get_child(0).editable = false	
	item.connect("ListingItemChangeMade",on_itemchanged)
	$"%listing".add_child(item)
	
func on_itemchanged(_new_text):
	if subtype  == 'Dictionary':
		set_value(get_value())
	
