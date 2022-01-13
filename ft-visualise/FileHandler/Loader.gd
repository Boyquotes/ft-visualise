extends Node

var config_map = {}
var headers = []

func loadAudio(streams : Array) -> void:
	for stream in streams:
		if localDataExists(stream):
			# AudioStreamSample nodes are used for WAV file processing
			# and playback.
			var sample = AudioStreamSample.new()
			sample.resource_path = stream
			
			# One AudioStreamPlayer node is required for each WAV sample
			# to allow for concurrent playback of each channel.
			var player = AudioStreamPlayer.new()
			player.stream = sample
			
			# Add each AudioStreamPlayer node as a child of the Root scene
			# so the loader can be dispatched as soon as the stream
			# loading and processing has been completed.
			get_tree().get_current_scene().add_child(player)
	
func loadConfig(raw_data : Array) -> Dictionary:
	for config in raw_data:
		if localDataExists(config):
			var file = File.new()
			file.open(config, file.READ)
			
			if config.ends_with('.json'):
				var json_data = parse_json(file.get_as_text())
				config_map['json'] = json_data
				
				# Gracefully close any open files.
				file.close()
			elif config.ends_with('.csv'):
				var csv_headers = file.get_csv_line(',')
				config_map['csv'] = {}
				
				for header in csv_headers:
					config_map['csv'][header] = []
					headers.append(header)
					
				var cell_counter = 0
				var next_line = []
				
				while not file.eof_reached():
					next_line = file.get_csv_line(',')
					
					for cell in next_line:
						config_map['csv'][getChannelHeader(cell_counter)].append(str(cell))
						cell_counter += 1
						
					cell_counter = 0
						
				# Gracefully close any open files.
				file.close()
	
	return config_map
	
func loadComplete() -> void:
	self.propagate_call('queue_free', [])

# Local file storage checking to ensure
# paths exist before attempting to
# load any data in said files.
func localDataExists(file : String) -> bool:
	var temp = File.new()
	
	if not temp.file_exists(file):
		return false
	else:
		return true
		
func getChannelHeader(index : int) -> String:
	if headers[index]:
		return headers[index]
	else:
		return 'invalid'
