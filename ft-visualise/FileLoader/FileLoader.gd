extends FileDialog

var initialPosition : Vector2

func _ready():
	self.applyMods()
	# Track initial popup location to clamp window to.
	initialPosition = self.get_position()
	
func _input(event):
	# Only trigger position resets on mouse button drag actions.
	if event is InputEventMouseButton:
		# As we can't disable FileDialog mouse events, we instead have to
		# reset the window's position every time the user attempts to
		# move the "Open A File" dialog window.
		self.set_position(initialPosition)
	
func applyMods():
	self.access = FileDialog.ACCESS_FILESYSTEM
	self.mode = FileDialog.MODE_OPEN_FILE
	
	self.popup_centered_clamped(Vector2(720, 420))
	self.add_filter('*.wav ; WAV Files')

func _on_FileLoader_file_selected(path: String):
	if path:
		print(path)
	
	self.propagate_call('queue_free', [])
