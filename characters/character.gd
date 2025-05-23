extends Node2D
class_name Character

@export var title := ""
@export var current_hp := 100
@export var max_hp := 100
@export var uses_magic := false
@export_color_no_alpha var main_color := Color.WHITE
@export_color_no_alpha var icon_color := Color.GRAY
@export var icon: Texture2D = preload("res://ui/battle/char_menu/res/sample_char_icon.png")

## Override function
func get_acts() -> Array[Act]:
	var nothing := Act.new()
	nothing.title = "Do nothing"
	return [nothing]

## Override function
func get_spells() -> Array[Spell]:
	var nothing := Spell.new()
	nothing.title = "Nothing spell"
	nothing.tp_cost = 15
	return [nothing]
