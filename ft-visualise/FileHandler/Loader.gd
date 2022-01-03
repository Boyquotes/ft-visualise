extends Node

onready var wave_table = []
onready var config_table = []

func loadAudio(streams : Array) -> void:
	for stream in streams:
		print(stream)
	
func loadConfig(data : Array) -> void:
	pass
