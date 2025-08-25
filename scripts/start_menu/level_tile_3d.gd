extends Button

@export var level_id: int = 1

@export_group("Background")
@export var background_size: Vector2 = Vector2(256, 232)
@export var background_color: Color = Color(0.4392, 0.8431, 0.9451, 1.0)
@export var corner_radius: int = 128

@export_group("Model Configuration")
@export var tile_scene: PackedScene

@export_group("Rotation Animation")
@export var rotation_enabled: bool = true
@export var rotation_angle: float = 4.0
@export var rotation_speed: float = 0.15

@onready var circle_bg: Panel = $CircleBg
@onready var aspect: AspectRatioContainer = $Aspect
@onready var svc: SubViewportContainer = $Aspect/SubViewportContainer
@onready var viewport: SubViewport = $Aspect/SubViewportContainer/SubViewport
@onready var world_node: Node3D = $Aspect/SubViewportContainer/SubViewport/World

var model_instance: Node3D = null
var rotation_direction: int = 1
var current_rotation: float = 0.0

func _ready() -> void:
	focus_mode = Control.FOCUS_NONE
	if aspect:
		aspect.set_anchors_preset(Control.PRESET_FULL_RECT)
	if svc:
		svc.set_anchors_preset(Control.PRESET_FULL_RECT)
		svc.stretch = true

	call_deferred("_setup_background")
	_init_own_viewport_world()
	_load_models()

func _process(delta: float) -> void:
	if rotation_enabled and model_instance and is_visible_in_tree():
		var target_rot := rotation_direction * deg_to_rad(rotation_angle)
		current_rotation = move_toward(current_rotation, target_rot, rotation_speed * delta)
		model_instance.rotation.y = current_rotation
		if abs(current_rotation - target_rot) < 0.01:
			rotation_direction *= -1

func _setup_background() -> void:
	if not circle_bg:
		return
	circle_bg.custom_minimum_size = background_size
	circle_bg.size = background_size

	var style_box := StyleBoxFlat.new()
	style_box.bg_color = background_color
	style_box.corner_radius_top_left = corner_radius
	style_box.corner_radius_top_right = corner_radius
	style_box.corner_radius_bottom_left = corner_radius
	style_box.corner_radius_bottom_right = corner_radius
	style_box.anti_aliasing = true
	style_box.anti_aliasing_size = 2.0
	style_box.border_width_left = 0
	style_box.border_width_right = 0
	style_box.border_width_top = 0
	style_box.border_width_bottom = 0

	circle_bg.add_theme_stylebox_override("panel", style_box)
	print("Applied background to tile ", level_id, " size: ", background_size, " color: ", background_color)

func _init_own_viewport_world() -> void:
	if not viewport:
		push_error("SubViewport not found in tile with level_id %s" % level_id)
		return

	if viewport.world_3d == null:
		viewport.world_3d = World3D.new()

func _load_models() -> void:
	_clear_models()

	if tile_scene == null:
		print("No tile scene set for tile ", level_id)
		return

	model_instance = tile_scene.instantiate()
	if model_instance == null:
		print("Failed to instantiate tile scene for tile ", level_id)
		return

	model_instance.name = "ModelsParent_%s" % level_id
	world_node.add_child(model_instance)

	model_instance.position = Vector3.ZERO
	current_rotation = 0.0
	rotation_direction = 1

	print("Loaded unique tile scene for tile ", level_id)

func _clear_models() -> void:
	if model_instance and is_instance_valid(model_instance):
		model_instance.queue_free()
		model_instance = null

func reload_tile_scene() -> void:
	_load_models()
