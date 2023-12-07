class_name Parser

static var debugger:Debugger
static var enabled_debugger:bool = true
## profiles -> includes,files
static var references:Unique = Unique.new()
static var compile_to_path:String = "user://build"
static var path:String

## return py file path to be run using [Runner]
static func construct(benchpress:Benchpress,folder_name:String,use_debugger:bool = true) -> String:
	debugger = Debugger.new(benchpress.references)
	enabled_debugger = use_debugger
	if folder_name.is_empty():
		path = compile_to_path + "/" + Unique.unique_name(7)
	else:
		path = compile_to_path + "/" + folder_name
	var dir = DirAccess.open(path)
	if dir:
		DirAccess.make_dir_recursive_absolute(path)
	references.assign_guided("main","files")
	var structures:Array[Structure] = extract_flows(benchpress.flows)
	var source:String = "# " + String.chr(9888) +" No need edit this file, modify in Benchpress Editor " + String.chr(129302)
	if debugger and enabled_debugger :
		references.append_array(debugger.get_required_imports(),"imports")
	source += "\n\n# imports" + generate_imports()
	source += "\n\n# user globals" + generate_globals(benchpress.globals)
	source += "\n\n# element globals" + generate_globals(benchpress.element_globals)
	if debugger and enabled_debugger and not debugger.get_required_globals().is_empty():
		source += "\n\n# debugger globals" + generate_globals(debugger.get_required_globals())
	source += "\n\n# Flows" + generate_flow_function(benchpress.main_flow)
	for flow in benchpress.flows:
		if flow == benchpress.main_flow: continue
		source += "\n\n" + generate_flow_function(flow)
	source += "\n\n# Structures" + generate_functions(structures)
	if debugger and enabled_debugger:
		source += "\n\n# Debugger Structures" + generate_functions(debugger.get_required_structures(), false)
	source += "\n\n# Call main Flow" + generate_init_functions(benchpress.main_flow.title)
	generate_file("main", source)
	return path + "/main.py"

static func extract_flows(flows:Array[Flow]) -> Array[Structure]:
	var structures:Array[Structure] = []
	for flow in flows:
		for child in flow.children_element:
			extract_element(child, structures)
	return structures

static func extract_element(element:Element,structures:Array[Structure] = []) -> Array[Structure]:
	var temp_structures:Array[Structure] = structures
	temp_structures.append(element.structure)
	temp_structures.append_array(element.structure.structure_include)
	references.append_array(element.structure.imports,"imports")
	for structure in temp_structures:
		if not structure in structures:
			structures.append(structure)
	if element.structure.holds_child_element:
		for child in element.children_element:
			extract_element(child, structures)
	return structures

static func  generate_imports() -> String:
	var source:String = ""
	for include in references.get_profile("imports"):
		source += "\nimport " + include
	return source

static func  generate_globals(globals:Array[Attribute]) -> String:
	var source:String = ""
	for global in globals:
		global.ensure_global()
		if  not references.has(global.unique_name, "added_globals"):
			global.ensure_global()
			source += "\n" + global.unique_name + " = None"
			references.assign_guided(global.unique_name, "added_globals")
	return source

static func  generate_flow_function(flow:Flow) -> String:
	var flow_name:String = flow.title
	var source:String = "\ndef " + flow_name + "():"
	var body:String = ""
	var step = 0
	for child in flow.children_element:
		body += "\n" + generate_call(child)
		if enabled_debugger and debugger:
			var changed_globals:PackedStringArray = []
			for global in child.global_properties:
				global.ensure_global()
				changed_globals.append(global.unique_name)
			var debugger_element:Element = debugger.get_debug_flow(flow_name,step,changed_globals)
			body += "\n# debugger call \n" + generate_call(debugger_element)
		step += 1
	source += "\n" + body.erase(0).indent("\t")
	return source

static  func generate_function_name(structure:Structure) -> String:
	var lib_name:String = structure.library_name.strip_edges()
	var title:String = structure.title.strip_edges()
	return lib_name + "_" + title

static  func generate_call(element:Element) -> String:
	if not element or not element.structure:
		return ""
	var source:String = ""
	var call_name:String = generate_function_name(element.structure)
	if element.structure.holds_child_element:
		source += "if " + call_name + "("
		for property in element.properties:
			var value = property.default_value if property.get_value() == null else  property.get_value()
			source += property.original_name + " = " + str(value) + ", "
		if not element.structure.global_properties.is_empty():
			source += "global_output = ["
			for global in element.global_properties:
				global.ensure_global()
				source += '"' + global.unique_name + '", '
			source += "]"
		source += "):"
		var body:String = "\n"
		for child in element.children_element:
			body += generate_call(child)
		source += body.indent("\t")
	else:
		source += call_name + "("
		for property in element.properties:
			var value:Variant = property.default_value if  property.get_value()  == null else  property.get_value()
			if value == null:
				value = "None"
			source += property.original_name + " = " + str(value) + ", "
		if not element.structure.global_properties.is_empty():
			source += "global_output = ["
			for global in element.global_properties:
				global.ensure_global()
				source += '"' + global.unique_name + '", '
			source += "]"
		source += ")"
	return source

static func  generate_functions(structures:Array[Structure],use_try:bool = true) -> String:
	var source:String = ""
	for structure in structures:
		if not structure.code.is_empty():
			var function = "\ndef " + generate_function_name(structure) + "("
			for property in structure.properties:
				function += property.original_name + ","
			if not structure.global_properties.is_empty():
				function += "global_output = []"
			function += "):"
			if use_try:
				var try_block:String = "try:"
				try_block += String("\n" + structure.code_to_parser()).indent("\t")
				try_block += "\nexcept Exception as e:"
				try_block += '\n\tprint(f"An unexpected error occurred: {e}")'
				if debugger and enabled_debugger:
					var debugger_element:Element = debugger.get_debug_structure( \
						structure.library_name,structure.title,"e")
					try_block += "\n\t# debugger call \n\t" + generate_call(debugger_element)
				function += String("\n" + try_block).indent("\t")
			else:
				function += String("\n" + structure.code_to_parser()).indent("\t")
			source += function + "\n"
		for file in structure.file_include:
			var file_name:String = references.assign_guided(file.file_name,"files")
			generate_file(file_name,file.source_code,file.file_extention)
	return source

static func  generate_init_functions(flow_name:String) -> String:
	var source:String = '\nif __name__ == "__main__":'
	if debugger and enabled_debugger:
		var debugger_element:Element = debugger.get_debug_UDPClient()
		source += "\n\t# debugger call \n\t" + generate_call(debugger_element)
	source += String("\n" + flow_name + "()").indent("\t")
	return source

static func  generate_file(file_name:String, source:String, file_extention = "py") -> void:
	var file_path:String = path + "/" + file_name + "." + file_extention
	var new_file:FileAccess = FileAccess.open(file_path,FileAccess.WRITE)
	if not source.is_empty() and new_file:
		new_file.store_string(source)
		new_file.close()
