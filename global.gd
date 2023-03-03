extends Node


var saverReloader=preload("res://specialFunction/SAVER_RELOADER_PlaceholderHack.gd").new()
var structures = preload("res://specialFunction/structrures.gd").new()

var LibraryElementStructure = {
	'uniwu/item/variable/New_variable':{
		'Library' : '',
		'Type':'Element',#Inheritable,errorhandler
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
										#Placeholder key but Base maybe found in most elements
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
signal LibraryElementStructure_Constructed
var current_project_filePath = ''
var current_project = {} setget current_Project_changed
signal current_Project_changed
var GlobalVariables = {}
var FlowVariables = []

var highlighted_element = null setget highlighted_element_changed
signal highlighted_element_changed
var selected_flow = 'main' setget selected_flow_changed

func _ready():
	create_dir()
	create_newProject()
	#get_LibraryElementStructure()


func create_newProject():
	current_project = {
		'Version' : '0.0.1.Dev',
		'FileState' : 'Flow',#Library,Flow,App -->'App' filestate is reserved for deployed clients
		'LibrariesVersion' :{#loop-able keys are not fixed
			'built-in': '0.0.1.Alfa',
			},
		'Globals':{#loop-able keys are not fixed
			'Globalsid':{
				'Type':'',
				'Value':''
				}
			},
		'Flows': {#loop-able, keys are not fixed
		'main' : {},
		},
		'ElementStructures':{}, # if FileState is Flow flowElementslist only include used elements
		'ElementUpdatePatterns':{#loop-able keys are not fixed
			#Intended for libraries to be able to be updated atleast in minorEditor releases
			#TOBE DEFINED
			}
		}
	
func create_Update_flow(flowname,changes):
	if current_project.Flows.has(flowname) and typeof(changes) == TYPE_DICTIONARY:
		current_project.Flows[flowname] = changes
		emit_signal("current_Project_changed")
		return OK
	return FAILED
	
func add_NewFlow(flowname):
	current_project.Flows[flowname] ={}
	selected_flow = flowname
	emit_signal("current_Project_changed")
	return OK
	
func rename_flow(flowname,_changes):
	if current_project.Flows.has(flowname):
		#FORCE_SAVE
		current_project.Flows[_changes] = current_project.Flows[flowname]
		current_project.Flows.erase(flowname)
		emit_signal("current_Project_changed")
		return OK
	return FAILED
	
func delete_flow(flowname):
	if current_project.Flows.has(flowname):
		current_project.Flows.erase(flowname)
		emit_signal("current_Project_changed")
		return OK
	return FAILED
	
func run_current_flow(_params):
	pass
	
func save_current_benchpress():
	pass
	
func current_Project_changed(newvalue):
	current_project = newvalue
	emit_signal("current_Project_changed")
	
func highlighted_element_changed(newvalue):
	highlighted_element = newvalue
	emit_signal("highlighted_element_changed")
	
func selected_flow_changed(newvalue):
	selected_flow = newvalue
	emit_signal("current_Project_changed")
	
func get_LibraryElementStructure():
	var contents = dir_contents('user://Library').files
	LibraryElementStructure.clear()
	for file_name in contents:
		if file_name.get_extension() != 'benchpress': continue
		#get data .benchpress files that are type library store it in BenchPressfile		
		var BenchPressfile =saverReloader._load('user://Library/'+file_name)
		if BenchPressfile['FileState'] != 'Library':continue
		for SourceLibraryName in BenchPressfile['ElementStructures']:
			var uniqueSourceLibraryName = SourceLibraryName.get_slice("/", 0)+'/'+SourceLibraryName.get_slice("/", 0)+'/'+SourceLibraryName.get_slice("/", 1)+'/'+SourceLibraryName.get_slice("/", 2)
			var makeunique = 0
			while LibraryElementStructure.has(uniqueSourceLibraryName):
				makeunique += 1
				uniqueSourceLibraryName =(SourceLibraryName.get_slice("/", 0)+str(makeunique))+'/'+SourceLibraryName.get_slice("/", 0)+'/'+SourceLibraryName.get_slice("/", 1)+'/'+SourceLibraryName.get_slice("/", 2)
			LibraryElementStructure[uniqueSourceLibraryName] = BenchPressfile['ElementStructures'][SourceLibraryName]
	emit_signal("LibraryElementStructure_Constructed")
	
func dir_contents(path):
	var contents = {
		'directories':[],
		'files':[],
	}
	var directory = Directory.new()
	if directory.open(path) == OK:
		directory.list_dir_begin(true)
		var file_name = directory.get_next()
		while file_name != "":
			if directory.current_is_dir():
				contents['directories'].append(file_name)
			else:
				contents['files'].append(file_name)
			file_name = directory.get_next()
	return contents
	
func create_dir(dirAndFiles = structures.custom_user_folders):
	var directory = Directory.new()
	for dir in dirAndFiles:
		if  ! directory.dir_exists(dir):
			directory.make_dir_recursive(dir)
		for copyfile in dirAndFiles[dir]:
			if ! directory.file_exists(dir +'/'+copyfile) and directory.file_exists(dirAndFiles[dir][copyfile]):
				directory.copy(dirAndFiles[dir][copyfile],dir+'/'+copyfile)
			var file = File.new()
			if file.get_sha256(dir +'/'+copyfile) != file.get_sha256(dirAndFiles[dir][copyfile]):
				directory.copy(dirAndFiles[dir][copyfile],dir+'/'+copyfile)
	
func unique_name(names:PoolStringArray,newName:String):
	if ! names.has(newName): return newName
	#remove any numerals ends on newName
	var newName_CharacterIndex =range(len(newName))
	newName_CharacterIndex.invert()
	var arrayNumbers = PoolStringArray(range(10))
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
	

