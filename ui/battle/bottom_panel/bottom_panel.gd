extends Node2D

enum CONTEXT {
	BATTLE, CHAR_MENU, MONSTER_SELECT, ITEM_SELECT, ATTACK
}
var activated := false

func _ready() -> void:
	for character: Character in Global.characters:
		var char_menu := preload("res://ui/battle/char_menu/char_menu.tscn").instantiate()
		char_menu.set_from_character(character)
		$Characters.add_child(char_menu)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("confirm") and event.is_pressed():
		if !activated:
			$Characters.get_child(0).activate()
			activated = true
			$Characters.get_child(0).selected_item = 0
		else:
			$Characters.get_child(0).deactivate()
			activated = false
