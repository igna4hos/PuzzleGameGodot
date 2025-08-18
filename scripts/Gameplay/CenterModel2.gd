extends Node3D

var left_id: int
var right_id: int
var left_attached := false
var right_attached := false

func try_attach(part_id: int) -> bool:
	if part_id == left_id and not left_attached:
		left_attached = true
		# Возвращаем прозрачность левой части (пример)
		var mesh = $rocket/rocket2 if has_node("rocket2") else get_node_or_null("earth2")
		if mesh:
			var mat = mesh.get_active_material(0).duplicate()
			mat.resource_local_to_scene = true
			mat.albedo_color.a = 1.0
			mesh.set_surface_override_material(0, mat)
		return true
	
	if part_id == right_id and not right_attached:
		right_attached = true
		# Возвращаем прозрачность правой части
		var mesh = $rocket/rocket_001 if has_node("rocket_001") else get_node_or_null("earth_001")
		if mesh:
			var mat = mesh.get_active_material(0).duplicate()
			mat.resource_local_to_scene = true
			mat.albedo_color.a = 1.0
			mesh.set_surface_override_material(0, mat)
		return true

	return false

func is_complete() -> bool:
	return left_attached and right_attached
