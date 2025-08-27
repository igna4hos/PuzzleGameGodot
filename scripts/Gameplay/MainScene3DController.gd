extends Node3D

@onready var center_root: Node3D = $LeftElementPart   # узел-контейнер для центральной модели

var center_models: Array = []
var current_index_model: int = 0

func _ready() -> void:
	var level_data = Global.model_kits.get(Global.selected_level, null)
	if level_data:
		center_models = level_data["center_models"]
	else:
		push_warning("No data for level: %s" % Global.selected_level)
		return

	# загрузим первую модель
	load_center_model()

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
	# очистим контейнер
	for child in center_root.get_children():
		child.queue_free()

	var data = center_models[current_index_model % center_models.size()]
	var scene: PackedScene = load(data["scene"])
	var inst: Node3D = scene.instantiate()

	center_root.add_child(inst)

	# если в словаре есть transform — применим
	if data.has("transform"):
		_apply_transform(inst, data["transform"])

func _next_model() -> void:
	current_index_model += 1
	if center_models.size() > 0:
		load_center_model()

func _apply_transform(node: Node3D, data: Dictionary) -> void:
	if data.has("rotation_degrees"):
		node.rotation_degrees = data["rotation_degrees"]
	if data.has("position"):
		node.position = data["position"]
	if data.has("scale"):
		node.scale = data["scale"]
