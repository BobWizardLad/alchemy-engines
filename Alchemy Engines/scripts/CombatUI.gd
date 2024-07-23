extends Control

@onready var ACTIONS_MENU: Control = $ActionsMenu

@onready var unit_name: Label = $Stats/NameTexture/UnitName

# Set up the UI
func _ready():
	pass

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
