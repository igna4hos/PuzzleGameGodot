extends Node3D

@onready var donut_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	donut_player.play("easy_rotation")
