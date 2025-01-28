class_name ActionRegister extends Node # Abstract

var Action_db : Dictionary [String, Action] # LibraryName:Title : Action

func add(new_Action: Action):
	var assigned_name := new_Action.library_name + "_" + new_Action.title
	assert(!Action_db.has(assigned_name), "Action has been already registered.")
	Action_db[assigned_name] = new_Action

func add_reg(new_register: ActionRegister):
	for key in new_register.Action_db:
		add(new_register.Action_db[key])
