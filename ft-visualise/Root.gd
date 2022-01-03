extends Node

var errors = []
var labels_menu = {}
var labels_config = {}

# Scene instance variables.
var menu = null
var config = null

func _ready():
	menu = create_instance('res://ft-visualise/UI/Menu.tscn')
	config = create_instance('res://ft-visualise/UI/Config.tscn')
	self.add_child(menu)
	
	# Reshape the UI after instancing to apply custom font variables.
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
							
							if not 'pulse1' in labels_menu.keys():
								labels_menu['pulse1'] = element.get_parent().get_node('Pulse1Label')
						'LOAD PULSE 2':
							element.connect('pressed', self, '_on_Pulse2_pressed')
							
							if not 'pulse2' in labels_menu.keys():
								labels_menu['pulse2'] = element.get_parent().get_node('Pulse2Label')
						'LOAD TRIANGLE':
							element.connect('pressed', self, '_on_Triangle_pressed')
							
							if not 'triangle' in labels_menu.keys():
								labels_menu['triangle'] = element.get_parent().get_node('TriangleLabel')
						'LOAD NOISE':
							element.connect('pressed', self, '_on_Noise_pressed')
							
							if not 'noise' in labels_menu.keys():
								labels_menu['noise'] = element.get_parent().get_node('NoiseLabel')
						'LOAD DPCM':
							element.connect('pressed', self, '_on_DPCM_pressed')
							
							if not 'dpcm' in labels_menu.keys():
								labels_menu['dpcm'] = element.get_parent().get_node('DPCMLabel')
				elif element is Label:
					element.set('custom_fonts/font', GlobalFont.getLabelFont())
					
	var footer_container = container.find_node('ConfigContainer')
	var footer_button = footer_container.get_child(0)
	
	if null != footer_button and footer_button is Button:
		footer_button.set('custom_fonts/font', GlobalFont.getButtonFont())
		footer_button.connect('pressed', self, '_on_ConfigButton_pressed')
		
func formatConfigElements(container : MarginContainer) -> void:
	var header = container.find_node('ConfigTitleContainer')
	var header_label = header.get_child(0)
	
	if null != header_label and header_label is Label:
		header_label.set('custom_fonts/font', GlobalFont.getTitleFont())
		
	var button_container = container.find_node('ConfigLoadListContainer')
	
	if null != button_container:
		for row in button_container.get_children():
			for element in row.get_children():
				if element is Button:
					element.set('custom_fonts/font', GlobalFont.getButtonFont())
					
					match element.text.to_upper():
						'LOAD JSON':
							element.connect('pressed', self, '_on_JSON_pressed')
							
							if not 'json' in labels_config.keys():
								labels_config['json'] = element.get_parent().get_node('JSONLabel')
						'LOAD CSV':
							element.connect('pressed', self, '_on_CSV_pressed')
							
							if not 'csv' in labels_config.keys():
								labels_config['csv'] = element.get_parent().get_node('CSVLabel')
				elif element is Label:
					element.set('custom_fonts/font', GlobalFont.getLabelFont())
					
	var footer_container = container.find_node('LaunchContainer')
	var footer_button = footer_container.get_child(0)
	
	if null != footer_button and footer_button is Button:
		footer_button.set('custom_fonts/font', GlobalFont.getButtonFont())
		footer_button.connect('pressed', self, '_on_LaunchButton_pressed')
	
func setupDialog(base_container : MarginContainer, extension : String, ident : String) -> void:
	var dialog = create_instance('res://ft-visualise/FileHandler/Finder.tscn')
	dialog.setFilter(extension)
	dialog.setIdentifier(ident)
	
	base_container.add_child(dialog)
	dialog.popup()
	
	dialog.connect('file_selected', dialog, '_on_FileFinder_file_selected')
	dialog.connect('popup_hide', dialog, '_on_FileFinder_popup_hide')
	dialog.connect('path_selected', self, '_on_FileFinder_path_selected')
	
# Ensure that we attempt to check whether the
# provided paths may or may not exist via
# simple string validation.
func verifyPaths() -> bool:
	if 5 != len(labels_menu):
		self.errors.append('Full path data not provided for parsing.')
		
	for path in labels_menu.values():
		if not path:
			# Label has been lost from the scene.
			errors.append('Non-existent label object provided.')
		elif not path.text:
			# Label text is missing.
			errors.append('%s path missing.' % path.name)
		elif '...' == path.text:
			# String still hasn't been modified since launch.
			errors.append('%s path missing.' % path.name)
		elif not path.text.begins_with('/'):
			# Linux-specific path checks.
			errors.append('%s path invalid.' % path.name)
	
	if 0 < len(errors):
		return false
	else:
		return true
	
func getErrorStrings() -> String:
	var output = ''
	
	for error in errors:
		output += (error + '\n')
		
	# Remove existing errors to avoid later duplication.
	self.clearErrors()
		
	return output
	
func clearErrors() -> void:
	self.errors = []
	
func _on_Pulse1_pressed() -> void:
	setupDialog(menu, '*.wav ; WAV Files', 'pulse1')
	
func _on_Pulse2_pressed() -> void:
	setupDialog(menu, '*.wav ; WAV Files', 'pulse2')
	
func _on_Triangle_pressed() -> void:
	setupDialog(menu, '*.wav ; WAV Files', 'triangle')
	
func _on_Noise_pressed() -> void:
	setupDialog(menu, '*.wav ; WAV Files', 'noise')
	
func _on_DPCM_pressed() -> void:
	setupDialog(menu, '*.wav ; WAV Files', 'dpcm')
	
func _on_JSON_pressed() -> void:
	setupDialog(config, '*.json ; JSON Files', 'json')
	
func _on_CSV_pressed() -> void:
	setupDialog(config, '*.csv ; CSV Files', 'csv')
	
func _on_ConfigButton_pressed() -> void:
	if self.verifyPaths():
		menu.propagate_call('queue_free', [])
		
		self.add_child(config)
		self.formatConfigElements(config)
	else:
		var notify_error = AcceptDialog.new()
		notify_error.dialog_text = "Invalid file path(s) provided.\n\n" + self.getErrorStrings()
		self.add_child(notify_error)
		notify_error.popup_centered_clamped()
		notify_error.popup()
		
func _on_LaunchButton_pressed() -> void:
	pass

func _on_FileFinder_path_selected(path : String, ident : String):
	if labels_menu.has(ident) and labels_menu[ident]:
		labels_menu[ident].text = path
	elif labels_config.has(ident) and labels_config[ident]:
		labels_config[ident].text = path
