extends Node2D

# Nodes concerned with navigation will call nav service
@onready var NAV_SERVICE: Node = $NavService
# Turn order is orchestrated by TurnService node
@onready var TURN_SERVICE: TurnService = $TurnService
# Reference to tilemap node
@onready var MAP: TileMap = $Environment/Map
# Reference to player controller
@onready var PLAYER: Pawn = $PlayerController/Player
@onready var PLAYER_CONTROLLER: PlayerController = $PlayerController

# Stores the map tiles that are in the path chosen by cursor
# hover.
var map_tiles_active: PackedVector2Array

# Flag to halt player input while pawn is moving
# Player cannot input during 'move step'
var is_move_step: bool

func _ready():
	is_move_step = false
	# Inital building of the ASTAR graph
	# Connection of points, edge weights, etc.
	NAV_SERVICE.build_astar_map(MAP, 0)
	NAV_SERVICE.update_logical_map(PLAYER, Vector2i(0,0))
	
	PLAYER_CONTROLLER.snap_units(MAP)
	print(TURN_SERVICE.populate_initiative([PLAYER]))
	
func _input(event):
	if event is InputEventMouseMotion and not is_move_step:
		# Clear prior planned path tint and make new path
		MAP.clear_layer(1)
		map_tiles_active = NAV_SERVICE.get_astar_path(MAP.local_to_map(PLAYER.position), MAP.local_to_map(get_local_mouse_position()))
		# Vis Layer ID, Img Src ID, Atlas Pos, Path
		MAP.show_planned_path(1, 0, Vector2(4, 0), map_tiles_active)
	else:
		MAP.clear_layer(1)
	if event is InputEventMouseButton:
		# Disable player input and call a pawn move
		is_move_step = true
		PLAYER.pawn_move(MAP, NAV_SERVICE.get_astar_path(MAP.local_to_map(PLAYER.position), MAP.local_to_map(get_local_mouse_position())))

func _end_player_move_step():
	is_move_step = false
	display_debug_label(str(TURN_SERVICE.get_current_turn()))
	TURN_SERVICE.change_turn()

func display_debug_label(msg: String) -> void:
	$DebugLabel.text = msg
