extends Button

@export var level_id: int = 1
@export_group("Background")
@export var background_size: Vector2 = Vector2(256, 232)
@export var background_color: Color = Color(0.2, 0.6, 1.0)  # Default light blue color
@export var corner_radius: int = 128  # Corner radius (oval shape)
@export_group("Model Configuration")
@export var tile_scene: PackedScene  # 3D scene with pre-arranged models
@export_group("Rotation Animation")
@export var rotation_enabled: bool = true
@export var rotation_angle: float = 4.0  # Rotation angle in degrees
@export var rotation_speed: float = 0.15   # Animation speed

@onready var world_node: Node3D = $Aspect/SubViewportContainer/SubViewport/World
var models_parent: Node3D  # Parent node for all models (we animate this one)
@onready var circle_bg: Panel = $CircleBg
@onready var aspect: AspectRatioContainer = $Aspect
@onready var svc: SubViewportContainer = $Aspect/SubViewportContainer

func _ready() -> void:
	# Remove focus outline
	focus_mode = Control.FOCUS_NONE
	
	# Ensure full-rect layout and correct click handling
	if aspect:
		aspect.set_anchors_preset(Control.PRESET_FULL_RECT)
	if svc:
		svc.set_anchors_preset(Control.PRESET_FULL_RECT)
		svc.stretch = true
	
	# Create rectangular background after ready
	call_deferred("_setup_background")
	# Load models after ready
	call_deferred("_load_models")

var _is_pressed_in_circle: bool = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed:
				# On press, check if inside background
				_is_pressed_in_circle = _is_point_in_background(mouse_event.position)
			else:
				# On release, apply touchUpInside logic
				if _is_pressed_in_circle and _is_point_in_background(mouse_event.position):
					# Emit pressed only if both press and release were inside background
					pressed.emit()
				_is_pressed_in_circle = false

func _is_point_in_background(point: Vector2) -> bool:
	if not circle_bg:
		return false
	
	# Get rectangular background area
	var bg_rect = circle_bg.get_rect()
	
	# Check if point is inside rectangle
	return bg_rect.has_point(point)

func _setup_background() -> void:
	if circle_bg:
		# Set background size
		circle_bg.custom_minimum_size = background_size
		circle_bg.size = background_size
		
		# Create style with color and corner radius
		var style_box := StyleBoxFlat.new()
		style_box.bg_color = background_color
		
		# Apply corner radius
		style_box.corner_radius_top_left = corner_radius
		style_box.corner_radius_top_right = corner_radius
		style_box.corner_radius_bottom_left = corner_radius
		style_box.corner_radius_bottom_right = corner_radius
		
		# Enable antialiasing for smooth corners
		style_box.anti_aliasing = true
		style_box.anti_aliasing_size = 2.0
		
		# Remove borders
		style_box.border_width_left = 0
		style_box.border_width_right = 0
		style_box.border_width_top = 0
		style_box.border_width_bottom = 0
		
		# For Panel use the "panel" override key
		circle_bg.add_theme_stylebox_override("panel", style_box)
		print("Applied background to tile ", level_id, " size: ", background_size, " color: ", background_color)

var rotation_direction: int = 1  # 1 for right, -1 for left
var current_rotation: float = 0.0

func _process(delta: float) -> void:
	if is_visible_in_tree() and rotation_enabled and models_parent:
		# Left-right rotation animation of the parent object
		var target_rotation = rotation_direction * deg_to_rad(rotation_angle)
		current_rotation = move_toward(current_rotation, target_rotation, rotation_speed * delta)
		
		# Apply rotation to the parent object
		models_parent.rotation.y = current_rotation
		
		# Flip direction when reaching the target
		if abs(current_rotation - target_rotation) < 0.01:
			rotation_direction *= -1

## Load scene with pre-arranged models
func _load_models() -> void:
	# Clear previous models
	_clear_models()
	
	if not tile_scene:
		print("No tile scene set for tile ", level_id)
		return
	
	# Load and instantiate the scene
	var scene_instance = tile_scene.instantiate()
	if not scene_instance:
		print("Failed to instantiate tile scene for tile ", level_id)
		return
	
	# Set as models parent for animation
	models_parent = scene_instance
	models_parent.name = "ModelsParent"
	world_node.add_child(models_parent)
	
	print("Loaded tile scene for tile ", level_id)

## Clear all loaded models
func _clear_models() -> void:
	# Free the parent node with all models
	if models_parent and is_instance_valid(models_parent):
		models_parent.queue_free()
		models_parent = null

## Change tile scene
func set_tile_scene(new_scene: PackedScene) -> void:
	tile_scene = new_scene
	_load_models()
