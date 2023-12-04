class_name BenchpressParser extends RefCounted

var with_benchpress_version: String = "1"
var error: PackedStringArray = []
var debug_code: String = ""
var debug_dependency: PackedStringArray = []

func benchpress_to_py(benchpress:Benchpress,\
	global_library:GlobalLibrary = GlobalLibrary.new()) -> String:
	var output:String = ""
	if benchpress.benchpress_version != with_benchpress_version:
		error.append("benchpress file is out of date,try reopening in Editor")
		return output
	var all_dependencies: PackedStringArray = debug_dependency
	var global_variables: Dictionary = benchpress.global_variables
	var all_functions: PackedStringArray = []
	for flow in benchpress.flows.values():
		var function_lines: PackedStringArray = []
		for element in flow.elements:
			function_lines = element_to_py(flow,element,global_library)
		all_functions.append(py_function(flow.title,function_lines))
	output = py_full(all_dependencies,global_variables,all_functions)
	return output

func  py_full(all_dependencies: PackedStringArray, global_variables: Dictionary,\
	all_functions: PackedStringArray) -> String:
	var output:String = ""
	output += py_dependencies(all_dependencies)
	for attribute in global_variables.values():
		var variable:String = str(attribute.value)
		if variable == null or variable == '':
			continue
		variable.replacen("$","")
		output += '\n' + variable
	output += '\n' + py_body(all_functions)
	return output

func  py_dependencies(all_dependencies: PackedStringArray) -> String:
	var output:String = ""
	for import in all_dependencies:
		output += '\nimport ' + import
	return output

func py_body(all_functions: PackedStringArray) -> String:
	var output:String = ""
	for def in all_functions:
		output += '\n' + def
	return output

func py_function(function_name:String,function_lines: PackedStringArray) -> String:
	var output:String = ""
	for line in function_lines:
		output += '\n' + debug_code
		output += '\n' + line
	output.indent('\t')
	output.begins_with('\ndef ' + function_name.strip_escapes() + '():\n')
	return output

func py_line(element:Element, element_structure:ElementStructure,indent:int)\
	 -> String:
	var code = element_structure.code
	for property_name in element_structure.properties:
		var attribute:Attribute = element_structure.properties.property_name\
			if element.properties.has(property_name) else element.properties.property_name
		var target = str(attribute.owner)
		var replace = str(attribute.value)
		code = code_morph(code,target,replace)
	for attribute in element.output_variables:
		var target = str(attribute.owner)
		var replace = str(attribute.value)
		code = code_morph(code,target,replace)
	var indent_prefix:String = ""
	for i in range(indent):
		indent_prefix += "\t"
	code.indent(indent_prefix)
	return code

func code_morph(code:String, target:String, replace:String) -> String:
	replace.replacen("$","")
	return code.replacen(target, replace)

func element_to_py(flow:Flow,element:Element,global_library:GlobalLibrary,\
	indent:int = 0,function_lines:PackedStringArray = []) -> PackedStringArray:
	var element_structure:ElementStructure = global_library.library[element.link_library_path]
	function_lines.append(py_line(element,element_structure,indent))
	if element_structure.holds_child_element and\
		flow.elements_children.has(element):
		indent += 1
		for child_element in flow.elements_children[element]:
			element_structure = global_library.library[child_element.link_library_path]
			function_lines.append(str(element_to_py(flow,element,global_library,indent)))
		indent -= 1
	return function_lines
