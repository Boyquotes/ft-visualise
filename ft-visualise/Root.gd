extends Node

var font_regular = load('res://ft-visualise/Assets/Fonts/NotoSans-Regular.ttf')
var font_bold = load('res://ft-visualise/Assets/Fonts/NotoSans-Bold.ttf')

var labels = {}
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
							labels['pulse1'] = element.get_parent().get_node('Pulse1Label')
						'LOAD PULSE 2':
							element.connect('pressed', self, '_on_Pulse2_pressed')
							labels['pulse2'] = element.get_parent().get_node('Pulse2Label')
						'LOAD TRIANGLE':
							element.connect('pressed', self, '_on_Triangle_pressed')
							labels['triangle'] = element.get_parent().get_node('TriangleLabel')
						'LOAD NOISE':
							element.connect('pressed', self, '_on_Noise_pressed')
							labels['noise'] = element.get_parent().get_node('NoiseLabel')
						'LOAD DPCM':
							element.connect('pressed', self, '_on_DPCM_pressed')
							labels['dpcm'] = element.get_parent().get_node('DPCMLabel')
				elif element is Label:
					element.set('custom_fonts/font', self.getLabelFont())
	
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
	
func getLabelFont() -> DynamicFont:
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = font_regular
	dynamic_font.size = 16
	
	return dynamic_font
	
func _on_Pulse1_pressed():
	var dialog = create_instance('res://ft-visualise/FileLoader/FileLoader.tscn')
	dialog.setIdentifier('pulse1')
	
	menu.add_child(dialog)
	dialog.popup()
	
	dialog.connect('file_selected', dialog, '_on_FileLoader_file_selected')
	dialog.connect('popup_hide', dialog, '_on_FileLoader_popup_hide')
	dialog.connect('path_selected', self, '_on_FileLoader_path_selected')
	
func _on_Pulse2_pressed():
	print('Pulse 2')
	
func _on_Triangle_pressed():
	print('Pulse 3')
	
func _on_Noise_pressed():
	print('Pulse 4')
	
func _on_DPCM_pressed():
	print('Pulse 5')

func _on_FileLoader_path_selected(path, ident):
	if labels[ident]:
		labels[ident].text = path
