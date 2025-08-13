extends Node2D

@onready var connector_controller: Node3D = $SubViewportContainer/SubViewport/Node3D

var dragging := false
var start_position: Vector2

func _ready() -> void:
	start_position = global_position
	if connector_controller and connector_controller.has_method("play_idle_rotation"):
		connector_controller.play_idle_rotation()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			if _is_event_on_object(event.position):
				dragging = true
				if connector_controller and connector_controller.has_method("on_drag_start"):
					connector_controller.on_drag_start()
		else:
			if dragging:
				dragging = false
				_reset_position()
				if connector_controller and connector_controller.has_method("on_drag_end"):
					connector_controller.on_drag_end()

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
