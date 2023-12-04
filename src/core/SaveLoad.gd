class_name  SaveLoad extends ConfigFile
## Extends ConfigFile to save and load Objects that can be instantiate.[br]
## Stores Objects, self contained signal(if emitor and connected object are stored),Callables

#region user defined
## If true all inherited properties are considered else only the defined in script are
var deep = false 
## constructor : base_section_name
var objects_with_sections:Dictionary = {} 
## constructor : [prop_name,...]
var objects_exclude_props:Dictionary = {}
## constructor : [prop_name,...]
var objects_include_props:Dictionary = {} 
#endregion

var start_section:String = ""
var meta_section_name:String = "SaveLoad"
var ref:Unique = Unique.new()
 ## Object : section_name
var ref_objects:Dictionary = {}
## Callable : section_name
var ref_callables:Dictionary = {}
## section_name : constructor
var stored_objects_constructor:Dictionary ={}

func _init(is_deep = false):
	deep = is_deep
	
#region setters snd getters
func  add_section(owner:Object,section_name:String) -> void:
	if not section_name == meta_section_name:
		objects_with_sections[get_objects_constructor(owner)] = section_name

func  remove_section(section_name:String) -> void:
	for constructor in objects_with_sections:
		if objects_with_sections[constructor] == section_name:
			objects_with_sections.erase(constructor)

func  add_exclude_property_name(owner:Object,property_name:String) -> void:
	var constructor = get_objects_constructor(owner)
	if constructor in objects_exclude_props:
		objects_exclude_props[constructor].append(property_name)
	else:
		objects_exclude_props[constructor] = PackedStringArray([property_name])

func  remove_exclude_property_name(owner:Object,property_name:String) -> void:
	var constructor = get_objects_constructor(owner)
	if constructor in objects_exclude_props as PackedStringArray:
		var idx:int = objects_exclude_props[constructor].find(property_name)
		objects_exclude_props[constructor].remove_at(idx)

func  add_include_property_name(owner:Object,property_name:String) -> void:
	var constructor = get_objects_constructor(owner)
	if constructor in objects_include_props:
		objects_include_props[constructor].append(property_name)
	else:
		objects_include_props[constructor] = PackedStringArray([property_name])

func  remove_include_property_name(owner:Object,property_name:String) -> void:
	var constructor = get_objects_constructor(owner)
	if constructor in objects_include_props as PackedStringArray:
		var idx:int = objects_include_props[constructor].find(property_name)
		objects_include_props[constructor].remove_at(idx)

#endregion

#region true duplicate
static func duplicate(this:Object) -> Object:
	var access = SaveLoad.new()
	var new_object: Object = access.object_from_constructor(access.get_objects_constructor(this))
	if new_object == null : return null
	var prop_value = access.default_values(this)
	for prop in prop_value:
		var new_prop = duplicate_var(prop_value[prop]) if not prop_value[prop] is Object else duplicate(prop_value[prop])
		new_object.set(prop,new_prop)
	for sig in this.get_signal_list():
		for conn in this.get_signal_connection_list(sig.name):
			new_object.connect(sig.name ,conn.callable ,conn.flags)
	return new_object

static func duplicate_var(this:Variant) -> Variant:
	var new_var:Variant
	match typeof(this):
		TYPE_ARRAY:
			var new_array:Array = []
			for item in this:
				if item is Object:
					new_array.append(duplicate(item))
				else:
					new_array.append(duplicate_var(item))
			new_var = new_array
		TYPE_DICTIONARY:
			var new_dict:Dictionary = {}
			for key in this:
				var item = duplicate_var(this[key]) if not this[key] is Object else duplicate(this[key])
				key = duplicate_var(key) if not key is Object else duplicate(key)
				new_dict[key] = item
			new_var = new_dict
		TYPE_INT, TYPE_STRING, TYPE_FLOAT:
			new_var = this
		_:
			new_var = this.duplicate()
	return new_var
#endregion

#region shared
func are_object_same_class(obj1:Object,obj2:Object) -> bool:
	if obj1 == null and obj2 == null:
		return true
	elif obj1 == null or obj2 == null:
		return false
	var script1 = obj1.get_script()
	var script2 = obj2.get_script()
	if script1 == null and script2 == null:
		return obj1.get_class() == obj2.get_class()
	elif script1 == null or script2 == null:
		return false
	elif  script1 == script2:
		return true
	return false

func clean_up() -> void:
	start_section = ""
	ref.clear()
	ref_objects = {}
	stored_objects_constructor = {}
	clear()

func get_objects_constructor(from:Object) -> String:
	var object_script = from.get_script()
	if object_script == null:
		return from.get_class()
	var script_path = object_script.resource_path
	if script_path == "":
		return "Built-in script"
	else:
		return script_path

func object_from_constructor(constructor:String) -> Object:
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

#endregion

