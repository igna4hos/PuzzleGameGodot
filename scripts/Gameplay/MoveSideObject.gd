extends Node2D

@export var center_tolerance: float = 150.0
var dragging := false
var start_position: Vector2
var part_id: int = -1
@onready var connector_controller: Node = null

func _ready() -> void:
	start_position = global_position
	var sv := $SubViewportContainer/SubViewport
	if sv:
		connector_controller = sv.get_node_or_null("LeftElement")
		if connector_controller == null:
			connector_controller = sv.get_node_or_null("RightElement")
	if connector_controller and connector_controller.has_method("play_idle_rotation"):
		connector_controller.play_idle_rotation()

func _process(_delta: float) -> void:
	var screen_center = get_viewport_rect().size / 2
	if global_position.distance_to(screen_center) <= center_tolerance:
		_on_reach_center()
		
func _on_reach_center() -> void:
	var main_controller = get_tree().get_root().get_node("MainScene") # Scene title at the root
	if main_controller:
		var result = main_controller.try_attach_part(part_id)
		if result:
			dragging = false
			_reset_position()
			_on_drag_end()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			if _is_event_on_object(event.position):
				dragging = true
				_on_drag_start()
		else:
			if dragging:
				dragging = false
				_reset_position()
				_on_drag_end()

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
	
func _on_drag_start() -> void:
	if connector_controller and connector_controller.has_method("on_drag_start"):
		connector_controller.on_drag_start()

func _on_drag_end() -> void:
	if connector_controller and connector_controller.has_method("on_drag_end"):
		connector_controller.on_drag_end()
