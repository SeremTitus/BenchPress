extends Control

var flowname :String = '' :set=setflowname

func setflowname(newvalue):
	flowname = newvalue
	$"%LabelFlow".text = flowname
	if Global.selected_flow == flowname:
		$"%LabelFlow".modulate ='#ffc11d'

func _on_LabelFlow_text_entered(new_text):
	if flowname == new_text: return FAILED
	new_text = Global.unique_name(Global.current_project.Flows.keys(),new_text)
	if Global.selected_flow == flowname: Global.selected_flow = new_text
	Global.rename_flow(flowname,new_text)

func _on_LabelFlow_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.get_button_index() == 1 and not $"%LabelFlow".editable:
		Global.selected_flow = flowname

func _on_RemoveButton_pressed():
	$"%LabelFlow".editable = false
	$"%RemoveButton".visible = false
	$"%EditButton".visible =false
	$"%ConfirmButton".visible =false
	$"%cancelButton".visible = true
	$"%DeleteButton".visible = true
	
func _on_ConfirmButton_pressed():
	$"%LabelFlow".editable = false
	_on_LabelFlow_text_entered($"%LabelFlow".text)
	$"%ConfirmButton".visible =false
	$"%EditButton".visible = true
	$"%cancelButton".visible = false
	
func _on_EditButton_pressed():
	$"%LabelFlow".editable = true
	$"%EditButton".visible =false
	$"%ConfirmButton".visible =true
	$"%cancelButton".visible = true

func _on_cancelButton_pressed():
	$"%LabelFlow".text = flowname
	$"%LabelFlow".editable = false
	$"%RemoveButton".visible = true	
	$"%EditButton".visible = true
	$"%ConfirmButton".visible = false
	$"%cancelButton".visible = false
	$"%DeleteButton".visible = false


func _on_DeleteButton_pressed():
	_on_cancelButton_pressed()
	if Global.selected_flow == flowname:
		var previous = ''
		for key in Global.current_project.Flows.keys():
			if key == flowname: break
			previous = key
		if previous == '':
			var next = false
			for key in Global.current_project.Flows.keys():
				if next:
					previous = key
					break
				if key == flowname: next = true
		Global.selected_flow = previous
	Global.delete_flow(flowname)
