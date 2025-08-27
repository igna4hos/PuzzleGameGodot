extends Node2D

@onready var center_model: Node3D = $CentralElementPart/SubViewportContainer/SubViewport/CentralElement
@onready var left_root: Node3D  = $LeftElementPart/SubViewportContainer/SubViewport/LeftElement
@onready var var_ref_left: Node2D  = $LeftElementPart
@onready var right_root: Node3D = $RightElementPart/SubViewportContainer/SubViewport/RightElement
@onready var var_ref_right: Node2D  = $RightElementPart

var center_models: Array = []
var side_parts: Array = []

var current_index_model := 0
var current_index_side := 0

func _ready() -> void:
	var level_data = Global.model_kits.get(Global.selected_level, null)
	if level_data:
		center_models = level_data["center_models"]
		side_parts = level_data["side_parts"]
	else:
		print("No data for level:", Global.selected_level)
	
	load_center_model()
	load_side_parts()

func _on_exit_to_menu_button_pressed() -> void:
	print("Exit button pressed")
	get_tree().change_scene_to_file("res://scenes/ui/start_menu/start_menu.tscn")

func load_center_model() -> void:
	var data = center_models[current_index_model]
	center_model.load_model(data["scene"], data["left_id"], data["right_id"])

func load_side_parts() -> void:
	for c in left_root.get_children():
		if c.name != "EasyRotationAnimation":
			c.queue_free()
	for c in right_root.get_children():
		if c.name != "EasyRotationAnimation":
			c.queue_free()

	var left_data = side_parts[(current_index_side * 2) % side_parts.size()]
	var right_data = side_parts[(current_index_side * 2 + 1) % side_parts.size()]

	var left_part = load(left_data.scene).instantiate()
	var right_part = load(right_data.scene).instantiate()

	var_ref_left.part_id = left_data.id
	var_ref_right.part_id = right_data.id

	left_root.add_child(left_part)
	right_root.add_child(right_part)

func try_attach_part(id: int) -> bool:
	if id == center_model.left_id and not center_model.left_attached:
		print("left_collect")
		center_model._set_transparency(1.0, "left")
		center_model.left_attached = true
		_next_model()
		return true
	elif id == center_model.right_id and not center_model.right_attached:
		print("right_collect")
		center_model._set_transparency(1.0, "right")
		center_model.right_attached = true
		_next_model()
		return true
	return false

func _next_model() -> void:
	current_index_side += 1
	load_side_parts()
	if center_model.left_attached and center_model.right_attached:
		center_model.left_attached = false
		center_model.right_attached = false
		current_index_model += 1
		# Replace with next mini-game
		var end_game := false
		if current_index_model >= center_models.size():
			get_tree().change_scene_to_file("res://scenes/ui/start_menu/start_menu.tscn")
			end_game = true
		if (end_game == false):
			#End part replace to mini-game
			load_center_model()
