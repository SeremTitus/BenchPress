extends VBoxContainer

var ActionCallActionReference = 'uniwu/item/variable/New_variable' :set=setActionCallActionReference
var ActionCallProperties = 0#Global.Actions.ActionCallProperties.position_index.duplicate(true)
enum mode{
	SELECT = 1,
	DISPLAY = 2,
	DISPLAY_IN_PARENT = 3}
var active_mode = mode['SELECT'] :set=set_activemode
var view_properties = ProjectSettings.get_setting('benchpress/ActionCalls/display_with_properties') 
var is_parent = false
func _ready():
	$"%selectColor".visible = false
	
func setActionCallActionReference(value):
	ActionCallActionReference = value
	$"%Title".text ="" #Global.LibraryActionCallAction[str(ActionCallActionReference)]['Title']
	$"%Description".text =""# Global.LibraryActionCallAction[str(ActionCallActionReference)]['Description']
	is_parent = ""#Global.LibraryActionCallAction[str(ActionCallActionReference)]['Parent']
	
func set_activemode(newvalue):
	active_mode = newvalue
	if active_mode >1:
		$"%Description".visible = true
		$"%selectColor".visible = true

func toggle_highlight():
	$"%highlight".visible=not($"%highlight".visible)

func get_value():
	var _newActionCallProperties :Dictionary = {#loop-able keys are not fixed
		get_index() :{#fixed keys
			'children' : {},#children ActionCallProperties
			'SourceLibrary':'',#Libraries['Nameunique'] (First name is editor assigned to prevent library collision)+':'+Libraries['Name']  +':'+ ActionCallAction['GroupPath'] +':'+ ActionCallAction['GroupPath']
			'Enabled' : true,
			'BreakingPoint': false,
			'ActiveMorphs' :['Base'],
			'Properties':{#loop-able keys are not fixed
				#'Edited_Properties_Name' :'Value'#set_values
				},
			'SubroutineVariable':{#loop-able keys are not fixed
				#'Edited_Properties_Name' :'Name'#set_values
				},
			'errorhandlers':{#loop-able keys are not fixed
				'SourceLibrary':{
					'Enabled' : true,
					'Properties':{#loop-able keys are not fixed
						#'Edited_Properties_Name' :'Value'
						}
					}
				},
		}
	}
