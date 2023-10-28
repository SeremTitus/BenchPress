extends VBoxContainer

var ElementStructureReference = 'uniwu/item/variable/New_variable' :set=setElementStructureReference
var ElementProperties = Global.structures.ElementProperties.position_index.duplicate(true)
enum mode{
	SELECT = 1,
	DISPLAY = 2,
	DISPLAY_IN_PARENT = 3}
var active_mode = mode['SELECT'] :set=set_activemode
var view_properties = ProjectSettings.get_setting('benchpress/elements/display_with_properties') 
var is_parent = false
func _ready():
	$"%selectColor".visible = false
	
func setElementStructureReference(value):
	ElementStructureReference = value
	$"%Title".text = Global.LibraryElementStructure[str(ElementStructureReference)]['Title']
	$"%Description".text = Global.LibraryElementStructure[str(ElementStructureReference)]['Description']
	is_parent = Global.LibraryElementStructure[str(ElementStructureReference)]['Parent']
	
func set_activemode(newvalue):
	active_mode = newvalue
	if active_mode >1:
		$"%Description".visible = true
		$"%selectColor".visible = true

func toggle_highlight():
	$"%highlight".visible=not($"%highlight".visible)

func get_value():
	var _newElementProperties :Dictionary = {#loop-able keys are not fixed
		get_index() :{#fixed keys
			'children' : {},#children ElementProperties
			'SourceLibrary':'',#Libraries['Nameunique'] (First name is editor assigned to prevent library collision)+':'+Libraries['Name']  +':'+ ElementStructure['GroupPath'] +':'+ ElementStructure['GroupPath']
			'Enabled' : true,
			'BreakingPoint': false,
			'ActiveMorphs' :['Base'],
			'Properties':{#loop-able keys are not fixed
				#'Edited_Properties_Name' :'Value'#set_values
				},
			'FlowVariable':{#loop-able keys are not fixed
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
