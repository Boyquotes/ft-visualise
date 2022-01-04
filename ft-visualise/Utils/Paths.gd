extends Node

onready var audio_paths = []
onready var config_paths = []

onready var errors = []

func displayError(parent : Node, message : String) -> void:
	var notify_error = AcceptDialog.new()
	notify_error.dialog_text = '%s\n\n%s' % [message, self.getErrorStrings()]
	
	parent.add_child(notify_error)
	notify_error.popup_centered_clamped()
	notify_error.popup()

func getErrorStrings() -> String:
	var output = ''
	
	for error in errors:
		output += (error + '\n')
		
	# Remove existing errors to avoid later duplication.
	self.clearErrors()
		
	return output
	
func clearErrors() -> void:
	self.errors = []
