extends Sprite2D

var dragging := false
var start_position: Vector2

func _ready():
	start_position = global_position

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				dragging = true
		else:
			if dragging:
				dragging = false
				_check_center_or_reset()

	if event is InputEventScreenDrag or event is InputEventMouseMotion:
		if dragging:
			global_position = event.position

func _check_center_or_reset():
	var viewport_center = get_viewport().get_visible_rect().size / 2
	if global_position.distance_to(viewport_center) < 300:
		get_tree().change_scene_to_file("res://left_part_ferrari_collect.tscn")
	else:
		global_position = start_position
