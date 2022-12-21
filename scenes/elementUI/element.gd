extends Control
signal add_to_flow
signal highlighted


onready var title  =$"%Title"
onready var description =$"%Description"

var ElementStructureReference = '' 
var ElementProperties = Global.structures.ElementProperties.position_index.duplicate(true)

enum mode{
	SELECT = 1,
	DISPLAY = 2,
	DISPLAY_IN_PARENT = 3
}

var active_mode = mode['SELECT'] setget set_activemode

var view_properties = ProjectSettings.get_setting('benchpress/elements/display_with_properties') 

func set_activemode(newvalue):
	active_mode = newvalue
	if active_mode >1:
		$"%spacer".visible = true
		description.visible = false
		ElementProperties  = create_ElementProperties()
	
func create_ElementProperties():
	
	pass
	
func toggle_highlight():
	$"%highlight".visible=not($"%highlight".visible)

func highlighted():
	emit_signal('highlighted',self)
	if active_mode == 1:
		emit_signal('add_to_flow',self)
		
