extends Node

enum {
	FIGHT, ACT, ITEM, SPARE, DEFEND
}

const YELLOW := Color("#ffff00")
var tp := 0.0:
	set(p_tp):
		tp = p_tp
		tp_changed.emit()

signal tp_changed

var characters: Array[Character] = [
	preload("res://characters/blue/blue.tscn").instantiate(),
	preload("res://characters/blue/blue.tscn").instantiate(),
	preload("res://characters/blue/blue.tscn").instantiate()
]
var monsters: Array[Monster] = [
	preload("res://monsters/slime/slime.tscn").instantiate(),
	preload("res://monsters/slime/slime.tscn").instantiate()
]
var items: Array[Item] = [
	preload("res://items/dark_candy.tres"),
	preload("res://items/dark_candy.tres"),
	preload("res://items/dark_candy.tres"),
	preload("res://items/dark_candy.tres"),
	preload("res://items/dark_candy.tres"),
	preload("res://items/dark_candy.tres"),
	preload("res://items/dark_candy.tres"),
	preload("res://items/dark_candy.tres"),
	preload("res://items/dark_candy.tres")
]

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func get_opening_line() -> String:
	var lines := PackedStringArray()
	
	for monster: Monster in monsters:
		var line := monster.get_opening_line()
		if line != "":
			lines.append(monster.get_opening_line())
	
	if lines.is_empty():
		if Global.monsters.size() == 1:
			return "  * You encountered a monster!"
		return "  * You encountered some monsters!"
	return lines[randi_range(0, lines.size() - 1)]
