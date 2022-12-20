extends Node


var saverReloader=preload("res://SAVER_RELOADER_PlaceholderHack.gd").new()
var LibraryElementStructure = {}
var current_project = {}
var GlobalVariables = {}
var FlowVariables = []

var highlighted_element

func _ready():
	create_dir()
	get_LibraryElementStructure()
	
func get_LibraryElementStructure():
	var contents = dir_contents('user://Library').files
	LibraryElementStructure.clear()
	for file_name in contents:
		if file_name.get_extension() != 'benchpress': continue
		#get data .benchpress files that are type library store it in BenchPressfile		
		var BenchPressfile =saverReloader._load('user://Library/'+file_name)
		for SourceLibraryName in BenchPressfile['ElementStructures']:
			var uniqueSourceLibraryName = SourceLibraryName.get_slice("/", 0)+'/'+SourceLibraryName.get_slice("/", 0)+'/'+SourceLibraryName.get_slice("/", 1)+'/'+SourceLibraryName.get_slice("/", 2)
			var makeunique = 0
			while LibraryElementStructure.has(uniqueSourceLibraryName):
				makeunique += 1
				uniqueSourceLibraryName =(SourceLibraryName.get_slice("/", 0)+str(makeunique))+'/'+SourceLibraryName.get_slice("/", 0)+'/'+SourceLibraryName.get_slice("/", 1)+'/'+SourceLibraryName.get_slice("/", 2)
			LibraryElementStructure[uniqueSourceLibraryName] = BenchPressfile['ElementStructures'][SourceLibraryName]
	
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
	
func create_dir(dirAndFiles = {
		'user://Library' : {"icon.png":"res://icon.png"},
		'user://Editor' : {},
		'user://Flows' : {},
		'user://Running' : {},
	}):
	var directory = Directory.new()
	for dir in dirAndFiles:
		if  ! directory.dir_exists(dir):
			directory.make_dir_recursive(dir)
		for copyfile in dirAndFiles[dir]:
			if ! directory.file_exists(dir +'/'+copyfile):
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
