extends Node2D

var focused := false:
	set(p_focused):
		focused = p_focused
		visible = focused
		for monster_panel: MonsterPanel in monster_panels:
			monster_panel.set_select(false)
		selected_item = selected_item
var selected_item := 0:
	set(p_selected_item):
		if monster_panels.is_empty():
			initialize_panels()
			selected_item = 0
			return
		if monster_panels[selected_item]:
			monster_panels[selected_item].set_select(false)
			Global.monsters[monster_panels[selected_item].monster_id].set_selected(false)
		selected_item = p_selected_item
		monster_panels[selected_item].set_select(true)
		Global.monsters[monster_panels[selected_item].monster_id].set_selected(true and focused)
var monster_panels: Array[MonsterPanel] = []

func _ready() -> void:
	initialize_panels()
	Global.monster_killed.connect(initialize_panels)

func initialize_panels() -> void:
	for panel: MonsterPanel in monster_panels:
		panel.queue_free()
	monster_panels.clear()
	for monster: Monster in Global.monsters:
		if monster == null:
			continue
		var monster_panel := preload("res://ui/battle/monster_select/monster_panel/monster_panel.tscn").instantiate()
		monster_panel.set_from_monster(monster)
		$Monsters.add_child(monster_panel)
		monster_panels.append(monster_panel)
	if !monster_panels.is_empty():
		monster_panels[0].set_select(true)

func _unhandled_key_input(p_event: InputEvent) -> void:
	if focused and p_event is InputEventKey and p_event.is_pressed():
		if p_event.is_action("up"):
			selected_item = wrapi(selected_item - 1, 0, monster_panels.size())
		elif p_event.is_action("down"):
			selected_item =  wrapi(selected_item + 1, 0, monster_panels.size())
