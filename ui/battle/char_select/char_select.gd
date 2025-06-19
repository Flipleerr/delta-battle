extends Node2D

var focused := false:
	set(p_focused):
		focused = p_focused
		visible = focused
		for char_panel: CharPanel in char_panels:
			char_panel.set_select(false)
		selected_item = selected_item
var selected_item := 0:
	set(p_selected_item):
		if char_panels.is_empty():
			initialize_panels()
			selected_item = 0
			return
		if char_panels[selected_item]:
			char_panels[selected_item].set_select(false)
			Global.characters[char_panels[selected_item].char_id].set_selected(false)
		selected_item = p_selected_item
		char_panels[selected_item].set_select(true)
		Global.characters[char_panels[selected_item].char_id].set_selected(true and focused)
var char_panels: Array[CharPanel] = []

func _ready() -> void:
	initialize_panels()

func initialize_panels() -> void:
	for char_panel: CharPanel in char_panels:
		char_panel.queue_free()
	char_panels.clear()
	for character: Character in Global.characters:
		var char_panel := preload("res://ui/battle/char_select/char_panel/char_panel.tscn").instantiate()
		char_panel.set_from_character(character)
		$Characters.add_child(char_panel)
		char_panels.append(char_panel)
	if !char_panels.is_empty():
		char_panels[0].set_select(true)

func _unhandled_key_input(p_event: InputEvent) -> void:
	if focused and p_event is InputEventKey and p_event.is_pressed():
		var prev_item := selected_item
		if p_event.is_action("up"):
			selected_item = wrapi(selected_item - 1, 0, char_panels.size())
		elif p_event.is_action("down"):
			selected_item =  wrapi(selected_item + 1, 0, char_panels.size())
		if prev_item != selected_item:
			Sounds.play("snd_menumove")
