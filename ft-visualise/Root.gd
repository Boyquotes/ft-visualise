extends Node

var font_regular = load('res://ft-visualise/Assets/Fonts/NotoSans-Regular.ttf')
var font_bold = load('res://ft-visualise/Assets/Fonts/NotoSans-Bold.ttf')

var menu = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu = create_instance('res://ft-visualise/UI/Menu.tscn')
	self.add_child(menu)
	
	self.formatMenuElements(menu)
	
func create_instance(s):
	var scene = load(s)
	return scene.instance()

func formatMenuElements(container : MarginContainer) -> void:
	var header = container.find_node('TitleContainer')
	var header_label = header.get_child(0)
	
	if null != header_label:
		header_label.set('custom_fonts/font', self.getTitleFont())
	
	var button_container = container.find_node('LoadListContainer')
	
	if null != button_container:
		for row in button_container.get_children():
			for element in row.get_children():
				if element is Button:
					element.set('custom_fonts/font', self.getButtonFont())
	
func getTitleFont() -> DynamicFont:
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = font_bold
	dynamic_font.size = 48
	
	return dynamic_font
	
func getButtonFont() -> DynamicFont:
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = font_regular
	dynamic_font.size = 32
	
	return dynamic_font
