extends Node2D

func _ready() -> void:
	Global.tp_changed.connect(set_tp)

func set_tp() -> void:
	$Fill.material.set_shader_parameter("fill", Global.tp / 100.0)
	if is_equal_approx(Global.tp, 100.0):
		$Number.visible = false
		$TPMax.visible = true
	else:
		$Number.visible = true
		$TPMax.visible = false
		$Number.text = str(floori(Global.tp))
