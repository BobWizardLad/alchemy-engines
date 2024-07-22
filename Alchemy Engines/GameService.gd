extends Node2D


# Camera for scene
@onready var CAMERA: Camera2D = $CombatCamera
# Combat UI handler
@onready var UI: Control = $CombatCamera/UI
# Service to handle map and Astar services
@onready var NAV_SERVICE: NavService = $NavService
# Turn order is orchestrated by TurnService node
@onready var TURN_SERVICE: TurnService = $TurnService
# Reference to player controller
@onready var PLAYER_CONTROLLER: PlayerController = $PlayerController

var player: Pawn

# Flag to halt player input while pawn is moving
# Player cannot input during 'move step'
var is_move_step: bool
var move_action: bool
var attack_action: bool

func _ready():
	is_move_step = false
	move_action = false
	attack_action = false
	
	TURN_SERVICE.populate_initiative(PLAYER_CONTROLLER.get_children())
	PLAYER_CONTROLLER.snap_units(NAV_SERVICE.MAP)
	player = TURN_SERVICE.get_current_turn_pawn()
	NAV_SERVICE.build_astar_map(0)
	
	CAMERA.focus_next_unit(player)

func _process(_delta) -> void:
	if move_action:
		UI.hide_actions_menu()

func _input(event):
	if move_action:
		if event is InputEventMouseMotion and not is_move_step:
			# Clear prior planned path tint and make new path
			NAV_SERVICE.update_planned_path(player.position)
		else:
			# Call to wipe planned path visible
			NAV_SERVICE.MAP.clear_layer(1)
		if event is InputEventMouseButton and NAV_SERVICE.MAP.get_used_cells(0).find(NAV_SERVICE.MAP.local_to_map(get_local_mouse_position())) != -1:
			if not is_move_step:
				var path = NAV_SERVICE.ASTAR.get_astar_path(NAV_SERVICE.MAP.local_to_map(player.position), NAV_SERVICE.MAP.local_to_map(get_local_mouse_position()))
				PLAYER_CONTROLLER.pawn_move(NAV_SERVICE.MAP, path, player)
			# Disable player input and call a pawn move
			is_move_step = true

func _end_player_move_step():
	is_move_step = false
	move_action = false
	TURN_SERVICE.change_turn()
	display_debug_label(str(TURN_SERVICE.turn))
	player = TURN_SERVICE.get_current_turn_pawn()
	CAMERA.focus_next_unit(player)

func display_debug_label(msg: String) -> void:
	$DebugLabel.text = "Turn " + msg

func _on_move_button_down():
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	move_action = true
