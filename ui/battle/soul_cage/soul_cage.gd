extends StaticBody2D

@onready var collision_shapes: Array[CollisionShape2D] = [
	$LeftWall, $RightWall, $TopWall, $BottomWall
]
var expanding := false
var contracting := false
var z_offset := 0
var outline_stylebox := preload("res://ui/battle/soul_cage/cage_outline.stylebox")

signal finished_animation

func expand() -> void:
	$Panel.visible = true
	expanding = true
	$Panel.scale = Vector2.ZERO
	$Panel.rotation_degrees = -180.0
	var tween := get_tree().create_tween().set_parallel(true)
	tween.tween_property($Panel, "scale", Vector2.ONE, 0.5)
	tween.tween_property($Panel, "rotation_degrees", 0.0, 0.5)
	tween.finished.connect(finish_expanding)
	z_offset = 0

func contract() -> void:
	contracting = true
	var tween := get_tree().create_tween().set_parallel(true)
	tween.tween_property($Panel, "scale", Vector2.ZERO, 0.5)
	tween.tween_property($Panel, "rotation_degrees", -180.0, 0.5)
	tween.finished.connect(finish_contracting)
	z_offset = 0

func finish_expanding() -> void:
	expanding = false
	for wall: CollisionShape2D in collision_shapes:
		wall.disabled = false

func finish_contracting() -> void:
	contracting = false
	for wall: CollisionShape2D in collision_shapes:
		wall.disabled = true

func _process(delta: float) -> void:
	if expanding or contracting:
		var new_panel: Panel = $Panel.duplicate()
		new_panel.add_theme_stylebox_override("panel", outline_stylebox)
		new_panel.z_index = z_offset
		z_offset += 1
		$Copies.add_child(new_panel)
	if $Copies.get_child_count() != 0:
		var children := $Copies.get_child_count()
		for child: Panel in $Copies.get_children():
			child.modulate.a -= 5.0 * delta
			if child.modulate.a <= 0.0:
				child.queue_free()
				children -= 1
		if children <= 0:
			finished_animation.emit()
