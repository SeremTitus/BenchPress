extends Control

var r
func _ready():
	get_window().mode = Window.MODE_MINIMIZED
	var Action = Action.new()
	Action.library_name = "built_in"
	Action.title = "add_var"
	Action.imports.append("time")
	var new_att = Attribute.new()
	new_att.original_name = &"you"
	Action.global_properties.append(new_att)
	Action.code =\
	r"""
	you = 9
	print("Hello Benchpress")
	count = 0
	while count < 20:
		count +=1
		print('LOOP NUM: ', count)
	time.sleep(5)
	"""
	Action.code = Action.code.dedent()
	var ele:ActionCall = ActionCall.new(Action)
	var benchpress = Benchpress.new()
	var ActionCalls:Array[ActionCall] = [ele]
	benchpress.main_Subroutine.add_chidren(ActionCalls)
	benchpress.main_Subroutine.add_chidren(ActionCalls)
	benchpress.globals.append(new_att)
	var run_path = Parser.construct(benchpress,"test")
	r = Runner.new()
	r.py_packet_recieved.connect(pri)
	r.play(run_path)
	print(String.chr(129302))
	
func  pri(vary:Variant):
	print(vary)
