extends Node2D
class_name NavService

@onready var ASTAR: AstarService = $AstarService
@onready var MAP: TileMap = $Map

# Stores the map tiles that are in the path chosen by cursor
# hover.
var map_tiles_active: PackedVector2Array

# Handle path example -TEST-
func update_planned_path(active_pawn: Pawn) -> void:
	MAP.clear_layer(1)
	map_tiles_active = ASTAR.get_astar_path(MAP.local_to_map(active_pawn.position), MAP.local_to_map(get_local_mouse_position()))
	MAP.show_planned_path(1, 1, Vector2(0, 0), map_tiles_active.slice(0, active_pawn.current_move))

# Build astar map with added unit locations as obstacles
func build_astar_map(layer: int) -> void:
	# Get all non-null unit positions on map
	ASTAR.build_astar_map(MAP, layer)

# Get path to point
func get_astar_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	return get_astar_path(from, to)

func set_point_disabled(new_pos: Vector2, is_disabled: bool) -> void:
	ASTAR.set_point_disabled(MAP.local_to_map(new_pos), is_disabled) # Disable new position
