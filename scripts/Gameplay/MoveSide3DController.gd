extends Node3D

@export var camera_path: NodePath = NodePath("../MainScene3D#Camera3D") # можно указать путь к вашей Camera3D, иначе будет использована get_viewport().get_camera_3d()
@export var pick_threshold := 80.0 # px порог для выбора объекта по экранному расстоянию
@export var return_time := 0.25 # время твина возврата
@onready var anim_player: AnimationPlayer = $EasyRotationAnimation

var _cam: Camera3D
var _dragging: bool = false
var _drag_node: Node3D = null
var _orig_global_pos: Vector3
var _orig_transform: Transform3D
var part_id: int = -1
var _base_scale: Vector3
const DRAG_SCALE := Vector3(1.2, 1.2, 1.2)

func _ready() -> void:
	_base_scale = scale
	play_idle_rotation()
	if camera_path != NodePath(""):
		if has_node(camera_path):
			_cam = get_node(camera_path) as Camera3D
	if _cam == null:
		_cam = get_viewport().get_camera_3d()
	if _cam == null:
		push_warning("MoveSide3DController: camera not found; dragging will not work")

func _unhandled_input(event) -> void:
	if _cam == null:
		return

	# Press (mouse / touch)
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed:
			_try_start_drag(mb.position)
		else:
			_try_end_drag()
		return
	if event is InputEventScreenTouch:
		var st := event as InputEventScreenTouch
		if st.pressed:
			_try_start_drag(st.position)
		else:
			_try_end_drag()
		return

	# Move (mouse / drag)
	if _dragging:
		if event is InputEventMouseMotion:
			_update_drag((event as InputEventMouseMotion).position)
		elif event is InputEventScreenDrag:
			_update_drag((event as InputEventScreenDrag).position)

func _try_start_drag(screen_pos: Vector2) -> void:
	# ищем ближашего ребёнка Node3D по экранной позиции
	var best: Node3D = null
	var best_dist := 1e9
	for child in get_children():
		if not (child is Node3D):
			continue
		var n := child as Node3D
		# используем глобальную позицию корневой точки объекта
		var sp := _cam.unproject_position(n.global_transform.origin)
		var d := sp.distance_to(screen_pos)
		if d < best_dist and d <= pick_threshold:
			best_dist = d
			best = n
	if best:
		_dragging = true
		on_drag_start()
		_drag_node = best
		_orig_global_pos = _drag_node.global_transform.origin
		_orig_transform = _drag_node.transform

func _update_drag(screen_pos: Vector2) -> void:
	if _drag_node == null:
		return
	# проектируем луч и находим пересечение с плоскостью Z = исходного Z
	var ro: Vector3 = _cam.project_ray_origin(screen_pos)
	var rd: Vector3 = _cam.project_ray_normal(screen_pos)
	# если луч почти параллелен плоскости, ничего не делаем
	if abs(rd.z) < 0.0001:
		return
	var t := (_orig_global_pos.z - ro.z) / rd.z
	var hit := ro + rd * t
	# ограничиваем движение по X/Y, сохраняем исходный Z
	_drag_node.global_transform = Transform3D(_drag_node.global_transform.basis, Vector3(hit.x, hit.y, _orig_global_pos.z))

func _try_end_drag() -> void:
	if not _dragging or _drag_node == null:
		_dragging = false
		_drag_node = null
		return
	# запустить твин, чтобы вернуть в исходную позицию
	var tw = _drag_node.create_tween()
	tw.tween_property(_drag_node, "global_transform", Transform3D(_orig_transform.basis, _orig_global_pos), return_time)
	# по завершении очистим состояние
	tw.connect("finished", Callable(self, "_on_return_finished"))
	on_drag_end()
	_dragging = false

func _on_return_finished() -> void:
	_drag_node = null

func _process(_delta: float) -> void:
	if _drag_node != null:
		var screen_pos: Vector2 = _cam.unproject_position(_drag_node.global_position)
		var viewport_size: Vector2 = get_viewport().get_visible_rect().size
		var center_screen: Vector2 = viewport_size / 2
		var distance_to_center: float = screen_pos.distance_to(center_screen)
		if distance_to_center < 250:
			_on_reach_center()

func _on_reach_center() -> void:
	var main_controller = get_tree().get_root().get_node("MainScene3D") # Scene title at the root
	if main_controller:
		var result = main_controller.try_attach_part(part_id)
		if result:
			_try_end_drag()

func play_idle_rotation() -> void:
	anim_player.speed_scale = 1.0
	if anim_player.current_animation != "EasyRotationAnimation/easy_rotation" or not anim_player.is_playing():
		anim_player.play("EasyRotationAnimation/easy_rotation")

func on_drag_start() -> void:
	# Сбрасываем анимацию в начало и останавливаем
	anim_player.stop()
	anim_player.seek(0, true) 
	scale = _base_scale * DRAG_SCALE

func on_drag_end() -> void:
	scale = _base_scale
	var tween_rotation = create_tween()
	tween_rotation.tween_property(self, "rotation", Vector3.ZERO, 0.2)
	tween_rotation.tween_callback(play_idle_rotation)
