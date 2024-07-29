extends Node2D
class_name PawnService

# Reference to unit controllers
@onready var PLAYER_CONTROLLER: PlayerController = $PlayerController
@onready var ENEMY_CONTROLLER: Node2D = $EnemyController

signal move_step_finished
signal attack_step_finished

enum Action {Attack, Special, Skip, Potion}

func _ready():
	connect("move_step_finished", get_parent()._end_move_step)
	connect("attack_step_finished", get_parent()._end_attack_step)

func get_all_units() -> Array[Node]:
	var all_units = PLAYER_CONTROLLER.get_children()# + ENEMY_CONTROLLER.get_children()
	return all_units

func snap_units(map: TileMap):
	for each in get_all_units():
		each.position = map.map_to_local(map.local_to_map(each.position))

func pawn_attack(attacker: Pawn, target: Pawn):
	if target.current_armor > 0:
		target.current_armor -= attacker.current_damage * (1.0 - target.current_resistance)
		if target.current_armor < 0:
			target.current_health += target.current_armor
			target.current_armor = 0
	elif target.current_armor <= 0:
		target.current_health -= attacker.current_damage * (1.0 - target.current_resistance)
	emit_signal("attack_step_finished")

# path is a list of points handed to the move command.
# map is the tilemap being naviated
func pawn_move(map: TileMap, path: PackedVector2Array, pawn: Pawn):
	var motion_tween
	var my_path = path.slice(0, pawn.current_move+1)
	if motion_tween != null and motion_tween.is_running():
		return false
	else:
		for each in my_path:
			motion_tween = get_tree().create_tween()
			motion_tween.tween_property(pawn, "position", map.map_to_local(each), 0.2)
			await motion_tween.finished
	emit_signal("move_step_finished")
