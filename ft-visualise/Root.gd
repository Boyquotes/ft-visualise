extends Node

var labels = {}
var menu = null

# Called when the node enters the scene tree for the first time.
func _ready():
	menu = create_instance('res://ft-visualise/UI/Menu.tscn')
	self.add_child(menu)
	
	self.formatMenuElements(menu)
	
func create_instance(s : String) -> Node:
	var scene = load(s)
	return scene.instance()

func formatMenuElements(container : MarginContainer) -> void:
	var header = container.find_node('TitleContainer')
	var header_label = header.get_child(0)
	
	if null != header_label and header_label is Label:
		header_label.set('custom_fonts/font', GlobalFont.getTitleFont())
	
	var button_container = container.find_node('LoadListContainer')
	
	if null != button_container:
		for row in button_container.get_children():
			for element in row.get_children():
				if element is Button:
					element.set('custom_fonts/font', GlobalFont.getButtonFont())
					
					match element.text.to_upper():
						'LOAD PULSE 1':
							element.connect('pressed', self, '_on_Pulse1_pressed')
							
							if not 'pulse1' in labels.keys():
								labels['pulse1'] = element.get_parent().get_node('Pulse1Label')
						'LOAD PULSE 2':
							element.connect('pressed', self, '_on_Pulse2_pressed')
							
							if not 'pulse2' in labels.keys():
								labels['pulse2'] = element.get_parent().get_node('Pulse2Label')
						'LOAD TRIANGLE':
							element.connect('pressed', self, '_on_Triangle_pressed')
							
							if not 'triangle' in labels.keys():
								labels['triangle'] = element.get_parent().get_node('TriangleLabel')
						'LOAD NOISE':
							element.connect('pressed', self, '_on_Noise_pressed')
							
							if not 'noise' in labels.keys():
								labels['noise'] = element.get_parent().get_node('NoiseLabel')
						'LOAD DPCM':
							element.connect('pressed', self, '_on_DPCM_pressed')
							
							if not 'dpcm' in labels.keys():
								labels['dpcm'] = element.get_parent().get_node('DPCMLabel')
				elif element is Label:
					element.set('custom_fonts/font', GlobalFont.getLabelFont())
					
	var footer_container = container.find_node('ConfigContainer')
	var footer_button = footer_container.get_child(0)
	
	if null != footer_button and footer_button is Button:
		footer_button.set('custom_fonts/font', GlobalFont.getButtonFont())
		footer_button.connect('pressed', self, '_on_ConfigButton_pressed')
	
func setupDialog(ident : String) -> void:
	var dialog = create_instance('res://ft-visualise/FileHandler/Finder.tscn')
	dialog.setIdentifier(ident)
	
	menu.add_child(dialog)
	dialog.popup()
	
	dialog.connect('file_selected', dialog, '_on_FileFinder_file_selected')
	dialog.connect('popup_hide', dialog, '_on_FileFinder_popup_hide')
	dialog.connect('path_selected', self, '_on_FileFinder_path_selected')
	
func verifyPaths() -> bool:
	if 5 != len(labels):
		return false
	
	for path in labels:
		if not path:
			return false
		elif '...' == path:
			return false
		elif not path.begins_with('/'):
			return false
	
	return true
	
func _on_Pulse1_pressed() -> void:
	setupDialog('pulse1')
	
func _on_Pulse2_pressed() -> void:
	setupDialog('pulse2')
	
func _on_Triangle_pressed() -> void:
	setupDialog('triangle')
	
func _on_Noise_pressed() -> void:
	setupDialog('noise')
	
func _on_DPCM_pressed() -> void:
	setupDialog('dpcm')
	
func _on_ConfigButton_pressed() -> void:
	if self.verifyPaths():
		print('Start.')
	else:
		var notify_error = AcceptDialog.new()
		notify_error.dialog_text = "Invalid file path(s) provided."
		self.add_child(notify_error)
		notify_error.popup_centered_clamped()
		notify_error.popup()

func _on_FileFinder_path_selected(path : String, ident : String):
	if labels[ident]:
		labels[ident].text = path
