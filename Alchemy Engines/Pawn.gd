extends Sprite2D
class_name Pawn

@onready var motion_tween: Tween

var grid_pos: Vector2i

signal move_step_finished

func _ready():
	connect("move_step_finished", get_parent()._end_player_move_step)

# path is a list of points handed to the move command.
# map is the tilemap being naviated
func pawn_move(map: TileMap, path: PackedVector2Array):
	if motion_tween != null and motion_tween.is_running():
		return false
	else:
		for each in path:
			motion_tween = get_tree().create_tween()
			motion_tween.tween_property(self, "position", map.map_to_local(each), 0.1)
			await motion_tween.finished
	emit_signal("move_step_finished")

