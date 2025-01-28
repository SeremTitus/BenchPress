extends Action

func _init() -> void:
	title = "reboot_device"
	imports.append("os")
	supported.append(Platforms.desk)
	code = "
	if platform.system() == 'Windows':
		os.system('shutdown /r /t 0')
	elif platform.system() == 'Linux' or platform.system() == 'Darwin':  # Linux or macOS
		os.system('sudo reboot')
	else:
		print('Reboot the desktop device.')
	"
