class_name Debugger

var debug_UDPClient:Element
var debug_flow:Element
var debug_structure:Element
var elements:Array[Element]


func _init(new_references:Unique = Unique.new()):
	# debug_UDPClient
	var new_structure:Structure = Structure.new()
	var new_attribute:Attribute = Attribute.new()
	new_structure.title = "debug_UDPClient"
	new_structure.library_name = "debugger"
	new_attribute.original_name = "client_socket"
	new_attribute.align(new_references,"globals")
	new_structure.global_properties.append(new_attribute)
	new_structure.imports.append("sys")
	new_structure.imports.append("socket")
	new_structure.code =\
	r"""
	if len(sys.argv) > 1:
		address = sys.argv[1].split(':')
		if address[0] == "*" or address[0] == "":
			server_address = ("localhost", int(address[1]))
		else:
			server_address = (address[0], int(address[1]))
		client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		try:
			client_socket.connect(server_address)
		except Exception as e:
			print("Socket Conection Failed:",e)
	"""
	new_structure.code = new_structure.code.dedent()
	debug_UDPClient = Element.new(new_structure)
	elements.append(debug_UDPClient)
	# debug_Flow
	new_structure = Structure.new()
	var prop_1:Attribute = Attribute.new()
	var prop_2:Attribute = Attribute.new()
	var prop_3:Attribute = Attribute.new()
	prop_1.original_name = "flow_name"
	prop_2.original_name = "step"
	prop_3.original_name = "globals_changed"
	new_structure.title = "debug_flow"
	new_structure.library_name = "debugger"
	new_structure.properties.append_array([prop_1,prop_2,prop_3])
	new_structure.global_properties.append(new_attribute)
	new_structure.imports.append("sys")
	new_structure.imports.append("json")
	new_structure.code =\
	r"""
	return_globals_changed = {}
	for global_var in globals_changed:
		return_globals_changed[global_var] = globals()[global_var]
	data_to_send = {
		"Type": "DebugFlow",
		"FilePath": sys.argv[0],
		"FlowName": flow_name,
		"Step": step,
		"GlobalsChanged":return_globals_changed,
		}
	json_data = json.dumps(data_to_send)
	try:
		client_socket.sendall(json_data.encode())
	except:
		print("Socket Conection Failed")
	"""
	new_structure.code = new_structure.code.dedent()
	debug_flow = Element.new(new_structure)
	elements.append(debug_flow)
	# debug_structure
	new_structure = Structure.new()
	prop_1 = Attribute.new()
	prop_1.original_name = "library_name"
	prop_2 = Attribute.new()
	prop_2.original_name = "title_name"
	prop_3 = Attribute.new()
	prop_3.original_name = "exception"
	new_structure.title = "debug__structure"
	new_structure.library_name = "debugger"
	new_structure.properties.append_array([prop_1,prop_2,prop_3])
	new_structure.global_properties.append(new_attribute)
	new_structure.imports.append("sys")
	new_structure.imports.append("json")
	new_structure.code =\
	r"""
	data_to_send = {
		"Type": "DebugFlow",
		"FilePath": sys.argv[0],
		"LibraryName": library_name,
		"TitleName": title_name,
		"Exception": exception
		}
	json_data = json.dumps(data_to_send)
	try:
		client_socket.sendall(json_data.encode())
	except:
		print("Socket Conection Failed")
	"""
	new_structure.code = new_structure.code.dedent()
	debug_structure = Element.new(new_structure)
	elements.append(debug_structure)

func get_required_imports() -> PackedStringArray:
	var imports:PackedStringArray = []
	for element in elements:
		imports.append_array(element.structure.imports)
	return imports

func get_required_globals() -> Array[Attribute]:
	var globals:Array[Attribute] = []
	for element in elements:
		globals.append_array(element.global_properties)
	return globals

func get_required_structures() -> Array[Structure]:
	var structures:Array[Structure] = []
	for element in elements:
		structures.append(element.structure)
	return structures

func get_debug_UDPClient() -> Element:
	return debug_UDPClient

func get_debug_flow(flow_name:String,step:int,changed_globals:PackedStringArray) -> Element:
	debug_flow.properties[0].value = flow_name
	debug_flow.properties[0].type = Attribute.types.Text
	debug_flow.properties[1].value = step
	debug_flow.properties[2].value = changed_globals
	return debug_flow

func get_debug_structure(library_name:String,title_name:String,exception:String) -> Element:
	debug_structure.properties[0].value = library_name
	debug_structure.properties[0].type = Attribute.types.Text
	debug_structure.properties[1].value = title_name
	debug_structure.properties[1].type = Attribute.types.Text
	debug_structure.properties[2].value = exception
	return debug_structure
