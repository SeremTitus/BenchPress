extends BoxContainer

var subtype = ''#not implimented
var value = '' :set=set_value
var propertyName = '' :set=setpropertyName
var displayType = '' :set=displaytype

func displaytype(input):
	displayType =input
	if displayType != '':
		var item = load("res://scenes/ActionCallUI/PropertiesDispay/variablesLocator.tscn").instantiate()
		item.displayType = displayType
		item.connect('selectedvariable',recivevalue)
		add_child(item)
	
func recivevalue(input):
	$"%edit".text +='%'+str(input)+'%'

func get_value():
	return $"%edit".text
func set_value(newvalue):
	value = newvalue
	$"%edit".text = value
func setpropertyName(newvalue):
	propertyName = newvalue
	$"%lable".text = propertyName
