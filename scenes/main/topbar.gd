extends Control

var pressed_signal_redirect={}#{itemName:itemIndex{callinstruction}}
func _ready():
	var topbar ={
		$"%file":{
			'New':{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Open":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Save":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Append":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Export":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Quit":{
				'add_item':{},
				'set_item_disabled':true,
				},
			},
		$"%edit":{
			'Undo':{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Redo":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Find":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Cut":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Copy":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Paste":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Select All":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Inverse Selection":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Clear Selection":{
				'add_item':{},
				'set_item_disabled':true,
				},
			},
		$"%debug":{
			'Select Device':{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Run":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Run by Step":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Pause":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Continue":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Stop":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Rerun":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Record":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Skip Breakpoints":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Skip Into":{
				'add_item':{},
				'set_item_disabled':true,
				},
			},
		$"%editor":{
			'Editor Settings':{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Editor Layout":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Open Editor Data":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Manage Editor Feature":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Manage Editor Extensions":{
				'add_item':{},
				'set_item_disabled':true,
				},
			},
		$"%help":{
			"Documentation":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"Report a Bug":{
				'add_item':{},
				'set_item_disabled':true,
				},
			"About BenchPress":{
				'add_item':{},
				'set_item_disabled':false,
				'connect':{'target':$"%About",
							'method': 'popup',
							},
				},
			"Support Development":{
				'add_item':{},
				'set_item_disabled':true,
				},
			},
		$"%device":{
			'Local':{
				'add_radio_check_item':{},
				'set_item_disabled':true,
				},
			},
	}
	add_item(topbar)

func add_item(topbar:Dictionary):
	for menubutton in topbar:
		var itemIndex = 0
		for itemName in topbar[menubutton]:
			for instruction in topbar[menubutton][itemName]:
				var instructionValue = topbar[menubutton][itemName][instruction]
				match instruction:
					'add_item':
						menubutton.get_popup().add_item(itemName,itemIndex)
					'set_item_disabled':
						menubutton.get_popup().set_item_disabled(itemIndex,bool(instructionValue))
					'add_radio_check_item':
						menubutton.get_popup().add_radio_check_item(itemName,itemIndex)
					'connect':
						pressed_signal_redirect[itemName]={itemIndex:instructionValue}
						menubutton.get_popup().connect('index_pressed',self,'pressed',[itemName])
			itemIndex += 1

func pressed(itemIndex,itemName):
	for ind in pressed_signal_redirect[itemName]:
		if ind == itemIndex:
			pressed_signal_redirect[itemName][itemIndex]['target'].call(pressed_signal_redirect[itemName][itemIndex]['method'])
