extends Node

var menu = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu = create_instance('res://ft-visualise/UI/Menu.tscn')
	self.add_child(menu)
	
func create_instance(s):
	var scene = load(s)
	return scene.instance()
