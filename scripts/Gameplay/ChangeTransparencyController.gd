extends Node3D

func _ready() -> void:
	var mesh_instance: MeshInstance3D = $rocket/rocket2

	var mat := mesh_instance.get_active_material(0).duplicate()
	mat.resource_local_to_scene = true

	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color.a = 0.5
	
	mesh_instance.set_surface_override_material(0, mat)
