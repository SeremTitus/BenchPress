extends VBoxContainer

var Subroutine:Subroutine:set = set_Subroutine

func  set_Subroutine(new_Subroutine:Subroutine) -> void:
	Subroutine = new_Subroutine

func  _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Array[Action]: return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	pass
