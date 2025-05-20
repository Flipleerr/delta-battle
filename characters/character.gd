extends Node2D
class_name Character

@export var title := ""
@export var current_hp := 100
@export var max_hp := 100
@export var uses_magic := false
@export_color_no_alpha var main_color := Color.WHITE
@export var icon: Texture2D = preload("res://ui/battle/char_menu/res/sample_char_icon.png")
