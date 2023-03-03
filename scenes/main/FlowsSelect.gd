extends Control


onready var flowname = preload("res://scenes/main/FlowSelectName.tscn")
var content
func _ready():
	# warning-ignore:return_value_discarded
	Global.connect("current_Project_changed",self,'generate_flow_select_list')
	generate_flow_select_list()
	
func generate_flow_select_list(current_project =Global.current_project):
	for child in $"%Content".get_children():
		child.queue_free()
	var flowNames = current_project.Flows.keys()
	for i in flowNames:
		var newflow = flowname.instance()
		newflow.flowname = i
		$"%Content".add_child(newflow)

func _on_Button_pressed():
	var newflow ='untitled'
	newflow = Global.unique_name(Global.current_project.Flows.keys(),newflow)
	Global.add_NewFlow(newflow)
