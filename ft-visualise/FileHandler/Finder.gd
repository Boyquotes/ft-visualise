extends FileDialog

signal path_selected(path, ident)

var identifier = ''
var initialPosition : Vector2

var file_type = ''

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
	
func applyMods() -> void:
	self.access = FileDialog.ACCESS_FILESYSTEM
	self.mode = FileDialog.MODE_OPEN_FILE
	
	self.popup_centered_clamped(Vector2(720, 420))
	self.add_filter(self.getFilter())
	
func setFilter(filter : String):
	self.file_type = filter

func getFilter() -> String:
	return self.file_type

func setIdentifier(ident : String) -> void:
	self.identifier = ident
	
func getIdentifier() -> String:
	return self.identifier

func _on_FileFinder_file_selected(path: String) -> void:
	if path:
		emit_signal('path_selected', path, self.getIdentifier())
	
	self.propagate_call('queue_free', [])
	
func _on_FileFinder_popup_hide() -> void:
	self.propagate_call('queue_free', [])
