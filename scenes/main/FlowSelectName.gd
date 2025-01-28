extends Control

var Subroutinename :String = '' :set=setSubroutinename

func setSubroutinename(newvalue):
	Subroutinename = newvalue
	$"%LabelSubroutine".text = Subroutinename
	#if Global.selected_Subroutine == Subroutinename:
	#	$"%LabelSubroutine".modulate ='#ffc11d'

func _on_LabelSubroutine_text_entered(new_text):
	if Subroutinename == new_text: return FAILED
	#new_text = Global.unique_name(Global.current_project.Subroutines.keys(),new_text)
	#if Global.selected_Subroutine == Subroutinename: Global.selected_Subroutine = new_text
	#Global.rename_Subroutine(Subroutinename,new_text)

func _on_LabelSubroutine_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.get_button_index() == 1 and not $"%LabelSubroutine".editable:
		#Global.selected_Subroutine = Subroutinename
		pass

func _on_RemoveButton_pressed():
	$"%LabelSubroutine".editable = false
	$"%RemoveButton".visible = false
	$"%EditButton".visible =false
	$"%ConfirmButton".visible =false
	$"%cancelButton".visible = true
	$"%DeleteButton".visible = true
	
func _on_ConfirmButton_pressed():
	$"%LabelSubroutine".editable = false
	_on_LabelSubroutine_text_entered($"%LabelSubroutine".text)
	$"%ConfirmButton".visible =false
	$"%EditButton".visible = true
	$"%cancelButton".visible = false
	
func _on_EditButton_pressed():
	$"%LabelSubroutine".editable = true
	$"%EditButton".visible =false
	$"%ConfirmButton".visible =true
	$"%cancelButton".visible = true

func _on_cancelButton_pressed():
	$"%LabelSubroutine".text = Subroutinename
	$"%LabelSubroutine".editable = false
	$"%RemoveButton".visible = true	
	$"%EditButton".visible = true
	$"%ConfirmButton".visible = false
	$"%cancelButton".visible = false
	$"%DeleteButton".visible = false


func _on_DeleteButton_pressed():
	_on_cancelButton_pressed()
	#if Global.selected_Subroutine == Subroutinename:
	#	var previous = ''
	#	for key in Global.current_project.Subroutines.keys():
	#		if key == Subroutinename: break
	#		previous = key
	#	if previous == '':
	#		var next = false
	#		for key in Global.current_project.Subroutines.keys():
	#			if next:
	#				previous = key
	#				break
	#			if key == Subroutinename: next = true
	#	Global.selected_Subroutine = previous
	#Global.delete_Subroutine(Subroutinename)
