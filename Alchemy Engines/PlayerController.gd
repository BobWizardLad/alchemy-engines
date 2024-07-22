extends Node2D
class_name PlayerController

signal move_step_finished

func _ready():
	connect("move_step_finished", get_parent()._end_player_move_step)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func snap_units(map: TileMap):
	for each in get_children():
		each.position = map.map_to_local(map.local_to_map(each.position))

# path is a list of points handed to the move command.
# map is the tilemap being naviated
func pawn_move(map: TileMap, path: PackedVector2Array, pawn: Pawn):
	var motion_tween
	if motion_tween != null and motion_tween.is_running():
		return false
	else:
		for each in path:
			motion_tween = get_tree().create_tween()
			motion_tween.tween_property(pawn, "position", map.map_to_local(each), 0.1)
			await motion_tween.finished
	pawn.grid_pos = path[-1]
	emit_signal("move_step_finished")
