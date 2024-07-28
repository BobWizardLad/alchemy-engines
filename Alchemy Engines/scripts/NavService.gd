extends Node2D
class_name NavService

@onready var ASTAR: AstarService = $AstarService
@onready var MAP: TileMap = $Map

# Stores the map tiles that are in the path chosen by cursor
# hover.
var map_tiles_active: PackedVector2Array

# Set the selection layer(1) tile at given position to 
# the selection overlay tile 
func focus_tile(local_pos: Vector2) -> void:
	MAP.set_cell(1, MAP.local_to_map(local_pos), 1, Vector2.ZERO)

# Clear the selection layer of any highlighted tiles
func clear_selection_layer() -> void:
	MAP.clear_layer(1)

func get_path_weight(path: Array[Vector2]) -> float:
	var weight: float
	for each in path:
		weight += ASTAR.get_point_weight_scale(ASTAR.astar2d.get_closest_point(each))
	return weight

# Handle path example
func get_map_cells_in_range(center_position: Vector2, range: int) -> Array[Vector2i]:
	var map_tiles_active: Array[Vector2i] = []
	var new_tiles: Array[Vector2i] = []
	map_tiles_active.append(MAP.local_to_map(center_position))
	for each in range(0, range):
		for tile in map_tiles_active:
			for item in MAP.get_surrounding_cells(tile):
				if new_tiles.find(item) == -1 && MAP.get_cell_tile_data(0, item) != null && MAP.get_cell_tile_data(0, item).get_custom_data("walkable"):
					new_tiles.append(item)
		for tile in new_tiles:
			if map_tiles_active.find(tile) == -1:
				map_tiles_active.append(tile)
	return map_tiles_active

func show_planned_path(vis_layer_id: int, img_src_id: int, atlas_pos: Vector2, path: Array[Vector2i]):
	clear_selection_layer()
	for each in path.slice(1):
		MAP.set_cell(vis_layer_id, each, img_src_id, atlas_pos)

# Build astar map with added unit locations as obstacles
func build_astar_map(layer: int) -> void:
	# Get all non-null unit positions on map
	ASTAR.build_astar_map(MAP, layer)

# Get path to point
func get_astar_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	return ASTAR.get_astar_path(from, to)

func set_point_disabled(new_pos: Vector2, is_disabled: bool) -> void:
	ASTAR.set_point_disabled(MAP.local_to_map(new_pos), is_disabled) # Disable new position
