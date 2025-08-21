extends Node3D

func _ready() -> void:
	var mesh_instance_left: MeshInstance3D = $rocket/rocket2
	var mesh_instance_right: MeshInstance3D = $rocket/rocket_001

	var material_left := mesh_instance_left.get_active_material(0).duplicate()
	material_left.resource_local_to_scene = true

	material_left.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material_left.albedo_color.a = 0.5
	
	mesh_instance_left.set_surface_override_material(0, material_left)
	
	var material_right := mesh_instance_right.get_active_material(0).duplicate()
	material_right.resource_local_to_scene = true

	material_right.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material_right.albedo_color.a = 0.5
	
	mesh_instance_right.set_surface_override_material(0, material_right)
