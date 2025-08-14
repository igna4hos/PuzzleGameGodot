extends Control

@export var h_gap: int = 24
@export var v_gap: int = 24
@export var min_tile: int = 140
@export var max_tile: int = 360
@export var panel_width_ratio: float = 0.24
@export var panel_corner_radius: int = 20
const COLS := 3

@onready var rows: VBoxContainer = $MainLayout/GameArea/Rows
@onready var row_top: HBoxContainer = $MainLayout/GameArea/Rows/RowTop
@onready var row_mid: HBoxContainer = $MainLayout/GameArea/Rows/RowMiddle
@onready var row_bot: HBoxContainer = $MainLayout/GameArea/Rows/RowBottom
@onready var spacer_mid: Control = $MainLayout/GameArea/Rows/RowMiddle/Spacer
@onready var right_panel: Control = $MainLayout/RightPanel
@onready var panel_bg: ColorRect = $MainLayout/RightPanel/PanelBg
@onready var play_button: TextureButton = $MainLayout/RightPanel/ButtonsContainer/PlayButton
@onready var appstore_button: TextureButton = $MainLayout/RightPanel/ButtonsContainer/AppStoreButton

func _ready() -> void:
	rows.add_theme_constant_override("separation", v_gap)
	for r in [row_top, row_mid, row_bot]:
		r.add_theme_constant_override("separation", h_gap)
	_connect_tiles()
	_connect_side_buttons()
	_reflow()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_reflow()

func _reflow() -> void:
	var screen_width: float = get_viewport_rect().size.x
	
	# Адаптивная ширина правой панели (25.3% от экрана)
	var panel_width: int = int(screen_width * panel_width_ratio)
	if right_panel:
		right_panel.custom_minimum_size.x = panel_width
	
	# Скругление углов панели
	if panel_bg:
		var style_box := StyleBoxFlat.new()
		style_box.bg_color = Color(0, 0, 0, 0.15)
		style_box.corner_radius_top_left = panel_corner_radius
		style_box.corner_radius_bottom_left = panel_corner_radius
		panel_bg.add_theme_stylebox_override("panel", style_box)
	
	# Размер плиток с учётом панели
	var avail_w: float = (screen_width - panel_width) * 0.9
	var tile: int = clamp(int((avail_w - float(h_gap) * float(COLS - 1)) / float(COLS)), min_tile, max_tile)
	_apply_tile_size(row_top, tile)
	_apply_tile_size(row_mid, tile)
	_apply_tile_size(row_bot, tile)
	if spacer_mid:
		spacer_mid.custom_minimum_size.x = tile * 0.5 + h_gap * 0.5

func _apply_tile_size(row: HBoxContainer, tile: int) -> void:
	if row == null:
		return
	for child in row.get_children():
		if child is Button:
			child.custom_minimum_size = Vector2(tile, tile)

func _connect_tiles() -> void:
	for row in [row_top, row_mid, row_bot]:
		if row == null:
			continue
		for tile in row.get_children():
			if tile is Button:
				if not tile.pressed.is_connected(_on_level_tile_pressed_bound):
					tile.pressed.connect(_on_level_tile_pressed_bound.bind(tile))
				# Подпись, если есть Label внутри
				if tile.has_node("Label"):
					var id_v: Variant = tile.get("level_id")
					if typeof(id_v) == TYPE_INT:
						tile.get_node("Label").text = "Уровень %d" % int(id_v)

func _connect_side_buttons() -> void:
	if play_button:
		play_button.pressed.connect(_on_play_button_pressed)
	if appstore_button:
		appstore_button.pressed.connect(_on_appstore_button_pressed)

func _on_play_button_pressed() -> void:
	# Переход к игре (можно выбрать первый уровень по умолчанию)
	var global := get_node_or_null("/root/Global")
	if global:
		global.selected_level = 1
	get_tree().change_scene_to_file("res://scenes/main_level.tscn")

func _on_appstore_button_pressed() -> void:
	# Переход к другим играм разработчика
	# Здесь можно открыть URL или показать экран с другими играми
	print("Переход к другим играм разработчика")
	# Пример: OS.shell_open("https://apps.apple.com/developer/your-developer-id")

func _on_level_tile_pressed_bound(tile: Button) -> void:
	if tile:
		var id_v: Variant = tile.get("level_id")
		if typeof(id_v) == TYPE_INT:
			var global := get_node_or_null("/root/Global")
			if global:
				global.selected_level = int(id_v)
			get_tree().change_scene_to_file("res://scenes/main_level.tscn")
