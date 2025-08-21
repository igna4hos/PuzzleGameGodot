extends Node2D

@export var center_tolerance: float = 150.0
var dragging := false
var start_position: Vector2
var part_id: int = -1

func _ready() -> void:
	start_position = global_position

func _process(delta: float) -> void:
	var screen_center = get_viewport_rect().size / 2
	if global_position.distance_to(screen_center) <= center_tolerance:
		_on_reach_center()
		
func _on_reach_center() -> void:
	var main_controller = get_tree().get_root().get_node("MainScene") # Scene title at the root
	if main_controller:
		var result = main_controller.try_attach_part(part_id)
		if result:
			_reset_position()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			if _is_event_on_object(event.position):
				dragging = true
		else:
			if dragging:
				dragging = false
				_reset_position()

	if (event is InputEventScreenDrag or event is InputEventMouseMotion) and dragging:
		global_position = event.position

func _reset_position() -> void:
	global_position = start_position

func _is_event_on_object(point: Vector2) -> bool:
	var sprite: Sprite2D = get_node_or_null("Sprite2D")
	if sprite:
		return sprite.get_rect().has_point(sprite.to_local(point))
	var size := Vector2(300, 300)
	var rect := Rect2(-size * 0.5, size)
	return rect.has_point(to_local(point))
