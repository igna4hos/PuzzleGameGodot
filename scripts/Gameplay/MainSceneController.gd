extends Node2D

@onready var center_model: Node3D = $CentralElementPart/SubViewportContainer/SubViewport/CentralElement
@onready var left_root: Node3D  = $LeftElementPart/SubViewportContainer/SubViewport/LeftElement
@onready var var_ref_left: Node2D  = $LeftElementPart
@onready var right_root: Node3D = $RightElementPart/SubViewportContainer/SubViewport/RightElement
@onready var var_ref_right: Node2D  = $RightElementPart

var center_models = [
	{"scene":"res://assets/ModelsObject/cars/scooter.glb", "left_id":1, "right_id":2},
	{"scene":"res://assets/ModelsObject/cars/panzer.glb", "left_id":3, "right_id":4},
	{"scene":"res://assets/ModelsObject/cars/train.glb", "left_id":5, "right_id":6},
]

var side_parts = [
	{"scene":"res://assets/ModelsObject/cars/scooter_left.glb", "id":1},
	{"scene":"res://assets/ModelsObject/cars/panzer_left.glb", "id":3},
	{"scene":"res://assets/ModelsObject/cars/train_left.glb", "id":5},
	{"scene":"res://assets/ModelsObject/cars/panzer_right.glb", "id":4},
	{"scene":"res://assets/ModelsObject/cars/scooter_right.glb", "id":2},
	{"scene":"res://assets/ModelsObject/cars/train_right.glb", "id":6}
]

var current_index := 0

func _ready() -> void:
	load_center_model()
	load_side_parts()
	#await get_tree().create_timer(5.0).timeout
	#_next_model()

func load_center_model() -> void:
	var data = center_models[current_index]
	center_model.load_model(data["scene"], data["left_id"], data["right_id"])

func load_side_parts() -> void:
	for c in left_root.get_children():
		c.queue_free()
	for c in right_root.get_children():
		c.queue_free()

	var left_data  = side_parts[(current_index * 2)     % side_parts.size()]
	var right_data = side_parts[(current_index * 2 + 1) % side_parts.size()]

	var left_part  = load(left_data.scene).instantiate()
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
	elif id == center_model.right_id and not center_model.right_attached:
		print("right_collect")
		center_model._set_transparency(1.0, "right")
		center_model.right_attached = true
		_next_model()
	
	# при любой смене — сразу обнуляем состояние пазлов
	center_model.left_attached = false
	center_model.right_attached = false
	return true
	#if center_model.left_attached and center_model.right_attached:
		#_next_model()

func _next_model() -> void:
	current_index += 1
	if current_index >= center_models.size():
		current_index = 0
	load_center_model()
	load_side_parts()
