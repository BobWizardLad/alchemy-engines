extends Node2D
class_name TurnService

# Turn order 0 == player | 1 == enemy
@export var turn: int = 0

# Execute player turn
func player_turn():
	pass

# Execute enemy turn
func enemy_turn():
	pass

# Return the current turn
func get_current_turn() -> int:
	return turn

# Change the current turn
func change_turn() -> Node2D:
	if turn == 0:
		turn = 1
	elif turn == 1:
		turn = 0
	return self
