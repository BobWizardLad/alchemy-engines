extends Control

@onready var ACTIONS_MENU: Control = $ActionsMenu
@onready var SELECTION_MENU: Control = $ActionSelection
@onready var BACK_MENU: Control = $BackMenu

@onready var unit_name_label: Label = $Stats/NameTexture/UnitName
@onready var unit_armor_bar: TextureProgressBar = $Stats/ArmorBar
@onready var unit_health_bar: TextureProgressBar = $Stats/HealthBar
@onready var unit_portrait: TextureRect = $Stats/IconPortrait

var current_unit: Pawn = null

# Update unit stats in the UI window
func _process(_delta):
	if current_unit != null:
		unit_name_label.text = current_unit.pawn_name
		unit_armor_bar.value = current_unit.current_armor
		unit_health_bar.value = current_unit.current_health

func update_current_unit(new_unit: Pawn) -> void:
	current_unit = new_unit
	
	var portrait = AtlasTexture.new()
	portrait.set_atlas(current_unit.texture)
	portrait.set_region(Rect2(0,0,64,64))
	unit_portrait.texture = portrait
	
	unit_armor_bar.max_value = current_unit.ARMOR_MAX
	unit_health_bar.max_value = current_unit.HEALTH_MAX

func hide_actions_menu() -> void:
	ACTIONS_MENU.visible = false

func hide_UI_menu() -> void:
	visible = false

# Hide the action selection menu
func hide_selection_menu() -> void:
	SELECTION_MENU.visible = false

func hide_back_menu() -> void:
	BACK_MENU.visible = false

# Tween the Actions Menu into frame
func focus_actions_menu() -> void:
	ACTIONS_MENU.visible = true

# Tween the UI into frame
func focus_UI_menu() -> void:
	visible = true

# Show the action selection menu
func focus_selection_menu() -> void:
	SELECTION_MENU.visible = true

func focus_back_menu() -> void:
	BACK_MENU.visible = true

func _on_combat_camera_camera_move_finished():
	pass # Replace with function body.
