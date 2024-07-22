extends Control

@onready var ACTIONS_MENU: Control = $ActionsMenu

# Set up the UI
func _ready():
	pass

func hide_actions_menu() -> void:
	ACTIONS_MENU.visible = false

# Tween the UI into frame
func focus_actions_menu() -> void:
	ACTIONS_MENU.visible = true

