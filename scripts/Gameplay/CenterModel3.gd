extends Node3D

var left_id: int
var right_id: int
var left_attached := false
var right_attached := false
var model_root: Node3D = null

func load_model(scene_path: String, l_id: int, r_id: int) -> void:
	# удалить старую модель
	if model_root:
		model_root.queue_free()

	left_id = l_id
	right_id = r_id
	left_attached = false
	right_attached = false

	# добавить новую
	model_root = load(scene_path).instantiate()
	add_child(model_root)

	# сделать полупрозрачной всю модель
	_set_transparency(0.5) # обе стороны

func try_attach(part_id: int) -> bool:
	if part_id == left_id and not left_attached:
		left_attached = true
		_set_transparency(1.0, "left")
		return true
	elif part_id == right_id and not right_attached:
		right_attached = true
		_set_transparency(1.0, "right")
		return true
	return false

func is_complete() -> bool:
	return left_attached and right_attached

func _set_transparency(alpha: float, side: String = "both") -> void:
	if not model_root:
		return

	for child in model_root.get_children():
		if child is MeshInstance3D:
			var mat: Material = child.get_active_material(0)
			if mat == null:
				continue

			mat = mat.duplicate()
			mat.resource_local_to_scene = true
			if mat is BaseMaterial3D:
				mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

				# Привязка к именам мешей: *2 = левая часть, *_001 = правая часть
				if side == "left":
					if "2" in child.name:
						mat.albedo_color.a = alpha
				elif side == "right":
					if "_001" in child.name:
						mat.albedo_color.a = alpha
				else:
					mat.albedo_color.a = alpha

			child.set_surface_override_material(0, mat)
