extends Node2D

var astar2d: AStar2D = AStar2D.new()
var astar_points: PackedInt64Array
var next_id: int

var logical_map: Dictionary

func _ready():
	next_id = 0
	astar_points = []
	logical_map = {}

# This function will build a navigation graph in the Astar2D object from
# the given map using tiles from the given layer.
# map: the tilemap being used for navigation; layer: layer of the map being used for navigation
func build_astar_map(map: TileMap, layer: int) -> Node2D:
	# Add points to the nav that are valid to traverse
	for each in map.get_used_cells(layer):
		if map.get_cell_tile_data(layer, each).get_custom_data("walkable"):
			add_point(each)
			logical_map[each] = null
	astar_points = astar2d.get_point_ids()
	
	for each in astar_points:
		for compare in astar_points.slice(astar_points.find(each)):
			if astar2d.get_point_position(compare) as Vector2i in map.get_surrounding_cells(astar2d.get_point_position(each)):
				astar2d.connect_points(each, compare)
	return self

func update_logical_map(pawn: Pawn, pos: Vector2i) -> Node2D:
	logical_map[pos] = pawn
	return self

# This function will safely pass the Astar2D's pathfinding call
func get_astar_path(from: Vector2i, to: Vector2i) -> PackedVector2Array:
	return astar2d.get_point_path(astar2d.get_closest_point(from), astar2d.get_closest_point(to))

# Safe helper function to add points to an Astar2D graph
# Accounts for next_id to assign tile IDs
func add_point(point: Vector2i) -> Node2D:
	astar2d.add_point(next_id, point)
	next_id += 1
	return self
