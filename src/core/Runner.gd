class_name PyRunner extends Node

signal py_packet_recieved(packet:Variant)
const UDP_port = 9574

var server:UDPServer = UDPServer.new()
var is_broadcasting := false
var python_path:String ='python.exe'
var running:Dictionary = {}#unique_name:[pID,filePath]
var unique_ref:UniqueReference = UniqueReference.new()

func _process(delta):
	server.poll()
	if server.is_connection_available():
		var peer:PacketPeerUDP = server.take_connection()
		var packet_str:String = peer.get_packet().get_string_from_utf8()
		var json:JSON = JSON.new()
		var error:Error = json.parse(packet_str)
		var packet:Array = []
		if error == OK:
			packet = json.data
			if packet is Array:
				running[packet[0].UniqueName].append(peer)
			py_packet_recieved.emit(packet)

func start_listening():
	server.listen(UDP_port)
	set_process(true)
	is_broadcasting = true

func stop_listening():
	server.stop()
	set_process(false)
	is_broadcasting = false

func play(file_path:String) -> int:
	if not file_path.get_extension() == ".py": return -1
	var unique_name:String = unique_ref.assign()
	var arg:Array = [unique_name]#pass unique_name,socket url
	var pID:int = OS.create_process(python_path,arg)
	if not pID == -1:
		running[unique_name] = [pID, file_path]
	return pID

func end(unique_name:String) -> void:
	OS.kill(running[unique_name][0])
