extends Node2D

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

	var center_element = $SubViewportContainer/SubViewport/CentralElement
	model_root = load(scene_path).instantiate()
	center_element.add_child(model_root)
	
	_set_transparency(0.5, "both")

func _set_transparency(alpha: float, side: String = "both") -> void:
	if not model_root:
		return
	_apply_transparency_recursive(model_root, alpha, side)

func _apply_transparency_recursive(node: Node, alpha: float, side: String) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			#Checking the paint on one side
			if side == "left" and not child.name.ends_with("2"):
				continue
			elif side == "right" and not child.name.ends_with("_001"):
				continue
			#both - both sides with low transparency
			var mi: MeshInstance3D = child
			var mat: Material = mi.get_active_material(0)
			if mat == null:
				continue
			var new_mat = mat.duplicate()
			if new_mat is StandardMaterial3D:
				new_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
				var color = new_mat.albedo_color
				color.a = alpha
				new_mat.albedo_color = color
				mi.set_surface_override_material(0, new_mat)
		_apply_transparency_recursive(child, alpha, side)
