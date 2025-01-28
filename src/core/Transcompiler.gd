class_name Transcompiler

var _debugger: Debugger
## profiles -> includes,files
var _references: Unique = Unique.new()

## return Source Script from a benchpress
func to_python(benchpress: Benchpress) -> String:
	_debugger = Debugger.new(benchpress.references)
	
	var actions := get_Actions(benchpress.subroutines)
	var source: String = "# " + String.chr(9888) +" No need edit this file, modify in Benchpress Editor " + String.chr(129302)
	source += "\n\n# imports" + generate_imports(actions + _debugger.get_required_Actions())
	source += "\n\n# user globals" + generate_globals(benchpress.globals)
	source += "\n\n# ActionCall globals" + generate_globals(benchpress.get_all_ActionCall_globals())
	source += "\n\n# debugger globals" + generate_globals(_debugger.get_required_globals())
	source += "\n\n# Subroutines" + generate_Subroutine_function(benchpress.main_subroutine)
	for Subroutine in benchpress.subroutines:
		if Subroutine == benchpress.main_subroutine: continue
		source += "\n\n" + generate_Subroutine_function(Subroutine)
	source += "\n\n# Actions" + generate_functions(actions)
	source += "\n\n# _debugger Actions" + generate_functions(_debugger.get_required_Actions(), false)
	source += "\n\n# Call main Subroutine" + generate_init_functions(benchpress.main_subroutine.title)
	return source

func get_Actions(action_calls: Array, initial_actions: Array[Action] = []) -> Array[Action]:
	for action_call in action_calls:
		action_call as ActionCall
		if not action_call.is_enabled: continue
		if action_call.action and not initial_actions.has(action_call.action):
			initial_actions.append(action_call.action)
			for call_line in action_call.action.inter_struture_calls:
				get_Actions([action_call.action.inter_struture_calls[call_line]], initial_actions)
		get_Actions(action_call.children_action_call, initial_actions)
	return initial_actions

func generate_imports(Actions: Array[Action]) -> String:
	var source: String
	var imports: PackedStringArray
	for Action in Actions:
		for import in Action.imports:
			if not imports.has(import):
				imports.append(import)
	for import in imports:
		source += "\nimport " + import
	return source

func generate_globals(globals: Array[Attribute]) -> String:
	var source: String
	for global in globals:
		global.ensure_global()
		if  not _references.has(global.unique_name, "added_globals"):
			global.ensure_global()
			source += "\n" + global.unique_name + " = None"
			_references.assign_guided(global.unique_name, "added_globals")
	return source

func generate_Subroutine_function(subroutine: Subroutine) -> String:
	var subroutine_name: String = subroutine.title
	var source:String = "\ndef " + subroutine_name + "():"
	var body:String = ""
	var step = 0
	if subroutine.children_action_call.is_empty():
		return source + "\n\tpass"
	for child in subroutine.children_action_call:
		if not child.is_enabled:
			step += 1
			continue
		body += "\n" + generate_call(child)
		var changed_globals:PackedStringArray = []
		for global in child.global_properties:
			global.ensure_global()
			changed_globals.append(global.unique_name)
		var debugger_action_call: ActionCall = _debugger.get_debug_Subroutine(subroutine_name,step,changed_globals)
		body += "\n# debugger call \n" + generate_call(debugger_action_call)
	source += "\n" + body.erase(0).indent("\t")
	return source

func generate_function_name(action: Action) -> String:
	var lib_name:String = action.library_name.strip_edges()
	var title:String = action.title.strip_edges()
	return lib_name + "_" + title

func generate_call(action_call: ActionCall) -> String:
	if not action_call or not action_call.action:
		return ""
	var source: String
	var call_name := generate_function_name(action_call.action)
	if action_call.action.holds_children:
		var start_keyword = "while" if action_call.action.loop_determiner else "if"
		source += start_keyword + " " + call_name + "("
		for property in action_call.properties:
			var value = property.get_value()
			source += property.original_name + " = " + str(value) + ", "
		if not action_call.action.global_properties.is_empty():
			source += "global_output = ["
			for global in action_call.global_properties:
				global.ensure_global()
				source += '"' + global.unique_name + '", '
			source += "]"
		source += "):"
		var body := "\n"
		if action_call.children_action_call.is_empty():
			body += "pass"
		for child in action_call.children_action_call:
			if not child.is_enabled: continue
			body += generate_call(child)
		source += body.indent("\t")
	else:
		source += call_name + "("
		for property in action_call.properties:
			var value:Variant = property.get_value()
			if value == null:
				value = "None"
			source += property.original_name + " = " + str(value) + ", "
		if not action_call.action.global_properties.is_empty():
			source += "global_output = ["
			for global in action_call.global_properties:
				global.ensure_global()
				source += '"' + global.unique_name + '", '
			source += "]"
		source += ")"
	return source

func generate_functions(Actions: Array[Action],use_try:bool = true) -> String:
	var source: String
	for action in Actions:
		if not action.code.is_empty():
			var function = "\ndef " + generate_function_name(action) + "("
			for property in action.properties:
				function += property.original_name + ","
			if not action.global_properties.is_empty():
				function += "global_output = []"
			function += "):"
			if action.is_in_gd:
				# TODO : implement call in Debugger
				function += "\n\t# call gd execute \n\t" + "pass"
				continue
			if use_try:
				var try_block:String = "try:"
				var inter_calls: Dictionary[int, String]
				for call_id in action.inter_struture_calls:
					inter_calls[call_id] = generate_call(action.inter_struture_calls[call_id])
				try_block += String("\n" + action.code_to_parser(inter_calls)).indent("\t")
				try_block += "\nexcept Exception as e:"
				try_block += '\n\tprint(f"An unexpected error occurred: {e}")'
				var debugger_ActionCall:ActionCall = _debugger.get_debug_Action(action.library_name, action.title, "e")
				try_block += "\n\t# debugger call \n\t" + generate_call(debugger_ActionCall)
				function += String("\n" + try_block).indent("\t")
			else:
				function += String("\n" + action.code_to_parser()).indent("\t")
			source += function + "\n"
	return source

func generate_init_functions(Subroutine_name: String) -> String:
	var source:String = '\nif __name__ == "__main__":'
	var debugger_ActionCall:ActionCall = _debugger.get_debug_UDPClient()
	source += "\n\t# debugger call \n\t" + generate_call(debugger_ActionCall)
	source += String("\n" + Subroutine_name + "()").indent("\t")
	return source

static func create_file(file_path: String, source: String) -> Error:
	file_path = ProjectSettings.globalize_path(file_path)
	var base_path := file_path.get_base_dir()
	if not source.is_empty() and DirAccess.make_dir_recursive_absolute(base_path) == OK:
		var new_file := FileAccess.open(file_path,FileAccess.WRITE)
		if new_file:
			new_file.store_string(source)
			new_file.close()
			return OK
	return FAILED
