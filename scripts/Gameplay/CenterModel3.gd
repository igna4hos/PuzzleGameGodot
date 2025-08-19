extends Node3D

var left_id: int
var right_id: int
var left_attached := false
var right_attached := false
var model_root: Node3D = null

func load_model(scene_path: String, l_id: int, r_id: int) -> void:
	if model_root:
		model_root.queue_free()

	left_id = l_id
	right_id = r_id
	left_attached = false
	right_attached = false

	model_root = load(scene_path).instantiate()
	add_child(model_root)

	# старт: полупрозрачная вся модель
	_set_transparency(0.5, "both")

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
			var mi: MeshInstance3D = child
			var mat: Material = mi.get_active_material(0)
			if mat == null:
				continue

			var mat_copy: Material = mat.duplicate()
			mat_copy.resource_local_to_scene = true

			if mat_copy is BaseMaterial3D:
				var bm := mat_copy as BaseMaterial3D
				bm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

				var apply := false
				match side:
					"both":
						apply = true
					"left":
						# имя левой половинки: rocket2 / earth2 и т.п.
						apply = mi.name.ends_with("2") or mi.name.contains("2")
					"right":
						# имя правой половинки: rocket_001 / earth_001 и т.п.
						apply = mi.name.ends_with("_001") or mi.name.contains("_001")

				if apply:
					bm.albedo_color.a = alpha

			mi.set_surface_override_material(0, mat_copy)
