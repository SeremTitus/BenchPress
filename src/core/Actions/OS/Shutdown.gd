extends Action

func _init() -> void:
	title = 'shutdown_device'
	imports.append('os')
	supported.append(Platforms.Win)
	code = "
	if platform.system() == 'Windows':
		os.system('shutdown /s /t 0')
	elif platform.system() == 'Linux' or platform.system() == 'Darwin':  # Linux or macOS
		os.system('sudo poweroff')
	else:
		print('Power Off Desktop: Unsupported operating system.')
	"
