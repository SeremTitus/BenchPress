extends Node

var subtype = ''#not implimented
var value = '' :set=set_value
var propertyName = '' :set=setpropertyName
var displayType = '' #not implimented here

func get_value():
	return $"%edit".pressed
func set_value(newvalue):
	value = newvalue
	$"%edit".pressed = bool(value)
func setpropertyName(newvalue):
	propertyName = newvalue
	$"%lable".text = propertyName
