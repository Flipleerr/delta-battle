extends Node2D

enum CONTEXT {
	BATTLE, CHAR_MENU, MONSTER_SELECT, ITEM_SELECT, ACT_SELECT, MAGIC_SELECT, CHAR_SELECT, ACTION
}

class Action:
	var what: int
	var to: int
	var specific: int

var context := CONTEXT.BATTLE:
	set(p_context):
		match context:
			CONTEXT.CHAR_MENU:
				char_menus[current_char].focused = false
			CONTEXT.MONSTER_SELECT:
				$MonsterSelect.visible = false
				$MonsterSelect.focused = false
			CONTEXT.ITEM_SELECT:
				$ItemSelect.visible = false
				$ItemSelect.focused = false
		context = p_context
		match context:
			CONTEXT.BATTLE:
				get_parent().start_attack()
			CONTEXT.CHAR_MENU:
				char_menus[current_char].activate()
			CONTEXT.MONSTER_SELECT:
				$MonsterSelect.visible = true
				$MonsterSelect.focused = true
				$MonsterSelect.selected_item = 0
			CONTEXT.ITEM_SELECT:
				$ItemSelect.visible = true
				$ItemSelect.focused = true
				$ItemSelect.selected_item = 0
			CONTEXT.ACT_SELECT:
				pass

var char_menus: Array[CharMenu] = []
var current_char := 0

var actions: Array[Action] = []

func _ready() -> void:
	for character: Character in Global.characters:
		var char_menu := preload("res://ui/battle/char_menu/char_menu.tscn").instantiate()
		char_menu.set_from_character(character)
		$Characters.add_child(char_menu)
		char_menus.append(char_menu)
		actions.append(Action.new())
	for item: Item in Global.items:
		$ItemSelect.add_item(item.name, item.short_description)
	context = CONTEXT.CHAR_MENU

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action("confirm") or event.is_action("cancel")) and event.is_pressed():
		match context:
			CONTEXT.BATTLE:
				return
			CONTEXT.CHAR_MENU:
				if current_char == 0 and event.is_action("cancel"):
					return
				if event.is_action("cancel"):
					char_menus[current_char].deactivate()
					current_char -= 1
					char_menus[current_char].activate()
					return
				queue_character_action()
				return
			CONTEXT.MONSTER_SELECT:
				if event.is_action("cancel"):
					context = CONTEXT.CHAR_MENU
					return
				actions[current_char].to = $MonsterSelect.selected_item
				if actions[current_char].what == Global.ACT and !char_menus[current_char].uses_magic:
					context = CONTEXT.ACT_SELECT
					return
				next_char()
				return
			CONTEXT.ACT_SELECT:
				if event.is_action("cancel"):
					context = CONTEXT.MONSTER_SELECT
					return
				return
			CONTEXT.ITEM_SELECT:
				if event.is_action("cancel"):
					context = CONTEXT.CHAR_MENU
					return
				actions[current_char].specific = $ItemSelect.selected_item
				next_char()
				return
			CONTEXT.ACTION:
				context = CONTEXT.BATTLE
				return

func queue_character_action() -> void:
	match char_menus[current_char].selected_item:
		Global.FIGHT:
			actions[current_char].what = Global.FIGHT
			context = CONTEXT.MONSTER_SELECT
		Global.ACT:
			actions[current_char].what = Global.ACT
			if !char_menus[current_char].uses_magic:
				context = CONTEXT.MONSTER_SELECT
			else:
				context = CONTEXT.MAGIC_SELECT
		Global.ITEM:
			actions[current_char].what = Global.ITEM
			context = CONTEXT.ITEM_SELECT
		Global.SPARE:
			actions[current_char].what = Global.SPARE
			context = CONTEXT.MONSTER_SELECT
		Global.DEFEND:
			actions[current_char].what = Global.DEFEND
			next_char()

func next_char() -> void:
	if current_char == char_menus.size() - 1:
		context = CONTEXT.ACTION
		char_menus[current_char].deactivate()
	else:
		if current_char != -1:
			char_menus[current_char].deactivate()
		current_char += 1
		context = CONTEXT.CHAR_MENU
