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
					
					match element.text.to_upper():
						'LOAD PULSE 1':
							element.connect('pressed', self, '_on_Pulse1_pressed')
						'LOAD PULSE 2':
							element.connect('pressed', self, '_on_Pulse2_pressed')
						'LOAD TRIANGLE':
							element.connect('pressed', self, '_on_Triangle_pressed')
						'LOAD NOISE':
							element.connect('pressed', self, '_on_Noise_pressed')
						'LOAD DPCM':
							element.connect('pressed', self, '_on_DPCM_pressed')
	
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
	
func _on_Pulse1_pressed():
	var dialog = create_instance('res://ft-visualise/FileLoader/FileLoader.tscn')
	menu.add_child(dialog)
	
	dialog.popup()
	
func _on_Pulse2_pressed():
	print('Pulse 2')
	
func _on_Triangle_pressed():
	print('Pulse 3')
	
func _on_Noise_pressed():
	print('Pulse 4')
	
func _on_DPCM_pressed():
	print('Pulse 5')
