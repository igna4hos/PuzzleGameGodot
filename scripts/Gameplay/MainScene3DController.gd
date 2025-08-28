extends Node3D

@onready var leftElementPart: Node3D = $LeftElementPart
@onready var rightElementPart: Node3D = $RightElementPart
@onready var centralElementPart: Node3D = $CentralElementPart
@onready var object_assembled_anim: AnimationPlayer = $CentralElementPart/ObjectAssembledAnimation

var center_models: Array = []
var side_parts: Array = []

var current_index_model := 0
var current_index_side := 0
var _center_orig_pos: Vector3 = Vector3.ZERO

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

func load_side_parts() -> void:
	for c in leftElementPart.get_children():
		if c.name != "EasyRotationAnimation":
			c.queue_free()
	for c in rightElementPart.get_children():
		if c.name != "EasyRotationAnimation":
			c.queue_free()

	var left_data = side_parts[(current_index_side * 2) % side_parts.size()]
	var right_data = side_parts[(current_index_side * 2 + 1) % side_parts.size()]

	var left_part = load(left_data.scene).instantiate()
	var right_part = load(right_data.scene).instantiate()

	leftElementPart.part_id = left_data.id
	rightElementPart.part_id = right_data.id

	leftElementPart.add_child(left_part)
	rightElementPart.add_child(right_part)

func try_attach_part(id: int) -> bool:
	if id == centralElementPart.left_id and not centralElementPart.left_attached:
		print("left_collect")
		centralElementPart._set_transparency(1.0, "left")
		centralElementPart.left_attached = true
		_collect_central()
		return true
	elif id == centralElementPart.right_id and not centralElementPart.right_attached:
		print("right_collect")
		centralElementPart._set_transparency(1.0, "right")
		centralElementPart.right_attached = true
		_collect_central()
		return true
	return false

func _collect_central() -> void:
	if centralElementPart.left_attached and centralElementPart.right_attached:
		_play_assembled_animation()
		#_next_model()
	else:
		_next_model()

func _play_assembled_animation() -> void:
	if object_assembled_anim == null:
		_next_model()
		return
	var cb := Callable(self, "_on_object_assembled_anim_finished")
	if object_assembled_anim.is_connected("animation_finished", cb):
		object_assembled_anim.disconnect("animation_finished", cb)
	object_assembled_anim.connect("animation_finished", cb)
	object_assembled_anim.play("ObjectAssembledAnimation/ObjectAssembledAnimation")

func _on_object_assembled_anim_finished(anim_name: String) -> void:
	if anim_name != "ObjectAssembledAnimation/ObjectAssembledAnimation":
		return
	var cb := Callable(self, "_on_object_assembled_anim_finished")
	if object_assembled_anim.is_connected("animation_finished", cb):
		object_assembled_anim.disconnect("animation_finished", cb)
	var tw = centralElementPart.create_tween()
	var target_pos = centralElementPart.position + Vector3(0, -800, 0)
	tw.tween_property(centralElementPart, "position", target_pos, 0.6)
	tw.connect("finished", Callable(self, "_on_move_tween_finished"))

func _on_move_tween_finished() -> void:
	centralElementPart.position = _center_orig_pos
	_next_model()

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

func _on_exit_to_menu_button_pressed() -> void:
	print("Exit button pressed")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
