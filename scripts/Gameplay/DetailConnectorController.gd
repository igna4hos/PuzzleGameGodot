extends Node3D

@onready var easyRotationAnimation: AnimationPlayer = $EasyRotationAnimation

func _process(delta: float) -> void:
	easyRotationAnimation.play("easy_rotation")
