extends Node2D

var focused := false:
	set(p_focused):
		focused = p_focused
		visible = focused
var char_timings: Array[CharTiming] = []
var active_timings: Array[CharTiming] = []

func _ready() -> void:
	for character: Character in Global.characters:
		var char_timing := preload("res://ui/battle/attack_timing/char_timing/char_timing.tscn").instantiate()
		char_timing.set_from_character(character)
		$CharTimings.add_child(char_timing)
		char_timings.append(char_timing)

func set_as_attacking(p_char: int, p_is_attacking: bool) -> void:
	char_timings[p_char].set_active(p_is_attacking)
	active_timings.append(char_timings[p_char])
