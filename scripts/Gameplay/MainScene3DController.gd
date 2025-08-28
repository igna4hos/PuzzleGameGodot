extends Node3D

@onready var leftElementPart: Node3D = $LeftElementPart
@onready var rightElementPart: Node3D = $RightElementPart
@onready var centralElementPart: Node3D = $CentralElementPart

var center_models: Array = []
var side_parts: Array = []

var current_index_model := 0
var current_index_side := 0

func _ready() -> void:
	var level_data = Global.model_kits.get(1, null)
	if level_data:
		center_models = level_data["center_models"]
		side_parts = level_data["side_parts"]
	else:
		print("No data for level:", Global.selected_level)
	
	load_center_model()
	load_side_parts()

	'''
	# запускаем таймер на автосмену моделей
	var timer := Timer.new()
	timer.wait_time = 5.0
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_next_model)
	add_child(timer)
	'''

func load_center_model() -> void:
	var data = center_models[current_index_model]
	centralElementPart.load_model(data["scene"], data["left_id"], data["right_id"])
	'''
	for c in centralElementPart.get_children():
		c.queue_free()
	var data = center_models[current_index_model]
	var central_part = load(data.scene).instantiate()
	centralElementPart.add_child(central_part)
	'''

func load_side_parts() -> void:
	for c in leftElementPart.get_children():
		c.queue_free()
	for c in rightElementPart.get_children():
		c.queue_free()

	var left_data = side_parts[(current_index_side * 2) % side_parts.size()]
	var right_data = side_parts[(current_index_side * 2 + 1) % side_parts.size()]

	var left_part = load(left_data.scene).instantiate()
	var right_part = load(right_data.scene).instantiate()

	leftElementPart.part_id = left_data.id
	rightElementPart.part_id = right_data.id

	leftElementPart.add_child(left_part)
	rightElementPart.add_child(right_part)
'''
func try_attach_part(id: int) -> bool:
	if id == center_model.left_id and not center_model.left_attached:
		print("left_collect")
		center_model._set_transparency(1.0, "left")
		center_model.left_attached = true
		_collect_central()
		return true
	elif id == center_model.right_id and not center_model.right_attached:
		print("right_collect")
		center_model._set_transparency(1.0, "right")
		center_model.right_attached = true
		_collect_central()
		return true
	return false

func _collect_central() -> void:
	if center_model.left_attached and center_model.right_attached:
		_play_assembled_animation()
	else:
		_next_model()
'''

func try_attach_part(id: int) -> bool:
	if id == centralElementPart.left_id and not centralElementPart.left_attached:
		print("left_collect")
		#centralElementPart._set_transparency(1.0, "left")
		centralElementPart.left_attached = true
		_collect_central()
		return true
	elif id == centralElementPart.right_id and not centralElementPart.right_attached:
		print("right_collect")
		#centralElementPart._set_transparency(1.0, "right")
		centralElementPart.right_attached = true
		_collect_central()
		return true
	return false

func _collect_central() -> void:
	if centralElementPart.left_attached and centralElementPart.right_attached:
		#_play_assembled_animation()
		_next_model()
	else:
		_next_model()
'''
func _next_model() -> void:
	current_index_model += 1
	current_index_side += 1
	if center_models.size() > 0:
		load_center_model()
		load_side_parts()
'''

func _next_model() -> void:
	current_index_side += 1
	load_side_parts()
	if centralElementPart.left_attached and centralElementPart.right_attached:
		centralElementPart.left_attached = false
		centralElementPart.right_attached = false
		current_index_model += 1
		# Replace with next mini-game
		var end_game := false
		if current_index_model >= center_models.size():
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
			end_game = true
		if (end_game == false):
			#End part replace to mini-game
			load_center_model()

func _apply_transform(node: Node3D, data: Dictionary) -> void:
	if data.has("rotation_degrees"):
		node.rotation_degrees = data["rotation_degrees"]
	if data.has("position"):
		node.position = data["position"]
	if data.has("scale"):
		node.scale = data["scale"]
