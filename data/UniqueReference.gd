class_name UniqueReference extends RefCounted

var assigned_names:PackedStringArray = []

func assign(new_length:int = 4) -> String:
	var length:int = new_length 
	if len(assigned_names) > pow(10,new_length):
		length = len(str(len(assigned_names)))
	var assign_name:String = UniqueReference.unique_name(length)
	var count:int = 0
	var max_repeat:int = 100
	while assign_name in assigned_names:
		if count >= max_repeat:
			length += 2
			max_repeat += max_repeat
		assign_name = UniqueReference.unique_name(length)
		count += 1
	assigned_names.append(assign_name)
	return assign_name

func assign_guided(base:String) -> String:
	var assign_name:String = base
	var count:int = 0
	while assign_name in assigned_names:
		count += 1
		assign_name += "_" + str(count)
	assigned_names.append(assign_name)
	return assign_name

func unassign(assign_name:String) -> void:
	assigned_names.remove_at(assigned_names.rfind(assign_name))

func clear() -> void:
	assigned_names.clear()

static func unique_name(length:int = 5) -> String:
	var alfa_num:String = "1234567890QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm"
	var to_rand:Array = alfa_num.split()
	randomize()
	to_rand.shuffle()
	var begin_int = randi() % len(alfa_num)
	return "".join(to_rand.slice(begin_int,begin_int + length))
