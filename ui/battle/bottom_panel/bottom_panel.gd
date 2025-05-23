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
			CONTEXT.ACT_SELECT:
				$ActSelect.visible = false
				$ActSelect.focused = false
			CONTEXT.MAGIC_SELECT:
				$MagicSelect.visible = false
				$MagicSelect.focused = false
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
				$ActSelect.reset_items()
				for act: Act in Global.characters[current_char].get_acts():
					$ActSelect.add_item(act.title)
				$ActSelect.visible = true
				$ActSelect.focused = true
				$ActSelect.selected_item = 0
			CONTEXT.MAGIC_SELECT:
				$MagicSelect.reset_items()
				for spell: Spell in Global.characters[current_char].get_spells():
					$MagicSelect.add_item(spell.title, spell.description, spell.tp_cost)
				$MagicSelect.visible = true
				$MagicSelect.focused = true
				$MagicSelect.selected_item = 0

var char_menus: Array[CharMenu] = []
var current_char := 0

var actions: Array[Action] = []

var waiting_for_text := false
signal text_finished

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
	$TextBox.text_finished.connect(text_is_finished)

func _unhandled_key_input(event: InputEvent) -> void:
	if waiting_for_text:
		return
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
					char_menus[current_char].deconfirm_action()
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
				actions[current_char].specific = $ActSelect.selected_item
				next_char()
				return
			CONTEXT.MAGIC_SELECT:
				if event.is_action("cancel"):
					context = CONTEXT.CHAR_MENU
					return
				actions[current_char].specific = $MagicSelect.selected_item
				next_char()
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
				$TextBox.hide_text()
				for char_menu: CharMenu in char_menus:
					char_menu.deconfirm_action()
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
		char_menus[current_char].confirm_action(actions[current_char].what)
	else:
		if current_char != -1:
			char_menus[current_char].deactivate()
			char_menus[current_char].confirm_action(actions[current_char].what)
		current_char += 1
		context = CONTEXT.CHAR_MENU

func show_text(p_text: String) -> void:
	$TextBox.hide_text()
	$TextBox.text = p_text
	$TextBox.show_text()
	waiting_for_text = true

func text_is_finished() -> void:
	text_finished.emit()
	waiting_for_text = false
