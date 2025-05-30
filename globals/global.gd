extends Node

enum {
	FIGHT, ACT, ITEM, SPARE, DEFEND
}

const YELLOW := Color("#ffff00")
const GREEN := Color("#00ff00")
const CENTER := Vector2(308.0, 171.0)
var tp := 0.0:
	set(p_tp):
		tp = minf(p_tp, 100.0)
		tp_changed.emit()

signal tp_changed
signal monster_killed
signal display_text(p_text: String, p_requires_input: bool)
signal text_finished

var displaying_text := false
var characters: Array[Character] = []
var monsters: Array[Monster] = []
var items: Array[Item] = []

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

func get_idle_line() -> String:
	var lines := PackedStringArray()
	
	for monster: Monster in monsters:
		if monster == null:
			continue
		var line := monster.get_idle_line()
		if line != "":
			lines.append(monster.get_idle_line())
	
	if lines.is_empty():
		if Global.monsters.size() == 1:
			return "  * The battle goes on..."
	return lines[randi_range(0, lines.size() - 1)]

func delete_monster(p_monster: Monster) -> void:
	monsters[monsters.find(p_monster)] = null
	var monsters_dead := true
	for monster: Monster in monsters:
		if monster != null:
			monsters_dead = false
			break
	print(monsters)
	if monsters_dead:
		await p_monster.exit_finished
		change_to_scene("res://scenes/win_screen/win_screen.tscn")
	monster_killed.emit()

func delete_item(p_item: int) -> void:
	items[p_item] = null

func change_to_scene(scene_path: String) -> void:
	PostProcessing.fade_out()
	get_tree().paused = true
	await PostProcessing.fade_finished
	get_tree().change_scene_to_file(scene_path)
	PostProcessing.fade_in()
	await PostProcessing.fade_finished
	get_tree().paused = false
