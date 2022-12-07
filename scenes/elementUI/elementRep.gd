extends Node


onready var title  =$"%Title"
onready var description =$"%Description"

func init(title_in:String,description_in:String,dp_visibility:bool):
	title.text = title_in
	description.text = description_in
	description.visible = dp_visibility
