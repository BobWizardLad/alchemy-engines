extends Control

@onready var ACTIONS_MENU: Control = $ActionsMenu

@onready var unit_name_label: Label = $Stats/NameTexture/UnitName
@onready var unit_armor_bar: TextureProgressBar = $Stats/ArmorBar
@onready var unit_health_bar: TextureProgressBar = $Stats/HealthBar

var current_unit: Pawn = null

# Update unit stats in the UI window
func _process(_delta):
	if current_unit != null:
		unit_name_label.text = current_unit.pawn_name
		unit_armor_bar.value = current_unit.current_armor
		unit_health_bar.value = current_unit.current_health

func update_current_unit(new_unit: Pawn) -> void:
	current_unit = new_unit
	unit_armor_bar.max_value = current_unit.ARMOR_MAX
	unit_health_bar.max_value = current_unit.HEALTH_MAX

func hide_actions_menu() -> void:
	ACTIONS_MENU.visible = false

func hide_UI_menu() -> void:
	visible = false

# Tween the Actions Menu into frame
func focus_actions_menu() -> void:
	ACTIONS_MENU.visible = true

# Tween the UI into frame
func focus_UI_menu() -> void:
	visible = true
