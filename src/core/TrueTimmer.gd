class_name TrueTimmer extends RefCounted

signal timeout

var time_left:DateTime = DateTime.new()
var threads:Array[Thread] = []

func start(second:float) -> void:
	time_left.set_sec(second)
	var timmer_thread:Thread = Thread.new()
	threads.append(timmer_thread)
	timmer_thread.start(timmer)

func timmer_ended() -> bool:
	end_dead_thread()
	return not bool(threads.size())

func timmer() -> void:
	var end_time:DateTime =  DateTime.now().get_cummulate(time_left)
	while end_time.is_greater(DateTime.now()):
		end_dead_thread()
	time_left = DateTime.new()
	timeout.emit()

func  end_dead_thread() -> void:
	for thread in threads:
		if not thread.is_alive():
			thread.wait_to_finish()
			threads.erase(thread)
