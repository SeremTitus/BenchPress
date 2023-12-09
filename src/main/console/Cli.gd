# TODO
class_name  Cli

static func  run() -> bool:
	var args = OS.get_cmdline_args()
	var _user_args = OS.get_cmdline_user_args()
	if args.size() < 1:
		return true
	return true
