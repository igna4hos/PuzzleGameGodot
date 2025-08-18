extends Node2D

@export var part_id: int = -1   # ID детали
#@onready var connector: Node3D = $SubViewportContainer/SubViewport/Node3D

var dragging := false
var start_pos: Vector2

func _ready() -> void:
	start_pos = global_position
	#if connector and connector.has_method("play_idle_rotation"):
		#connector.play_idle_rotation()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if _is_event_on_object(event.position):
			dragging = true
			#if connector and connector.has_method("on_drag_start"):
				#connector.on_drag_start()

	elif event is InputEventMouseButton and not event.pressed and dragging:
		dragging = false
		_on_drop()
		#if connector and connector.has_method("on_drag_end"):
			#connector.on_drag_end()

	elif event is InputEventMouseMotion and dragging:
		global_position = event.position

func _on_drop() -> void:
	#var controller = get_tree().root.get_node("MainScene/GameController")
	#if controller:
		#controller.try_attach_part(part_id)
	_reset_position()

func _reset_position() -> void:
	global_position = start_pos

func _is_event_on_object(point: Vector2) -> bool:
	var sprite: Sprite2D = get_node_or_null("Sprite2D")
	if sprite:
		return sprite.get_rect().has_point(sprite.to_local(point))
	return Rect2(-Vector2(200,200)/2, Vector2(200,200)).has_point(to_local(point))
