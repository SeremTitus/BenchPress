extends Action

func _init() -> void:
	title = 'lock_desktop'
	imports.append('os')
	imports.append('platform')
	imports.append('subprocess')
	imports.append('ctypes')
	supported.append(Platforms.all)
	code = "
	current_os = platform.system()

	if current_os == 'Windows':
		# Lock the desktop on Windows
		import ctypes
		ctypes.windll.user32.LockWorkStation()

	elif current_os == 'Linux':
		# Lock the desktop on Linux (common desktop environments)
		try:
			# GNOME or compatible desktop environments
			subprocess.run(['gnome-screensaver-command', '-l'], check=True)
		except FileNotFoundError:
			try:
				# KDE or compatible desktop environments
				subprocess.run(['qdbus', 'org.freedesktop.ScreenSaver', '/ScreenSaver', 'Lock'], check=True)
			except FileNotFoundError:
				print('Lock Desktop: Unable to lock screen. Ensure you have a compatible screen locker installed.')

	elif current_os == 'Darwin':
		# Lock the desktop on macOS
		subprocess.run(['/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession', '-suspend'])

	else:
		print(f'Lock Desktop: Locking is not supported on {current_os}.')
	"
