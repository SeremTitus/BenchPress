extends Node

var subtype = [] :set=add_item
var value = '' :set=set_value
var propertyName = '' :set=setpropertyName
var displayType = '' :set=displaytype

func displaytype(input):
	displayType = input
	if displayType != '':
		var item = preload("res://scenes/elementUI/PropertiesDispay/variablesLocator.tscn").instantiate()
		item.displayType = displayType
		item.connect('selectedvariable',self,'recivevalue')
		add_child(item)
	
func add_item(input):
	$"%edit".clear()
	for i in input:
		$"%edit".add_item(i)
	
func recivevalue(input):
	set_value(input)

func get_value():
	return $"%edit".get_item_text($"%edit".get_selected_id())

func set_value(newvalue):
	for inx in range($"%edit".get_item_count()):
		if $"%edit".get_item_text(inx) == str(newvalue):
			$"%edit"._select_int(inx)
	
func setpropertyName(newvalue):
	propertyName = newvalue
	$"%lable".text = propertyName

