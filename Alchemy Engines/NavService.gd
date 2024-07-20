extends Node2D
class_name NavService

@onready var ASTAR: AstarService = $AstarService
@onready var MAP: TileMap = $Map

# Stores the map tiles that are in the path chosen by cursor
# hover.
var map_tiles_active: PackedVector2Array

# Handle path example -TEST-
func update_planned_path(active_pawn_pos: Vector2) -> void:
	MAP.clear_layer(1)
	map_tiles_active = ASTAR.get_astar_path(MAP.local_to_map(active_pawn_pos), MAP.local_to_map(get_local_mouse_position()))
	MAP.show_planned_path(1, 0, Vector2(4, 0), map_tiles_active)

# Build astar map with added unit locations as obstacles
func build_astar_map(layer: int) -> void:
	# Get all non-null unit positions on map
	ASTAR.build_astar_map(MAP, layer)

# Get path to point
func get_astar_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	return get_astar_path(from, to)
