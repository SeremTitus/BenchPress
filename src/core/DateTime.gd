class_name DateTime extends RefCounted

enum MonthName {
	January = 1,
	February,
	March,
	April,
	May,
	June,
	July,
	August,
	September,
	October,
	November,
	December
}
enum DaysInWeek {
	Sunday = 1,
	Monday,
	Tuesday,
	Wednesday,
	Thursday,
	Friday,
	Saturday
}

var year:int
var month:MonthName:set = set_month
var weekday:DaysInWeek:set = set_weekday
var day:int:set = set_day
var hour:int:set = set_hour
var minute:int:set = set_minute
var second:int:set = set_sec
var microsecond:int:set = set_microsecond

func set_month(new_value:int) -> void:
	if new_value > 12:
		month = new_value - 12 * floor(float(new_value) / 12.0)
		year += floor(float(new_value) / 12.0)
	else:
		@warning_ignore("int_as_enum_without_cast")
		month = new_value

func set_weekday(new_value:int) -> void:
	if new_value > 7:
		weekday = new_value - 7 * floor(float(new_value) / 7.0)
		day += floor(float(new_value) / 7.0)
	else:
		@warning_ignore("int_as_enum_without_cast")
		weekday = new_value

func set_day(new_value:int) -> void:
	if month > 12: set_month(month)
	if month == MonthName.January and new_value > 28:
		new_value = new_value - 28 * floor(float(new_value) / 28.0)
		month += floor(float(new_value) / 28.0)
	elif month in [MonthName.April, MonthName.June, MonthName.September,\
		MonthName.November] and new_value > 30:
		new_value = new_value - 30 * floor(float(new_value) / 30.0)
		month += floor(float(new_value) / 30.0)
	elif new_value > 31:
		new_value = new_value - 31 * floor(float(new_value) / 31.0)
		month += floor(float(new_value) / 31.0)
	day = new_value

func set_hour(new_value:int) -> void:
	if new_value > 24:
		hour = new_value - 24 * floor(float(new_value) / 24.0)
		day += floor(float(new_value) / 24.0)
	else:
		hour = new_value

func set_minute(new_value:int) -> void:
	if new_value > 60:
		minute = new_value - 60 * floor(float(new_value) / 60.0)
		hour += floor(float(new_value) / 60.0)
	else:
		minute = new_value

func set_sec(new_value:int) -> void:
	if new_value > 60:
		second = new_value - 60 * floor(float(new_value) / 60.0)
		minute += floor(float(new_value) / 60.0)
	else:
		second = new_value

func set_microsecond(new_value:int) -> void:
	if new_value > pow(10,6):
		microsecond = new_value - pow(10,6) * floor(float(new_value) / pow(10,6))
		second += floor(float(new_value) / pow(10,6))
	else:
		microsecond = new_value

func is_equal(compare_date_time:DateTime) -> bool:
	if not compare_date_time.year == null and not year == null and\
		not compare_date_time.year == year:
		return false
	if not compare_date_time.month == null and not month == null and\
		not compare_date_time.month == month:
		return false
	if not compare_date_time.weekday == null and not weekday == null and\
		not compare_date_time.weekday == weekday:
		return false
	if not compare_date_time.day == null and not day == null and\
		not compare_date_time.day == day:
		return false
	if not compare_date_time.hour == null and not hour == null and\
		not compare_date_time.hour == hour:
		return false
	if not compare_date_time.minute == null and not minute == null and\
		not compare_date_time.minute == minute:
		return false
	if not compare_date_time.second == null and not second == null and\
		not compare_date_time.second == second:
		return false
	if not compare_date_time.microsecond == null and not microsecond == null and\
		not compare_date_time.microsecond == microsecond:
		return false
	return true

func is_greater(compare_date_time:DateTime) -> bool:
	if not compare_date_time.year == null and not year == null and\
		compare_date_time.year < year:
		return true
	if not compare_date_time.month == null and not month == null and\
		compare_date_time.month < month:
		return true
	if not compare_date_time.weekday == null and not weekday == null and\
		compare_date_time.weekday < weekday:
		return true
	if not compare_date_time.day == null and not day == null and\
		compare_date_time.day < day:
		return true
	if not compare_date_time.hour == null and not hour == null and\
		compare_date_time.hour < hour:
		return true
	if not compare_date_time.minute == null and not minute == null and\
		compare_date_time.minute < minute:
		return true
	if not compare_date_time.second == null and not second == null and\
		compare_date_time.second < second:
		return true
	if not compare_date_time.microsecond == null and not microsecond == null and\
		compare_date_time.microsecond < microsecond:
		return true
	return false

func  is_lesser(compare_date_time:DateTime) -> bool:
	return not is_greater(compare_date_time)

func get_difference(compare_date_time:DateTime) -> DateTime:
	var multiplier:int = 1 if is_greater(compare_date_time) else -1
	var new_date_time:DateTime = DateTime.new()
	if not compare_date_time.year == null and not year == null:
		new_date_time.year = multiplier + year - compare_date_time.year
	if not compare_date_time.month == null and not month == null:
		@warning_ignore("int_as_enum_without_cast")
		new_date_time.month = multiplier + month - compare_date_time.month
	if not compare_date_time.weekday == null and not weekday == null:
		@warning_ignore("int_as_enum_without_cast")
		new_date_time.weekday = multiplier + weekday - compare_date_time.weekday
	if not compare_date_time.day == null and not day == null:
		new_date_time.day = multiplier + day - compare_date_time.day
	if not compare_date_time.hour == null and not hour == null:
		new_date_time.hour = multiplier + hour - compare_date_time.hour
	if not compare_date_time.minute == null and not minute == null:
		new_date_time.minute = multiplier + minute - compare_date_time.minute
	if not compare_date_time.second == null and not second == null:
		new_date_time.second = multiplier + second - compare_date_time.second
	if not compare_date_time.microsecond == null and not microsecond == null:
		new_date_time.microsecond = multiplier + microsecond - compare_date_time.microsecond
	return new_date_time

static func now() -> DateTime:
	var new_date_time:DateTime = DateTime.new()
	var system_date_time:Dictionary = Time.get_datetime_dict_from_system()
	new_date_time.year = system_date_time.year
	new_date_time.month = system_date_time.month
	new_date_time.weekday = system_date_time.weekday
	new_date_time.day = system_date_time.day
	new_date_time.hour = system_date_time.hour
	new_date_time.minute = system_date_time.minute
	new_date_time.second = system_date_time.second
	return new_date_time
