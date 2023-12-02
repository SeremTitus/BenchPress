class_name Schedule extends RefCounted

enum repeat_types{
	Skip = 0,
	Even,
	Odd
}

var fire_times:int = 0
var fire_date:DateTime
var active:bool = true
var repeat:bool = true
var repeat_type:repeat_types = repeat_types.Skip
var skip_interval:int = 0
var specific_date:DateTime
var start_date:DateTime
var end_date:DateTime
var interval_date:DateTime
var on_app_Start:String
var cron_rule:String