#region Saving
func generate_section_name(from:Object) -> String:
	var object_script = from.get_script()
	if object_script == null:
		return from.get_class()
	var section_name:String = object_script.get_script_property_list()[0]["name"]
	if section_name == "Built-in script":
		return ''
	section_name = section_name.trim_suffix(".gd")
	if section_name == meta_section_name:# meta_section_name is reserved
		section_name = meta_section_name +'_' + ref.assign()
	return section_name

func get_section_name(from:Object) -> String:
	if from in ref_objects:
		return ref_objects[from]
	if get_objects_constructor(from) in objects_with_sections:
		return objects_with_sections[get_objects_constructor(from)]
	return generate_section_name(from)

func default_values(from:Object) -> Dictionary:
	var new:Object = object_from_constructor(get_objects_constructor(from))
	new = Object.new() if new == null else new
	var props:Array = new.get_property_list()
	var exclude_props:PackedStringArray = ["script"]
	var default_props_values:Dictionary = {} #name:variant
	for prop in props:
		if prop["name"] in exclude_props: continue
		default_props_values[prop["name"]] = new.get(prop["name"])
	return default_props_values

func props_list(from:Object) -> PackedStringArray:
	var script = from.get_script()
	var props:Array = []
	props = from.get_property_list() if script == null else from.get_property_list() if deep\
		 else script.get_script_property_list()
	var exclude_props:PackedStringArray = ["script"]
	if from is Node:
		exclude_props += PackedStringArray(["name","scene_file_path","multiplayer","owner"])
	if from is Control:
		exclude_props += PackedStringArray(["size"])
	var constructor = get_objects_constructor(from)
	exclude_props += PackedStringArray(objects_exclude_props[constructor]) if constructor in objects_exclude_props\
		else PackedStringArray(exclude_props)
	var default_props = default_values(from)
	var list_var:PackedStringArray = []
	for prop in props:
		if prop["name"] in exclude_props: continue
		var var_value = from.get(prop["name"])
		if not default_props.is_empty() and var_value == default_props[prop["name"]]: continue
		list_var.append(prop["name"])
	if constructor in objects_include_props:
		for include in objects_include_props[constructor]:
			list_var.append(include)
	return  list_var

func store_objects_constructors(section_name:String,from:Object) -> void:
	if stored_objects_constructor.has(section_name):
		return
	stored_objects_constructor[section_name] = get_objects_constructor(from)

func store_object(store:Object, attach_ref:bool = false):# -> object or string
	if store == null:
		return null
	var section_name:String = get_section_name(store)
	if section_name != '':
		if attach_ref:
			store_objects_constructors(section_name,store)
			if not store in ref_objects:
				section_name += " ref='" + ref.assign() +"'"
		elif section_name in ref_objects.values():
			section_name += "_" + ref.assign()
			store_objects_constructors(section_name,store)
		else:
			store_objects_constructors(section_name,store)
		ref_objects[store] = section_name
		for prop_name in  props_list(store):
			var prop = store.get(prop_name)
			var is_object = false if not prop is Object else true
			if not is_object and prop is Array:
					var new_array:Array = []
					for item in prop:
						var prop_ref = store_object(item, true) if item is Object\
						 else item
						new_array.append(prop_ref)
					set_value(section_name,prop_name,new_array)
			elif not is_object and prop is Dictionary:
				var new_dict:Dictionary = {}
				for key in prop:
					var key_ref = store_object(key, true) if key is Object\
						 else key
					var item_ref = store_object(prop[key], true)\
					 	if prop[key] is Object else prop[key]
					new_dict[key_ref] = item_ref
				set_value(section_name,prop_name,new_dict)
			elif prop is Callable:
				set_value(section_name,prop_name,get_callable_constructor(prop))
			elif is_object:
				set_value(section_name,prop_name,store_object(prop, true))
			else:
				set_value(section_name,prop_name,prop)
	else:
		return store
	return section_name

func get_callable_constructor(new_callable:Callable) -> String:
	var callable_section_name:String = ""
	if new_callable in ref_callables:
		callable_section_name = ref_callables[new_callable]
	else:
		callable_section_name = "callable ref='" + ref.assign() +"'"
		ref_callables[new_callable] = callable_section_name
	return callable_section_name
	
func store_callables() -> void:
	for this_callable in ref_callables:
		var callable_obj = this_callable.get_object()
		if callable_obj in ref_objects:
			var section_name = ref_callables[this_callable]
			set_value(section_name,"object",ref_objects[callable_obj])
			set_value(section_name,"method",this_callable.get_method())
			set_value(section_name,"args",this_callable.get_bound_arguments())

func store_signals() -> void:
	for object in ref_objects:
		var signals:Array[Dictionary] = []
		for sig in object.get_signal_list():
			for conn in object.get_signal_connection_list(sig.name):
				var connections_store:Dictionary = {}
				var signal_callable:Callable = conn.callable
				var signal_obj = signal_callable.get_object()
				if signal_obj in ref_objects:
					connections_store["name"] = sig.name
					connections_store["flags"] = conn.flags
					connections_store["callable"] = get_callable_constructor(signal_callable)
					signals.append(connections_store)
		if not signals.is_empty():
			set_value(ref_objects[object],"signal",signals)
	
