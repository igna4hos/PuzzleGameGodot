extends Node3D

@onready var anim_player: AnimationPlayer = $EasyRotationAnimation

var _base_scale: Vector3
const DRAG_SCALE := Vector3(1.2, 1.2, 1.2)

func _ready() -> void:
	_base_scale = scale
	play_idle_rotation()

func play_idle_rotation() -> void:
	anim_player.speed_scale = 1.0
	if anim_player.current_animation != "EasyRotationAnimation/easy_rotation" or not anim_player.is_playing():
		anim_player.play("EasyRotationAnimation/easy_rotation")

func on_drag_start() -> void:
	anim_player.speed_scale = 0.0
	scale = _base_scale * DRAG_SCALE

func on_drag_end() -> void:
	scale = _base_scale
	play_idle_rotation()
