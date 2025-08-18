extends Node2D

@export var left_id: int = -1
@export var right_id: int = -1

@onready var left_mesh: MeshInstance3D = $SubViewportContainer/SubViewport/CenterRoot/rocket/rocket2
@onready var right_mesh: MeshInstance3D = $SubViewportContainer/SubViewport/CenterRoot/rocket/rocket_001

var left_done := false
var right_done := false

func _ready() -> void:
	_set_transparency(left_mesh, 0.5)
	_set_transparency(right_mesh, 0.5)

func try_attach(part_id: int) -> bool:
	if part_id == left_id and not left_done:
		_set_transparency(left_mesh, 1.0)
		left_done = true
		return true
	elif part_id == right_id and not right_done:
		_set_transparency(right_mesh, 1.0)
		right_done = true
		return true
	return false

func is_complete() -> bool:
	return left_done and right_done

func _set_transparency(mesh: MeshInstance3D, alpha: float) -> void:
	var mat := mesh.get_active_material(0).duplicate()
	mat.resource_local_to_scene = true
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color.a = alpha
	mesh.set_surface_override_material(0, mat)