func  store_meta() -> void:
	var section_name = meta_section_name
	for key in stored_objects_constructor:
		set_value(section_name,key,stored_objects_constructor[key])
	set_value(section_name,section_name,start_section)

func construct_dir(file_path:String) -> void:
	if not file_path.get_extension() == "":
		file_path = file_path.get_base_dir()
	var dir:DirAccess = DirAccess.open(file_path)
	var new_path:String = file_path
	while  dir == null:
		new_path = new_path.get_base_dir()
		if new_path == "":
			continue
		dir = DirAccess.open(new_path)
	dir.make_dir_recursive(file_path)

## Add key if  saving encrypted file
func save_to(save_file_path:String,store:Object,key = PackedByteArray()) -> Error:
	clean_up()
	construct_dir(save_file_path)
	if get_objects_constructor(store) in objects_with_sections:
		start_section = objects_with_sections[store]
	else:
		start_section = get_section_name(store)
		start_section = generate_section_name(store) if start_section == "" else start_section
		start_section = ref.assign() if start_section == "" else start_section
		objects_with_sections[get_objects_constructor(store)] = start_section
	store_object(store)
	if not has_section(start_section):
		start_section = get_objects_constructor(store)
	store_meta()
	store_signals()
	store_callables()
	var err:Error
	if key == PackedByteArray():
		err = save(save_file_path)
	else:
		err = save_encrypted(save_file_path,key)
	clean_up()
	return err
#endregion

#region Loading
func get_object_from_constructor(section_name:String) -> String:
	var key = section_name.get_slice(" ", 0)
	return get_value(meta_section_name,key,"")

func restore_object(section_name:String,restore:Object = null):#-> object or callables
	if not has_section(section_name): return restore
	if section_name.get_slice(" ", 0) == "callable": return restore_callable(section_name)
	for object in ref_objects:
		if ref_objects[object] == section_name:
			return Object
	var stored:Object = object_from_constructor(get_object_from_constructor(section_name))
	if are_object_same_class(stored,restore):
		stored = restore
	if stored == null:
		stored = Object.new()
	ref_objects[stored] = section_name
	for key in get_section_keys(section_name):
		if key  == "signal": continue
		var value =get_value(section_name,key,stored.get(key))
		if value is Array:
			var new_value:Array = []
			for item in value:
				item = restore_object(item) if item is String else  item
				new_value.append(item)
			value = new_value
		elif value is Dictionary:
			var new_value:Dictionary = {}
			for value_key in value:
				var new_value_key = restore_object(value_key) if value_key\
					is String else  value_key
				var item = restore_object(value[value_key]) if \
					value[value_key] is String else  value[value_key]
				new_value[new_value_key] = item
			value = new_value
		elif value is String:
			value = restore_object(value)
		stored.set(key,value)
	return stored

func restore_callable(section_name:String) -> Callable:
	var this_callable:Callable = Callable()
	if not has_section(section_name): return this_callable
	if not section_name.get_slice(" ", 0) == "callable": return this_callable
	var obj_section_name:String = get_value(section_name,"object","")
	var obj:Object = restore_object(obj_section_name)
	this_callable = Callable(obj,get_value(section_name,"method",""))
	this_callable = this_callable.bindv(get_value(section_name,"args",""))
	return this_callable

func restore_signals() -> void:
	for object in ref_objects:
		if has_section_key(ref_objects[object],"signal"):
			for conn in get_value(ref_objects[object],"signal",[]):
				if conn.is_empty(): continue
				var signal_callables = restore_callable(conn["callable"])
				object.connect(conn["name"],signal_callables ,conn["flags"])

## Add key if loading encrypted file
func can_load_from(file_path:String,restore:Object,key: PackedByteArray =  PackedByteArray(),\
	loaded:bool = false) -> Error: 
	if not loaded:
		clean_up()
		var err:Error
		if key == PackedByteArray():
			err = self.load(file_path)
		else:
			err = load_encrypted(file_path,key)
		if err != OK: return err
	var constructor_key = get_value(meta_section_name,meta_section_name,"")
	var constructor = get_value(meta_section_name,constructor_key,"")
	var stored = object_from_constructor(constructor)
	if not restore == null and not are_object_same_class(stored,restore):
		return FAILED
	if not file_path.get_extension() == "":
		file_path = file_path.get_base_dir()
	DirAccess.open(file_path)
	return DirAccess.get_open_error()

## Add key if loading encrypted file
func load_from(load_file_path:String,restore:Object = null,key:PackedByteArray = PackedByteArray())\
	 -> Object:
	clean_up()
	if key == PackedByteArray():
		self.load(load_file_path)
	else:
		load_encrypted(load_file_path,key)
	if not can_load_from(load_file_path,restore,key,true) == OK:
		return restore
	start_section = get_value(meta_section_name,meta_section_name)
	restore = restore_object(start_section,restore)
	restore_signals()
	clean_up()
	return restore
#endregion
