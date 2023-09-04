extends Node

signal ListingItemChangeMade

var subtype  = 'List'
var displayType = '' :set=displaytype

func displaytype(value):
	displayType = value
	if displayType != '':
		var item = load("res://scenes/elementUI/PropertiesDispay/variablesLocator.tscn").instantiate()
		item.displayType = displayType
		item.connect('selectedvariable',self,'recivevalue')
		add_child(item)
func recivevalue(value):
	$"%value".text +='%'+str(value)+'%'

func _on_TextureRect_gui_input(event):
	if (event is  InputEventMouseButton and  event.get_button_index()==1) and event.pressed: 
		queue_free()

func _on_index_text_entered(_new_text):
	if subtype  == 'Dictionary':
		emit_signal("ListingItemChangeMade",_new_text)

func _on_index_focus_exited():
	if subtype == 'Dictionary' and $"%index".text != '':
		emit_signal("ListingItemChangeMade",$"%index".text)
