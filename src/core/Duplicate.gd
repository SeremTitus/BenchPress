class_name Duplicate

static func object(this:Object) -> Object:
	var new_object:Object = object_copy(this)
	if not new_object: return null
	var props:Array = new_object.get_property_list()
	for prop in props:
		if prop["name"] == "script": continue
		var orignal_value = this.get(prop["name"])
		var new_value = variable(orignal_value) if not orignal_value is Object else object(orignal_value)
		new_object.set(prop["name"],new_value)
	return new_object

static func variable(this:Variant) -> Variant:
	if this == null: return null
	var new_var:Variant
	match typeof(this):
		TYPE_ARRAY:
			var new_array:Array = []
			for item in this:
				if item is Object:
					new_array.append(object(item))
				else:
					new_array.append(variable(item))
			new_var = new_array
		TYPE_DICTIONARY:
			var new_dict:Dictionary = {}
			for key in this:
				var item = variable(this[key]) if not this[key] is Object else object(this[key])
				key = variable(key) if not key is Object else object(key)
				new_dict[key] = item
			new_var = new_dict
		TYPE_INT, TYPE_STRING, TYPE_FLOAT, TYPE_STRING_NAME, TYPE_BOOL, TYPE_CALLABLE:
			new_var = this
		TYPE_NIL:
			new_var = null
		TYPE_OBJECT:
			new_var = object(this)
		_:
			new_var = this.duplicate()
	return new_var

static func object_copy(this:Object) -> Object:
	var constructor:String = ""
	var object_script = this.get_script()
	if not object_script:
		constructor = this.get_class()
	else:
		var script_path = object_script.resource_path
		constructor =  script_path
	if constructor.ends_with(".gd"):
		var gdscript:GDScript = load(constructor)
		var args:Array = []
		for method in gdscript.get_script_method_list():
			if not method.name == "_init": continue
			var len_args = len(method.args)
			var len_default_args = len(method.default_args)
			if len_args == len_default_args: continue
			for arg in method.args:
				var a:Variant = ""
				args.append(type_convert(a,arg.type))
			var count = 0
			for default in method.default_args:
				var pos = count + len_args - len_default_args
				args[pos] = args[pos] if default == null else default
				count += 1
		return Callable(gdscript,"new").bindv(args).call()
	elif constructor in ClassDB.get_class_list():
		return ClassDB.instantiate(constructor)
	return null
