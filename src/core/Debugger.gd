class_name Debugger

var debug_UDPClient: ActionCall
var debug_Subroutine: ActionCall
var debug_Action: ActionCall
var ActionCalls: Array[ActionCall]


func _init(new_references: Unique = Unique.new()):
	# debug_UDPClient
	var new_action: Action = Action.new()
	var new_attribute:Attribute = Attribute.new()
	new_action.title = "debug_UDPClient"
	new_action.library_name = "debugger"
	new_attribute.original_name = "client_socket"
	new_attribute.align(new_references,"globals")
	new_action.global_properties.append(new_attribute)
	new_action.imports.append("sys")
	new_action.imports.append("socket")
	new_action.code =\
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
	new_action.code = new_action.code.dedent()
	debug_UDPClient = ActionCall.new(new_action)
	ActionCalls.append(debug_UDPClient)
	# debug_Subroutine
	new_action = Action.new()
	var prop_1:Attribute = Attribute.new()
	var prop_2:Attribute = Attribute.new()
	var prop_3:Attribute = Attribute.new()
	prop_1.original_name = "Subroutine_name"
	prop_2.original_name = "step"
	prop_3.original_name = "globals_changed"
	new_action.title = "debug_Subroutine"
	new_action.library_name = "debugger"
	new_action.properties.append_array([prop_1,prop_2,prop_3])
	new_action.global_properties.append(new_attribute)
	new_action.imports.append("sys")
	new_action.imports.append("json")
	new_action.code =\
	r"""
	return_globals_changed = {}
	for global_var in globals_changed:
		return_globals_changed[global_var] = globals()[global_var]
	data_to_send = {
		"Type": "DebugSubroutine",
		"FilePath": sys.argv[0],
		"SubroutineName": Subroutine_name,
		"Step": step,
		"GlobalsChanged":return_globals_changed,
		}
	json_data = json.dumps(data_to_send)
	try:
		client_socket.sendall(json_data.encode())
	except:
		print("Socket Conection Failed")
	"""
	new_action.code = new_action.code.dedent()
	debug_Subroutine = ActionCall.new(new_action)
	ActionCalls.append(debug_Subroutine)
	# debug_Action
	new_action = Action.new()
	prop_1 = Attribute.new()
	prop_1.original_name = "library_name"
	prop_2 = Attribute.new()
	prop_2.original_name = "title_name"
	prop_3 = Attribute.new()
	prop_3.original_name = "exception"
	new_action.title = "debug__Action"
	new_action.library_name = "debugger"
	new_action.properties.append_array([prop_1,prop_2,prop_3])
	new_action.global_properties.append(new_attribute)
	new_action.imports.append("sys")
	new_action.imports.append("json")
	new_action.code =\
	r"""
	data_to_send = {
		"Type": "DebugSubroutine",
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
	new_action.code = new_action.code.dedent()
	debug_Action = ActionCall.new(new_action)
	ActionCalls.append(debug_Action)

func get_required_imports() -> PackedStringArray:
	var imports:PackedStringArray = []
	for action_call in ActionCalls:
		imports.append_array(action_call.action.imports)
	return imports

func get_required_globals() -> Array[Attribute]:
	var globals: Array[Attribute] = []
	for action_call in ActionCalls:
		globals.append_array(action_call.global_properties)
	return globals

func get_required_Actions() -> Array[Action]:
	var Actions:Array[Action] = []
	for action_call in ActionCalls:
		Actions.append(action_call.action)
	return Actions

func get_debug_UDPClient() -> ActionCall:
	return debug_UDPClient

func get_debug_Subroutine(Subroutine_name: String, step: int, changed_globals: PackedStringArray) -> ActionCall:
	debug_Subroutine.properties[0].value = Subroutine_name
	debug_Subroutine.properties[0].type = Attribute.types.Text
	debug_Subroutine.properties[1].value = step
	debug_Subroutine.properties[2].value = changed_globals
	return debug_Subroutine

func get_debug_Action(library_name: String, title_name: String, exception:String) -> ActionCall:
	debug_Action.properties[0].value = library_name
	debug_Action.properties[0].type = Attribute.types.Text
	debug_Action.properties[1].value = title_name
	debug_Action.properties[1].type = Attribute.types.Text
	debug_Action.properties[2].value = exception
	return debug_Action
