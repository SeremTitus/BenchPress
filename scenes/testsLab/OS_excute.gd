extends Control


@export var executablePath:String ='python.exe'# 'cmd.exe'
@export var arg:PackedStringArray = ['']#['/C','python.exe']
@export var FilePath = ''
var threadsdict:Dictionary ={}#MAY BE BE REPLACED WITH  GODOT'S MUTEX
@onready var filedialog = %FileDialog
@onready var ToolTip =%ToolTip
@onready var selectProcess = %SelectProcess
@onready var autoCloseDeadThreads = %autoclosethreads

var select_changed:bool = false
var active_thread:int=0
var selected_thread:int=0

func _ready():
	ToolTip.set_text('Welcome to Test Console \n')
	
func _process(_delta):
	for threads in threadsdict:
		if threadsdict.has(threads):
			if not(threadsdict[threads]['output'].is_empty()):
				var text = 'RUNNING script:\n\t'+str(threadsdict[threads]['thread'])+" "+threadsdict[threads]['scriptname'] +"  is _alive="+str(threadsdict[threads]['thread'].is_alive()) +"\n OUTPUT:\n" + str(threadsdict[threads]['output'][0])+ '\n'
				threadsdict[threads]['output'].clear()
				add_text(text)
			if autoCloseDeadThreads.pressed and not threadsdict[threads]['thread'].is_alive():
				threadsdict[threads]['thread'].wait_to_finish()
				# warning-ignore:return_value_discarded
				threadsdict.erase(threads)
				for treads_key in threadsdict:
					if threadsdict.has(treads_key):
						selected_thread = treads_key
				select_changed = true
	if  select_changed:
		selectProcess.clear()
		for threads in threadsdict:
			if threadsdict.has(threads):
				selectProcess.add_item(str(threadsdict[threads]['scriptname']).get_file() +" "+ str( threadsdict[threads]['thread']),int(threads))
				selectProcess.add_separator()
		selectProcess.selected = selectProcess.get_item_index(selected_thread)
		if selectProcess.get_item_count() <= 0:
			selectProcess.add_item('No Active Process')
		select_changed= false
	
func _on_SelectProcess_item_selected(index):
	selected_thread = selectProcess.get_item_id(index)
	
func _on_What_is_Run_pressed():
	var text =''
	var anytextout =false
	for threads in threadsdict:
		if threadsdict.has(threads):
			if threadsdict[threads]['thread'].is_alive():
				text += 'RUNNING script:'+str(threadsdict[threads]['thread'])+threadsdict[threads]['scriptname'] +" Tread alive="+str(threadsdict[threads]['thread'].is_alive()) +"\n"
				anytextout = true
			elif threadsdict[threads]['thread'].is_active():
				text += 'Script DONE Running:'+str(threadsdict[threads]['thread'])+threadsdict[threads]['scriptname'] +" Tread alive="+str(threadsdict[threads]['thread'].is_alive())+'\n'
				anytextout = true
	if not anytextout: text ='NO Running script'
	add_text(text)
	
func _on_ClearToolTip_pressed():
	ToolTip.clear()
	
func add_text(text_value : String) -> void:
	ToolTip.call_thread_safe("append_text",text_value + "\n")
	
func _on_deselect_script_pressed():
	filedialog.popup()
	
func _on_FileDialog_files_selected(paths):
	var strpath:String=''
	for stri in paths:
		if strpath == '\\': stri = '/'
		strpath += stri
	FilePath = strpath
	
func _on_Run_Script_pressed():
	var newindex:int = 0
	for treads_key in threadsdict:
		if threadsdict.has(treads_key):
			newindex = treads_key +1
	threadsdict[newindex] ={'thread':Thread.new(),'pID':0,'output':[],'scriptname':str(FilePath)}
	active_thread = newindex
	selected_thread = newindex
	threadsdict[active_thread]['thread'].start(treaded_execute)
	select_changed = true
	
func treaded_execute():
	if not(FilePath == ''):
		add_text('Starting: '+str(FilePath))
		threadsdict[active_thread]['pID'] = OS.execute(executablePath,PackedStringArray((Array(arg) + [FilePath])),threadsdict[active_thread]['output'],false,false)
		# warning-ignore:return_value_discarded
		OS.kill(threadsdict[active_thread]['pID'])
	else:
		add_text('File Path is Empty')
	
func _on_KillCurrentProcess_pressed():
	if threadsdict.has(selected_thread) and not (threadsdict[selected_thread]['thread'].is_alive()):
		threadsdict[selected_thread]['thread'].wait_to_finish()
		# warning-ignore:return_value_discarded
		threadsdict.erase(selected_thread)
		for treads_key in threadsdict:
			if threadsdict.has(treads_key):
				selected_thread = treads_key
		select_changed = true
	
func _exit_tree():
	for threads in threadsdict:
		if threadsdict.has(threads):
			threadsdict[threads]['thread'].wait_to_finish()
			# warning-ignore:return_value_discarded
			threadsdict.erase(threads)
	
