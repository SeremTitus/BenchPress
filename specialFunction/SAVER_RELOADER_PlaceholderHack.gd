extends Resource
@export var data:Dictionary

#File  is saved as .res but the file is renamed to .benchpress
#ToBe: reimplimented using ResourceFormatLoader and  ResourceFormatSaver


func _save(path,newdata = {}):
	data = newdata
	if verify_blenchpress_data(data) != OK :
			return FAILED
	rename_file(path,change_extention(path,'res'))
	path = change_extention(path,'res')
	var result  =  ResourceSaver.save(self,path,1)
	rename_file(path,change_extention(path,'benchpress'))
	return result
	
func _load(path):
	rename_file(path,change_extention(path,'res'))
	path = change_extention(path,'res')
	var result = FAILED
	if ResourceLoader.exists(path):
		result  =  load(path).data.duplicate(true)
		if verify_blenchpress_data(result) != OK :
			result = FAILED
	rename_file(path,change_extention(path,'benchpress'))
	return result

func change_extention(file:String,newextention:String):	
	var filerename = file.substr(0,len(file)-(len(file.get_extension())))
	filerename = filerename + newextention
	return filerename
	
func rename_file(file:String,newName:String):
	if  FileAccess.file_exists(file):
		var dir = DirAccess.open(file)
		dir.rename(file,newName)


func verify_blenchpress_data(testdata):
	#Ensures blenchpress file adhire to file Action defined in Action.gd
	if typeof(testdata) != TYPE_DICTIONARY  or testdata.empty(): return FAILED
	var Actions = preload("res://specialFunction/structrures.gd").new()
	var level_1 = Actions.BenchPress.keys()
	for key in testdata:
		if ! level_1.has(key): return FAILED
	var level_2 = Actions.ActionCallAction.keys()
	for key in testdata['ActionCallActions']:
		for ActionCallkey in testdata['ActionCallActions'][key]:
			if ! level_2.has(ActionCallkey): return FAILED
	return OK

	
	
