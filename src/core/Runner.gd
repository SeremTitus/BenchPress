class_name Runner extends RefCounted

signal py_packet_recieved(packet:Variant)
const UDP_port:int = 9574

var server:UDPServer = UDPServer.new()
var python_path:String ='python.exe'
var running:Dictionary = {} # filePath : pID
var console_output:Dictionary = {} # filePath : output
var process:bool = true
var process_timer:TrueTimmer = TrueTimmer.new()
var address:String = "*"
var threads:Array[Thread] = []

func _init(new_address:String = "*") -> void:
	address = new_address
	process_timer.timeout.connect(start_timer)
	start_listening()
	start_timer()
	
func  start_timer():
	process_tick()
	process_timer.start(1.0)

func process_tick() -> void:
	end_dead_thread()
	if not process:
		return
	server.poll()
	if server.is_connection_available():
		var peer:PacketPeerUDP = server.take_connection()
		var packet_str:String = peer.get_packet().get_string_from_utf8()
		var json:JSON = JSON.new()
		var error:Error = json.parse(packet_str)
		var packet:Variant
		if error == OK:
			packet = json.data
			py_packet_recieved.emit(packet)

func start_listening() -> void:
	server.listen(UDP_port,address)
	process = true

func stop_listening() -> void:
	server.stop()
	process = false

func play(file_path:String) -> Error:
	if not file_path.get_extension() == "py": return ERR_FILE_BAD_PATH
	file_path = ProjectSettings.globalize_path(file_path)
	var socket_url:String = address + ":" + type_convert(UDP_port,TYPE_STRING)
	var args:PackedStringArray = [file_path, socket_url]
	var new_thread:Thread = Thread.new()
	var error = new_thread.start(create_process.bindv([file_path,args]))
	if error == OK:
		threads.append(new_thread)
		running[file_path] = int(new_thread.get_id())
	return error

func  end_dead_thread() -> void:
	for thread in threads:
		if not thread.is_alive():
			thread.wait_to_finish()
			threads.erase(thread)

func create_process(file_path:String,args:PackedStringArray):
	console_output[file_path] = []
	OS.execute(python_path,args,console_output[file_path],true,false)
	if not console_output[file_path].is_empty():
		print(console_output[file_path][0].indent(String.chr(129302)))
	running.erase(file_path)
	console_output.erase(file_path)
