extends Control
class_name TwoColItem

var title := ""
var description := ""
var tp := 0.0

func initialize(p_title: String, p_description := "", p_tp := 0.0) -> void:
	title = p_title
	description = p_description
	tp = p_tp
	$Label.text = title

func set_select(p_select: bool) -> void:
	$Heart.visible = p_select

func update_modulation() -> void:
	if tp > Global.tp:
		modulate = Color("#808080")
	else:
		modulate = Color.WHITE
