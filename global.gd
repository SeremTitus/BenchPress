extends Node
var saverReloader = preload("res://specialFunction/SAVER_RELOADER_PlaceholderHack.gd").new()
var Actions = preload("res://specialFunction/structrures.gd").new()
var LibraryActionCallAction = {
	'uniwu/item/variable/New_variable':{
		'Library' : '',
		'Type':'ActionCall',#Inheritable,errorhandler
		'Title' : 'ADD VARIABLE',
		'Description' : 'test description',
		'Doc':'Doc Example',
		'Icon':'',
		'GroupPath':'',
		'Dependencies':[],
		'Inherit':[],
		'Iniciator':[],
		'AntiIniciator':[],
		'Parent':false,
		'Morphs':{#loop-able, keys are not fixed
										#Placeholder key but Base maybe found in most ActionCalls
			'Base' :{#fixed keys
				'Feature' : '',
				'Code' : '',
				'Properties':{#loop-able keys are not fixed
												#Placeholder key
					'Enter Variable Name':{#fixed keys
						'VariableName':'n',
						'Type':'n',
						'Display':'Options',
						'DisplayType':'n',
						'subtype':['s','t'],
						'DefaultValue':'',
						'InputOutput':'Input'
						},
					'Static':{#fixed keys
						'VariableName':'n',
						'Type':'n',
						'Display':'Options',
						'DisplayType':'n',
						'subtype':['s','t'],
						'DefaultValue':'',
						'InputOutput':'Output'
						}
					}
				}
			}
		},
	
	}
signal LibraryActionCallAction_Constructed
var current_project_filePath = ''
var current_project = {} : set = current_Project_set
signal current_Project_changed
var GlobalVariables = {}
var SubroutineVariables = []

var highlighted_ActionCall = null : set =highlighted_ActionCall_set
signal highlighted_ActionCall_changed
var selected_Subroutine = 'main' : set = selected_Subroutine_changed

func _ready():
	create_dir()
	create_newProject()
	#get_LibraryActionCallAction()


func create_newProject():
	current_project = {
		'Version' : '0.0.1.Dev',
		'FileState' : 'Subroutine',#Library,Subroutine,App -->'App' filestate is reserved for deployed clients
		'LibrariesVersion' :{#loop-able keys are not fixed
			'built-in': '0.0.1.Alfa',
			},
		'Globals':{#loop-able keys are not fixed
			'Globalsid':{
				'Type':'',
				'Value':''
				}
			},
		'Subroutines': {#loop-able, keys are not fixed
		'main' : {},
		},
		'ActionCallActions':{}, # if FileState is Subroutine SubroutineActionCallslist only include used ActionCalls
		'ActionCallUpdatePatterns':{#loop-able keys are not fixed
			#Intended for libraries to be able to be updated atleast in minorEditor releases
			#TOBE DEFINED
			}
		}
	
func create_Update_Subroutine(Subroutinename,changes):
	if current_project.Subroutines.has(Subroutinename) and typeof(changes) == TYPE_DICTIONARY:
		current_project.Subroutines[Subroutinename] = changes
		emit_signal("current_Project_changed")
		return OK
	return FAILED
	
func add_NewSubroutine(Subroutinename):
	current_project.Subroutines[Subroutinename] ={}
	selected_Subroutine = Subroutinename
	emit_signal("current_Project_changed")
	return OK
	
func rename_Subroutine(Subroutinename,_changes):
	if current_project.Subroutines.has(Subroutinename):
		#FORCE_SAVE
		current_project.Subroutines[_changes] = current_project.Subroutines[Subroutinename]
		current_project.Subroutines.erase(Subroutinename)
		emit_signal("current_Project_changed")
		return OK
	return FAILED
	
func delete_Subroutine(Subroutinename):
	if current_project.Subroutines.has(Subroutinename):
		current_project.Subroutines.erase(Subroutinename)
		emit_signal("current_Project_changed")
		return OK
	return FAILED
	
func run_current_Subroutine(_params):
	pass
	
func save_current_benchpress():
	pass
	
func current_Project_set(newvalue):
	current_project = newvalue
	emit_signal("current_Project_changed")
	
func highlighted_ActionCall_set(newvalue):
	highlighted_ActionCall = newvalue
	emit_signal("highlighted_ActionCall_changed")
	
func selected_Subroutine_changed(newvalue):
	selected_Subroutine = newvalue
	emit_signal("current_Project_changed")
	
func get_LibraryActionCallAction():
	var contents = dir_contents('user://Library').files
	LibraryActionCallAction.clear()
	for file_name in contents:
		if file_name.get_extension() != 'benchpress': continue
		#get data .benchpress files that are type library store it in BenchPressfile		
		var BenchPressfile =saverReloader._load('user://Library/'+file_name)
		if BenchPressfile['FileState'] != 'Library':continue
		for SourceLibraryName in BenchPressfile['ActionCallActions']:
			var uniqueSourceLibraryName = SourceLibraryName.get_slice("/", 0)+'/'+SourceLibraryName.get_slice("/", 0)+'/'+SourceLibraryName.get_slice("/", 1)+'/'+SourceLibraryName.get_slice("/", 2)
			var makeunique = 0
			while LibraryActionCallAction.has(uniqueSourceLibraryName):
				makeunique += 1
				uniqueSourceLibraryName =(SourceLibraryName.get_slice("/", 0)+str(makeunique))+'/'+SourceLibraryName.get_slice("/", 0)+'/'+SourceLibraryName.get_slice("/", 1)+'/'+SourceLibraryName.get_slice("/", 2)
			LibraryActionCallAction[uniqueSourceLibraryName] = BenchPressfile['ActionCallActions'][SourceLibraryName]
	emit_signal("LibraryActionCallAction_Constructed")
	
func dir_contents(path):
	var contents = {
		'directories':[],
		'files':[],
	}
	var directory = DirAccess.open(path)
	if directory == OK:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while file_name != "":
			if directory.current_is_dir():
				contents['directories'].append(file_name)
			else:
				contents['files'].append(file_name)
			file_name = directory.get_next()
	return contents
	
func create_dir(dirAndFiles = Actions.custom_user_folders):
	for dir in dirAndFiles:
		var directory = DirAccess.open("user://")
		if directory == null:
			printerr(error_string(DirAccess.get_open_error()))
			return
		if  ! directory.dir_exists(dir):
			directory.make_dir_recursive(dir)
		for copyfile in dirAndFiles[dir]:
			if ! directory.file_exists(dir +'/'+copyfile) and directory.file_exists(dirAndFiles[dir][copyfile]):
				directory.copy(dirAndFiles[dir][copyfile],dir+'/'+copyfile)
			if FileAccess.get_sha256(dir +'/'+copyfile) != FileAccess.get_sha256(dirAndFiles[dir][copyfile]):
				directory.copy(dirAndFiles[dir][copyfile],dir+'/'+copyfile)
	
func unique_name(names:PackedStringArray,newName:String):
	if ! names.has(newName): return newName
	#remove any numerals ends on newName
	var newName_CharacterIndex =range(len(newName))
	newName_CharacterIndex.reverse()
	var arrayNumbers = PackedStringArray(range(10))
	var countnumbers = 0
	for chr in newName_CharacterIndex:
		if ! arrayNumbers.has(newName[chr]): break
		countnumbers += 1
	#create a unique name
	var uniqueName = newName.substr(0,len(newName)-countnumbers)
	if uniqueName != '' and ! names.has(uniqueName): return uniqueName
	var makeunique = 0
	while names.has(newName):
		makeunique += 1
		newName = uniqueName + str(makeunique)
	return newName
	

