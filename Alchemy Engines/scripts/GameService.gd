extends Node2D

# Camera for scene
@onready var CAMERA: Camera2D = $CombatCamera
# Combat UI handler
@onready var UI: Control = $CombatCamera/UI
# Service to handle map and Astar services
@onready var NAV_SERVICE: NavService = $NavService
# Turn order is orchestrated by TurnService node
@onready var TURN_SERVICE: TurnService = $TurnService
# Reference pawn service that manages unit interactions
@onready var PAWN_SERVICE: PawnService = $PawnService

var active: Pawn

# Flag to halt player input while pawn is moving
# Player cannot input during 'move step'
var is_player_turn: bool
var is_move_step: bool
var move_action: bool
var is_attack_step: bool
var attack_action: bool

func _ready():
	is_player_turn = true
	is_move_step = false
	move_action = false
	attack_action = false
	is_attack_step = false
	
	TURN_SERVICE.populate_initiative(PAWN_SERVICE.get_all_units())
	PAWN_SERVICE.snap_units(NAV_SERVICE.MAP)
	NAV_SERVICE.build_astar_map(0)
	for each in PAWN_SERVICE.get_all_units():
		NAV_SERVICE.set_point_disabled(each.position, true)
	
	_on_new_turn()

func _process(_delta) -> void:
	display_debug_label(str(NAV_SERVICE.MAP.local_to_map(get_global_mouse_position())))
	
	if not is_player_turn || move_action || attack_action:
		UI.hide_actions_menu()
	elif is_player_turn && not move_action && not attack_action:
		UI.focus_actions_menu()

func _input(event):
	if move_action:
		if event is InputEventMouseButton and NAV_SERVICE.MAP.get_used_cells(0).find(NAV_SERVICE.MAP.local_to_map(get_local_mouse_position())) != -1:
			if not is_move_step:
				# Call to wipe planned path visible
				NAV_SERVICE.clear_selection_layer()
				# Set the pawn's pre-move position to enabled point
				NAV_SERVICE.set_point_disabled(active.position, false)
				var path = NAV_SERVICE.ASTAR.get_astar_path(NAV_SERVICE.MAP.local_to_map(active.position), NAV_SERVICE.MAP.local_to_map(get_local_mouse_position()))
				# Disable player input and call a pawn move
				is_move_step = true
				PAWN_SERVICE.pawn_move(NAV_SERVICE.MAP, path, active)
	if attack_action:
		if event is InputEventMouseButton and not is_attack_step:
			if get_cursor_hovering_unit(PAWN_SERVICE, NAV_SERVICE.MAP) != null:
				NAV_SERVICE.clear_selection_layer()
				is_attack_step = true
				PAWN_SERVICE.pawn_attack(active, get_cursor_hovering_unit(PAWN_SERVICE, NAV_SERVICE.MAP))

# Function to calculate most valuable turn for any unit
# Takes active_unit, map, astar, and list of current units
# returns an array containing
# [A] the most valuable path a unit should take,
# [B] the unit that shouldbe attacked if any,
# [C] the move that should be used
func calculate_turn(current_unit: Pawn, map: TileMap, astar: AstarService, current_units: Array[Node]) -> Array:
	var best_path: PackedVector2Array
	var target: Node2D
	var actions: PawnService.Action
	# Best Path
	# Target
	# Actions
	return [best_path, target, actions]

# Checks the position of all units to see if they are under the cursor.
# Returns the pawn under the cursor if ther is one, returns null if one is not there
func get_cursor_hovering_unit(pawn_service: PawnService, map: TileMap) -> Pawn:
	for each in PAWN_SERVICE.get_all_units():
		if each.position == map.map_to_local(map.local_to_map(get_local_mouse_position())):
			return each
	return null

func _end_move_step():
	is_move_step = false
	move_action = false
	# Set the pawn's new position to disable
	NAV_SERVICE.set_point_disabled(active.position, true)
	TURN_SERVICE.change_turn()

func _end_attack_step():
	is_attack_step = false
	attack_action = false
	TURN_SERVICE.change_turn()

func _player_skip_turn():
	TURN_SERVICE.change_turn()

func _on_new_turn():
	is_player_turn = TURN_SERVICE.get_current_turn_pawn().is_in_group("Allies")
	active = TURN_SERVICE.get_current_turn_pawn()
	UI.update_current_unit(active)
	CAMERA.focus_next_unit(active)

func _on_combat_camera_camera_move_finished():
	if TURN_SERVICE.get_current_turn_pawn().is_in_group("Allies"):
		pass
	elif TURN_SERVICE.get_current_turn_pawn().is_in_group("Enemies"):
		var path = NAV_SERVICE.ASTAR.get_astar_path(NAV_SERVICE.MAP.local_to_map(active.position), NAV_SERVICE.MAP.local_to_map(get_tree().get_nodes_in_group("Allies").pick_random().position))
		PAWN_SERVICE.pawn_move(NAV_SERVICE.MAP, path, active)

func display_debug_label(msg: String) -> void:
	$CombatCamera/DebugLabel.text = msg

func _on_move_button_down():
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	move_action = true
	NAV_SERVICE.show_planned_path(1, 1, Vector2(0, 0), NAV_SERVICE.get_cells_in_range(active.position, active.current_move))

func _on_action_button_down():
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	attack_action = true
	NAV_SERVICE.show_planned_path(1, 1, Vector2(0, 0), NAV_SERVICE.get_cells_in_range(active.position, active.current_atk_range))
