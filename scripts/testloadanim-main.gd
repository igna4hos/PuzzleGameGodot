extends Node2D

@onready var left_root: Node3D  = $LeftELementPart/SubViewportContainer/SubViewport/LeftElement
@onready var var_ref_left: Node2D  = $LeftELementPart
@onready var connector_controller: Node3D = $LeftELementPart/SubViewportContainer/SubViewport/LeftElement

var side_parts: Array = []

var current_index_side := 0

func _ready() -> void:
	var level_data = Global.model_kits.get(1, null)
	if level_data:
		side_parts = level_data["side_parts"]
	else:
		print("No data for level:", Global.selected_level)
	
	load_side_parts()
	await get_tree().create_timer(4.0).timeout
	_next_model()

func load_side_parts() -> void:
	for c in left_root.get_children():
		c.queue_free()

	var left_data = side_parts[(current_index_side) % side_parts.size()]
	var left_part = load(left_data.scene).instantiate()
	left_root.add_child(left_part)
	
	if connector_controller and connector_controller.has_method("demo_scale"):
		print("SCALE")
		connector_controller.demo_scale()
	if connector_controller and connector_controller.has_method("play_idle_rotation"):
		print("MOVE LEFT RIGHT")
		connector_controller.play_idle_rotation()

func _next_model() -> void:
	current_index_side += 1
	if current_index_side >= side_parts.size():
		current_index_side = 0
	load_side_parts()
