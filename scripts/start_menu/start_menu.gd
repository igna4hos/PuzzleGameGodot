extends Control

@export var h_gap: int = 24
@export var v_gap: int = 24
@export var min_tile: int = 140
@export var max_tile: int = 360
@export var panel_width_ratio: float = 0.24
@export var panel_corner_radius: int = 70
@export_group("Row Offset")
@export var row_offset_enabled: bool = true
@export var row_offset_multiplier: float = 1
@export_group("Buttons")
@export var this_game_button_size: Vector2 = Vector2(256, 256)
@export var all_games_button_size: Vector2 = Vector2(256, 256)
const COLS := 3

@onready var rows: VBoxContainer = $MainLayout/GameArea/Rows
@onready var row_top: HBoxContainer = $MainLayout/GameArea/Rows/RowTop
@onready var row_mid: HBoxContainer = $MainLayout/GameArea/Rows/RowMiddle
@onready var row_bot: HBoxContainer = $MainLayout/GameArea/Rows/RowBottom
@onready var spacer_mid: Control = $MainLayout/GameArea/Rows/RowMiddle/Spacer
@onready var spacer_top: Control = $MainLayout/GameArea/Rows/RowTop/SpacerTop
@onready var spacer_bottom: Control = $MainLayout/GameArea/Rows/RowBottom/SpacerBottom
@onready var right_panel: Control = $MainLayout/RightPanel
@onready var panel_bg: Panel = $MainLayout/RightPanel/PanelMargin/PanelBg
@onready var this_game_button: TextureButton = $MainLayout/RightPanel/PanelMargin/ButtonsContainer/ThisGameButton
@onready var all_games_button: VBoxContainer = $MainLayout/RightPanel/PanelMargin/ButtonsContainer/AllGamesButton
@onready var all_games_image: TextureButton = $MainLayout/RightPanel/PanelMargin/ButtonsContainer/AllGamesButton/GameImage
@onready var all_games_label: Label = $MainLayout/RightPanel/PanelMargin/ButtonsContainer/AllGamesButton/AllGamesLabel

func _ready() -> void:
	# Set button text from localization
	if all_games_label:
		all_games_label.text = Localization.get_new_game_text()
	
	call_deferred("_apply_button_sizes")
	call_deferred("_connect_tiles")
	call_deferred("_connect_side_buttons")
	_reflow()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_reflow()

func _reflow() -> void:
	var screen_width: float = get_viewport_rect().size.x
	
	# Adaptive right panel width (fraction of screen)
	var panel_width: int = int(screen_width * panel_width_ratio)
	if right_panel:
		right_panel.custom_minimum_size.x = panel_width
	
	# Rounded corners for the panel
	if panel_bg:
		var style_box := StyleBoxFlat.new()
		style_box.bg_color = Color(0, 0, 0, 0.47)  # Updated transparency
		style_box.corner_radius_top_left = panel_corner_radius
		style_box.corner_radius_bottom_left = panel_corner_radius
		# For Panel use the "panel" style override key
		panel_bg.add_theme_stylebox_override("panel", style_box)
	
	# Adaptive button sizes (deferred so containers update)
	call_deferred("_apply_button_sizes")
	
	# Tile size accounting for the panel
	var avail_w: float = (screen_width - panel_width) * 0.9
	var tile: int = clamp(int((avail_w - float(h_gap) * float(COLS - 1)) / float(COLS)), min_tile, max_tile)
	_apply_tile_size(row_top, tile)
	_apply_tile_size(row_mid, tile)
	_apply_tile_size(row_bot, tile)
	
	# Configurable row offset
	var offset = 0.0
	if row_offset_enabled:
		offset = (tile * row_offset_multiplier) + (h_gap * row_offset_multiplier)
	
	# Add spacer to top and bottom rows to shift them right
	if spacer_top:
		spacer_top.custom_minimum_size.x = offset
		print("Top spacer size: ", offset)
	if spacer_bottom:
		spacer_bottom.custom_minimum_size.x = offset
		print("Bottom spacer size: ", offset)
	
	# Remove spacer from middle row to shift it left
	if spacer_mid:
		spacer_mid.custom_minimum_size.x = 0
		print("Mid spacer size: 0")

func _force_layout_update() -> void:
	# Force layout update
	if rows:
		rows.queue_redraw()
		rows.notification(NOTIFICATION_RESIZED)

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

func _apply_button_sizes() -> void:
	if this_game_button:
		this_game_button.custom_minimum_size = this_game_button_size
		_setup_button_highlight(this_game_button)
		print("ThisGameButton size set to: ", this_game_button_size)
	
	if all_games_button:
		all_games_button.custom_minimum_size = all_games_button_size
		print("AllGamesButton size set to: ", all_games_button_size)
		
		# Setup highlight for the image button inside the container
		if all_games_image:
			_setup_button_highlight(all_games_image)

func _setup_button_highlight(button: TextureButton) -> void:
	if not button:
		return
	
	# Connect only press/release signals
	if not button.button_down.is_connected(_on_button_pressed):
		button.button_down.connect(_on_button_pressed.bind(button))
	if not button.button_up.is_connected(_on_button_released):
		button.button_up.connect(_on_button_released.bind(button))

func _on_button_pressed(button: TextureButton) -> void:
	# Smoothly darken on press
	var tween = create_tween()
	tween.tween_property(button, "modulate", Color(0.8, 0.8, 0.8, 1.0), 0.1)

func _on_button_released(button: TextureButton) -> void:
	# Smoothly return to normal color
	var tween = create_tween()
	tween.tween_property(button, "modulate", Color.WHITE, 0.15)

func _connect_side_buttons() -> void:
	if this_game_button:
		this_game_button.pressed.connect(_on_this_game_pressed)
	if all_games_image:
		all_games_image.pressed.connect(_on_all_games_pressed)

func _on_this_game_pressed() -> void:
	# Open this game's App Store page
	print("Opening this game's App Store page")
	# Example: OS.shell_open("https://apps.apple.com/app/your-game-id")

func _on_all_games_pressed() -> void:
	# Open developer's App Store page
	print("Opening developer's App Store page")
	# Example: OS.shell_open("https://apps.apple.com/developer/your-developer-id")

func _on_level_tile_pressed_bound(tile: Button) -> void:
	if tile:
		var id_v: Variant = tile.get("level_id")
		if typeof(id_v) == TYPE_INT:
			Global.selected_level = int(id_v)
			print("Selected level:", Global.selected_level)
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_file("res://scenes/MainScene3D.tscn")
