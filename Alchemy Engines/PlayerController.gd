extends Node
class_name PlayerController

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func snap_units(map: TileMap):
	for each in get_children():
		each.position = map.map_to_local(map.local_to_map(each.position))
