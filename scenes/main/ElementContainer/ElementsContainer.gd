extends VBoxContainer

var ActionCall = preload("res://scenes/ActionCallUI/ActionCall.tscn")
var group = preload("res://scenes/main/ActionCallContainer/ActionCallsContainerGroup.tscn")

func _ready():
	# warning-ignore:return_value_discarded
	#Global.connect('LibraryActionCallAction_Constructed',Callable(self,'filter_ActionCalls'))
	generate_list_ActionCalls()
	
func generate_list_ActionCalls(LibraryActionCallAction = {}):# Global.LibraryActionCallAction):
	var listExistinggroups ={}#path:object
	for child in $"%ActionCalls".get_children():
		child.queue_free()
	for path in LibraryActionCallAction.keys():
		var ActionCallActionReference = path
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
				var newgroup = group.instantiate()
				newgroup.LabelName = groupname
				if addItemHere != null:
					addItemHere.add_item(newgroup)
				else:
					$"%ActionCalls".add_child(newgroup)
				addItemHere = newgroup
				listExistinggroups[newCommulativePath] = newgroup
		var newitem = ActionCall.instantiate()
		newitem.ActionCallActionReference = {}#ActionCallActionReference
		if addItemHere != null:
			addItemHere.add_item(newitem)
		else:
			$"%ActionCalls".add_child(newitem)

func filter_ActionCalls(new_text):
	var LibraryActionCallAction = {}#Global.LibraryActionCallAction.duplicate(true)
	if new_text == '' : 
		generate_list_ActionCalls()
		return
	for path in LibraryActionCallAction.keys():
		var key = path
		path = Array(path.split('/',true,0))
		path.pop_front()#remove unique name
		var erase = true
		for comparewith in path:
			if new_text in comparewith: erase = false
		if erase:LibraryActionCallAction.erase(key)
	generate_list_ActionCalls(LibraryActionCallAction)
