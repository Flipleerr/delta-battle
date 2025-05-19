extends Node

const YELLOW := Color("#ffff00")

var characters: Array[Character] = [preload("res://characters/blue/blue.tscn").instantiate()]
var items: Array[Item] = [preload("res://items/dark_candy.tres")]

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
