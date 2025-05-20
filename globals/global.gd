extends Node

enum {
	FIGHT, ACT, ITEM, SPARE, DEFEND
}

const YELLOW := Color("#ffff00")

var characters: Array[Character] = [
	preload("res://characters/blue/blue.tscn").instantiate(),
	preload("res://characters/blue/blue.tscn").instantiate(),
	preload("res://characters/blue/blue.tscn").instantiate()
]
var monsters: Array[Monster] = [
	preload("res://monsters/slime/slime.tscn").instantiate(),
	preload("res://monsters/slime/slime.tscn").instantiate()
]
var items: Array[Item] = [preload("res://items/dark_candy.tres")]

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
