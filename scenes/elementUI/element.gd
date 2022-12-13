extends Control


onready var title  =$"%Title"
onready var description =$"%Description"

enum mode{
	SELECT = 0,
	DISPLAY = 1,
}
var active_mode = mode['SELECT'] setget set_activemode
var view_properties = ProjectSettings.get_setting('benchpress/elements/display_with_properties') 
func set_activemode(newvalue):
	active_mode = newvalue
	if active_mode == 1:
		#convert to local
		pass

func init(title_in:String,description_in:String,dp_visibility:bool):
	title.text = title_in
	description.text = description_in
	description.visible = dp_visibility
		

