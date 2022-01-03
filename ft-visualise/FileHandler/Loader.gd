extends Node

onready var wave_table = []
onready var config_table = []

func loadAudio(streams : Array) -> void:
	for stream in streams:
		var file = File.new()
		
		if file.file_exists(stream):
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
	
func loadConfig(data : Array) -> void:
	pass
