extends Node
## Design for Autoload

signal redo_excuted(action_name:String,context:String)
signal undo_excuted(action_name:String,context:String)

var current:UndoRedo = UndoRedo.new()
var context_current:String = "base"
var contexts:Dictionary = {
	"base" : current
}
enum MergeMode{
	MERGE_DISABLE = 0,
	MERGE_ENDS = 1,
	MERGE_ALL = 2
	}
var is_excuting:bool = false

func _input(event) -> void:
	if event.is_action_pressed(&"redo"):
		if current.has_redo():
			var action_name = current.get_action_name(current.get_current_action()+1) # +1 not sure if bug
			is_excuting = true
			current.redo()
			is_excuting = false
			redo_excuted.emit(action_name,context_current)
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed(&"undo"):
		if current.has_undo():
			var action_name = current.get_current_action_name()
			is_excuting = true
			current.undo()
			is_excuting = false
			undo_excuted.emit(action_name,context_current)
			get_viewport().set_input_as_handled()

func switch_context(context:String) -> void:
	add_context(context)
	context_current = context
	current = contexts[context]

func add_context(context:String) -> Error:
	if contexts.has(context):
		return FAILED
	contexts[context] = UndoRedo.new()
	return OK

func remove_context(context:String) -> void:
	if context == "base": return
	contexts.erase(context)

func add_action_simple_methods(action_name:String,redo:Callable,undo:Callable,\
	add_reference:Object = null,execute:bool = true,context:String = "base") -> void:
	create_action(action_name,context)
	add_do_reference(add_reference,context)
	add_undo_reference(add_reference,context)
	add_do_method(redo,context)
	add_undo_method(undo,context)
	commit_action(execute,context)

func add_action_simple_property(action_name:String,object: Object, property: StringName,\
	redo_value: Variant, undo_value: Variant,execute:bool = true,context:String = "base") -> void:
	create_action(action_name,context)
	add_do_reference(object,context)
	add_undo_reference(object,context)
	add_do_property(object, property, redo_value,context)
	add_undo_property(object, property, undo_value,context)
	commit_action(execute,context)

func add_do_method(callable: Callable,context:String = "base") -> void:
	add_context(context)
	current[context].add_do_method(callable)

func add_do_property(object: Object, property: StringName, value: Variant,context:String = "base") -> void:
	add_context(context)
	current[context].add_do_property(object, property, value)

func add_do_reference(object: Object,context:String = "base") -> void:
	add_context(context)
	current[context].add_do_reference(object)

func add_undo_method(callable: Callable,context:String = "base") -> void:
	add_context(context)
	current[context].add_undo_method(callable)

func add_undo_property(object: Object, property: StringName, value: Variant,context:String = "base") -> void:
	add_context(context)
	current[context].add_undo_property(object, property , value )

func add_undo_reference(object: Object,context:String = "base") -> void:
	add_context(context)
	current[context].add_undo_reference(object)

func clear_history(context:String = "base",increase_version: bool = true) -> void:
	add_context(context)
	current[context].clear_history(increase_version)

func commit_action(execute: bool = true,context:String = "base") -> void:
	add_context(context)
	current[context].commit_action(execute)

func create_action(action_name: String,context:String = "base",\
	merge_mode: MergeMode = MergeMode.MERGE_DISABLE , backward_undo_ops: bool = false) -> void:
	add_context(context)
	match  merge_mode:
		UndoRedo.MERGE_DISABLE:
			current[context].create_action(action_name,UndoRedo.MERGE_DISABLE, backward_undo_ops)
		UndoRedo.MERGE_ENDS:
			current[context].create_action(action_name,UndoRedo.MERGE_ENDS, backward_undo_ops)
		UndoRedo.MERGE_ALL:
			current[context].create_action(action_name,UndoRedo.MERGE_ALL, backward_undo_ops)
