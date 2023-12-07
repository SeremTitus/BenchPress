class_name TrueTimmer extends RefCounted

signal timeout

var time_left:DateTime = DateTime.zero()
var threads:Array[Thread] = []

func start(second:float) -> void:
	time_left.set_sec(second)
	var timmer_thread:Thread = Thread.new()
	threads.append(timmer_thread)
	timmer_thread.start(timmer)

func timmer() -> void:
	var start_time:DateTime =  DateTime.now()
	while time_left.is_greater(DateTime.zero()):
		end_dead_thread()
		var diff:DateTime = start_time.get_difference(DateTime.now())
		time_left = time_left.get_difference(diff)
		if not diff.is_equal(DateTime.zero()):
			start_time =  DateTime.now()
	time_left = DateTime.zero()
	timeout.emit()

func  end_dead_thread() -> void:
	for thread in threads:
		if not thread.is_alive():
			thread.wait_to_finish()
			threads.erase(thread)
