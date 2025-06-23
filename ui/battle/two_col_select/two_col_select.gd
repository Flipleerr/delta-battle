extends Node2D

const MOVE_DIST := 6.0

@export var show_description := true
@export var show_tp := false

var focused := false:
	set(p_focused):
		focused = p_focused
		visible = focused
		for item: TwoColItem in items:
			item.set_select(false)
			if show_tp:
				item.update_modulation()
		selected_item = selected_item
var selected_item := 0:
	set(p_selected_item):
		if selected_item < visible_items.size():
			visible_items[selected_item].set_select(false)
		selected_item = p_selected_item
		if selected_item >= visible_items.size():
			selected_item = 0
		visible_items[selected_item].set_select(true)
		$Description.text = visible_items[selected_item].description
		$TP.text = str(roundi(visible_items[selected_item].tp)) + "%"
		$Clip/Items.position.y = 3.0
		if visible_items.size() > 6:
			if selected_item < 6:
				$UpArrow.visible = false
				$DownArrow.visible = true
			else:
				$UpArrow.visible = true
				$DownArrow.visible = false
				$Clip/Items.position.y -= 102.0

var initial_up_arrow_position := 0.0
var initial_down_arrow_position := 0.0
var arrows_moving_up := true
var arrows_moving := true

var visible_items: Array[TwoColItem] = []
var items: Array[TwoColItem] = []
var has_items := false

var selected_coords := Vector2i.ZERO:
	set(p_selected_coords):
		selected_coords = p_selected_coords
		selected_item = selected_coords.y * 2 + selected_coords.x

@onready var two_col_item_scene := preload("res://ui/battle/two_col_select/two_col_item/two_col_item.tscn")

func _ready() -> void:
	$Description.visible = show_description
	$TP.visible = show_tp
	initial_up_arrow_position = $UpArrow.position.y
	initial_down_arrow_position = $DownArrow.position.y

func _unhandled_key_input(p_event: InputEvent) -> void:
	if focused and p_event is InputEventKey and p_event.is_pressed():
		var prev_item := selected_item
		if p_event.is_action("up"):
			selected_coords.y = maxi(0, selected_coords.y - 1)
		elif p_event.is_action("down"):
			if selected_item >= visible_items.size() - 2:
				return
			selected_coords.y = selected_coords.y + 1
		elif p_event.is_action("left"):
			if visible_items.size() % 2 == 1 and selected_item == visible_items.size() - 1:
				return
			selected_coords.x = wrapi(selected_coords.x - 1, 0, 2)
		elif p_event.is_action("right"):
			if visible_items.size() % 2 == 1 and selected_item == visible_items.size() - 1:
				return
			selected_coords.x = wrapi(selected_coords.x + 1, 0, 2)
		if prev_item != selected_item:
			Sounds.play("snd_menumove")

func reset_items() -> void:
	visible_items.clear()
	items.clear()
	for item: TwoColItem in $Clip/Items.get_children():
		item.queue_free()
	has_items = false

func add_item(p_name: String, p_description := "", p_tp := 0.0) -> void:
	var new_item: TwoColItem = two_col_item_scene.instantiate()
	new_item.initialize(p_name, p_description, p_tp)
	$Clip/Items.add_child(new_item)
	items.append(new_item)
	visible_items.append(new_item)
	has_items = true

func add_items(p_names: Array[String], p_descriptions: Array[String]) -> void:
	for i: int in p_names.size():
		var new_item: TwoColItem = two_col_item_scene.instantiate()
		if p_descriptions.is_empty():
			new_item.initialize(p_names[i], "")
		else:
			new_item.initialize(p_names[i], p_descriptions[i])
		$Clip/Items.add_child(new_item)
		items.append(new_item)
		visible_items.append(new_item)
	if !p_names.is_empty():
		has_items = true

func show_item(p_index: int, p_show := true) -> void:
	var item := items[p_index]
	if item.visible and !p_show:
		item.visible = false
		item.set_select(false)
		visible_items.erase(item)
	elif !item.visible and p_show:
		item.visible = true
		var temp_index := 0
		var prev_index := 0
		var to_index := 0
		while to_index <= p_index and temp_index < items.size():
			prev_index = to_index
			to_index = visible_items.find(items[temp_index])
			if to_index == -1:
				to_index = prev_index
			temp_index += 1
		visible_items.insert(prev_index, item)
	has_items = !visible_items.is_empty()

func get_current_item() -> int:
	return items.find(visible_items[selected_item])

func _process(delta: float) -> void:
	if arrows_moving:
		move_arrows(delta)

func move_arrows(delta: float) -> void:
	if arrows_moving_up:
		$UpArrow.position.y -= 15.0 * delta
		$DownArrow.position.y -= 15.0 * delta
		if $UpArrow.position.y - initial_up_arrow_position < -MOVE_DIST:
			$UpArrow.position.y = initial_up_arrow_position - MOVE_DIST
			$DownArrow.position.y = initial_down_arrow_position - MOVE_DIST
			arrows_moving_up = false
			arrows_moving = false
			await get_tree().create_timer(0.15).timeout
			arrows_moving = true
	else:
		$UpArrow.position.y += 15.0 * delta
		$DownArrow.position.y += 15.0 * delta
		if $UpArrow.position.y - initial_up_arrow_position > 0.0:
			$UpArrow.position.y = initial_up_arrow_position
			$DownArrow.position.y = initial_down_arrow_position
			arrows_moving_up = true
			arrows_moving = false
			await get_tree().create_timer(0.15).timeout
			arrows_moving = true
