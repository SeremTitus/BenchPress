extends Control

var element = preload("res://scenes/elementUI/element.tscn")
var group = preload("res://scenes/main/ElementContainer/ElementsContainerGroup.tscn")

func _ready():
	# warning-ignore:return_value_discarded
	Global.connect('LibraryElementStructure_Constructed',Callable(self,'filter_elements'))
	generate_list_Elements()
	
func generate_list_Elements(LibraryElementStructure = Global.LibraryElementStructure):
	var listExistinggroups ={}#path:object
	for child in $"%elements".get_children():
		child.queue_free()
	for path in LibraryElementStructure.keys():
		var ElementStructureReference = path
		path = Array(path.split('/',true,0))
		path.pop_front()#remove unique name
		path.pop_back()#remove item name
		var addItemHere = null
		var newCommulativePath = ''
		for groupname in path:
			newCommulativePath +='/'+groupname
			if listExistinggroups.has(newCommulativePath):
				addItemHere = listExistinggroups[newCommulativePath]
			else:
				var newgroup = group.instance() 
				newgroup.LabelName = groupname
				if addItemHere != null:
					addItemHere.add_item(newgroup)
				else:
					$"%elements".add_child(newgroup)
				addItemHere = newgroup
				listExistinggroups[newCommulativePath] = newgroup
		var newitem = element.instance()
		newitem.ElementStructureReference = ElementStructureReference
		if addItemHere != null:
			addItemHere.add_item(newitem)
		else:
			$"%elements".add_child(newitem)

func filter_elements(new_text):
	var LibraryElementStructure = Global.LibraryElementStructure.duplicate(true)
	if new_text == '' : 
		generate_list_Elements()
		return
	for path in LibraryElementStructure.keys():
		var key = path
		path = Array(path.split('/',true,0))
		path.pop_front()#remove unique name
		var erase = true
		for comparewith in path:
			if new_text in comparewith: erase = false
		if erase:LibraryElementStructure.erase(key)
	generate_list_Elements(LibraryElementStructure)
