extends Node

onready var font_regular = load('res://ft-visualise/Assets/Fonts/NotoSans-Regular.ttf')
onready var font_bold = load('res://ft-visualise/Assets/Fonts/NotoSans-Bold.ttf')

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
