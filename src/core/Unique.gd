class_name Unique extends RefCounted

## profile_name : assigned_names
## profile_name consider it as unique name grouping
var assigned_names_profile: Dictionary[StringName, PackedStringArray]

func assign(new_length:int = 4, profile_name := "base") -> StringName:
	var length:int = new_length
	var assigned_names:PackedStringArray = PackedStringArray([])
	if profile_name in assigned_names_profile:
		assigned_names = assigned_names_profile[profile_name]
	if len(assigned_names) > pow(10,new_length):
		length = len(str(len(assigned_names)))
	var assign_name:StringName = Unique.unique_name(length)
	var count:int = 0
	var max_repeat:int = 100
	while assign_name in assigned_names:
		if count >= max_repeat:
			length += 2
			max_repeat += max_repeat
		assign_name = Unique.unique_name(length)
		count += 1
	append_unique(assign_name,profile_name)
	return assign_name

func assign_guided(inspiring_name: StringName, profile_name := "base") -> StringName:
	var assign_name := inspiring_name
	var count:int = 1
	if profile_name in assigned_names_profile:
		var assigned_names := assigned_names_profile[profile_name]
		while assign_name in assigned_names:
			count += 1
			assign_name = inspiring_name + "_" + str(count)
	append_unique(assign_name,profile_name)
	return assign_name

func unassign(assign_name: StringName, profile_name := "base") -> void:
	if not profile_name in assigned_names_profile:
		return
	var assigned_names := assigned_names_profile[profile_name]
	assigned_names.remove_at(assigned_names.rfind(assign_name))
	if assigned_names.is_empty():
		assigned_names_profile.erase(profile_name)

func clear() -> void:
	assigned_names_profile.clear()

static func unique_name(length := 5) -> StringName:
	var alfa_num:String = "1234567890QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm"
	var to_rand:Array = alfa_num.split()
	randomize()
	to_rand.shuffle()
	var begin_int = randi() % len(alfa_num)
	return StringName("".join(to_rand.slice(begin_int,begin_int + length)))

func append_unique(assign_name:StringName, profile_name := "base") -> void:
	if profile_name in assigned_names_profile:
		if not assigned_names_profile[profile_name].has(assign_name):
			assigned_names_profile[profile_name].append(assign_name)
	else:
		assigned_names_profile[profile_name] = PackedStringArray([assign_name])

func append_unique_array(assign_names:PackedStringArray, profile_name := "base") -> void:
	for assign_name in assign_names:
		append_unique(assign_name, profile_name)

func get_profile(profile_name := "base") -> PackedStringArray:
	if assigned_names_profile.has(profile_name):
		return assigned_names_profile[profile_name]
	return PackedStringArray()

func has(assign_name:StringName, profile_name := "base") -> bool:
	if profile_name in assigned_names_profile and assign_name in assigned_names_profile[profile_name]:
		return true
	return false
