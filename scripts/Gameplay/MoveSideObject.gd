extends Node2D

@export var center_tolerance: float = 150.0
var dragging := false
var start_position: Vector2

func _ready() -> void:
	start_position = global_position

func _process(delta: float) -> void:
	var screen_center = get_viewport_rect().size / 2
	if global_position.distance_to(screen_center) <= center_tolerance:
		print(global_position.distance_to(screen_center))

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			if _is_event_on_object(event.position):
				dragging = true
		else:
			if dragging:
				dragging = false
				_check_center_or_reset()

	if (event is InputEventScreenDrag or event is InputEventMouseMotion) and dragging:
		global_position = event.position

func _check_center_or_reset():
	var viewport_center = get_viewport().get_visible_rect().size / 2
	if global_position.distance_to(viewport_center) < 300:
		print(global_position.distance_to(viewport_center))
		global_position = start_position
	else:
		global_position = start_position

func _is_event_on_object(point: Vector2) -> bool:
	var sprite: Sprite2D = get_node_or_null("Sprite2D")
	if sprite:
		return sprite.get_rect().has_point(sprite.to_local(point))
	var size := Vector2(300, 300)
	var rect := Rect2(-size * 0.5, size)
	return rect.has_point(to_local(point))
