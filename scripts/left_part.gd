extends Sprite2D

@export var snap_distance: float = 200
var start_position: Vector2
var dragging := false

func _ready():
	start_position = global_position

func reset_position():
	global_position = start_position

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				dragging = true
		else:
			if dragging:
				dragging = false
				_check_center_or_reset()

	elif event is InputEventScreenDrag or event is InputEventMouseMotion:
		if dragging:
			global_position = event.position

func _check_center_or_reset():
	var viewport_center = get_viewport().get_visible_rect().size / 2
	if global_position.distance_to(viewport_center) < snap_distance and get_meta("is_correct"):
		get_parent().on_correct_part_delivered(self)
	else:
		reset_position()
