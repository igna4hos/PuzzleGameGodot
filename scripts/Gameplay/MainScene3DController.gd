extends Node3D

@onready var leftElementPart: Node3D = $LeftElementPart
@onready var rightElementPart: Node3D = $RightElementPart
@onready var centralElement: Node3D = $CentralElement

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


	# запускаем таймер на автосмену моделей
	var timer := Timer.new()
	timer.wait_time = 5.0
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_next_model)
	add_child(timer)



func load_center_model() -> void:
	for c in centralElement.get_children():
		c.queue_free()

	var data = center_models[current_index_model]
	var central_part = load(data.scene).instantiate()
	centralElement.add_child(central_part)

func load_side_parts() -> void:
	for c in leftElementPart.get_children():
		c.queue_free()
	for c in rightElementPart.get_children():
		c.queue_free()

	var left_data = side_parts[(current_index_side * 2) % side_parts.size()]
	var right_data = side_parts[(current_index_side * 2 + 1) % side_parts.size()]

	var left_part = load(left_data.scene).instantiate()
	var right_part = load(right_data.scene).instantiate()

	#var_ref_left.part_id = left_data.id
	#var_ref_right.part_id = right_data.id

	leftElementPart.add_child(left_part)
	rightElementPart.add_child(right_part)

func _next_model() -> void:
	current_index_model += 1
	current_index_side += 1
	if center_models.size() > 0:
		load_center_model()
		load_side_parts()

func _apply_transform(node: Node3D, data: Dictionary) -> void:
	if data.has("rotation_degrees"):
		node.rotation_degrees = data["rotation_degrees"]
	if data.has("position"):
		node.position = data["position"]
	if data.has("scale"):
		node.scale = data["scale"]
