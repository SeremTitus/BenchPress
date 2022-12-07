extends OptionButton

export var OptionItems:PoolStringArray = []


func _ready():
	var selected =''
	if get_selected_id() > -1:
		selected = get_item_text(get_selected_id())
	clear()
	for i in OptionItems:
		add_item(i)
	if selected == '':
		_select_int(-1)
	else:
		for i in range(get_item_count()):
			if get_item_text(i) == selected:
				_select_int(i)
			pass
