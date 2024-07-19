extends Node2D
class_name TurnService

# Turn order 0 == player | 1 == enemy
@export var turn: int = 0

var turn_order: Array[Pawn] = []

# Call to determine turn order within the units provided by parameter
# WARNING this will wipe the previous turn order.
func populate_initiative(units: Array[Pawn]) -> Array[Pawn]:
	turn_order = [] # Wipe old turn order
	
	for each in units:
		if turn_order.is_empty():
			turn_order.append(each)
		else:
			for i in range(0, turn_order.size()+1):
				if i == turn_order.size():
					turn_order.append(each) # Append to end if largest init
				elif each.initiative <= turn_order[i].initiative:
					turn_order.insert(i, each) # Insert in front of current init
					break
				elif each.initiative > turn_order[i].initiative:
					continue # Do nothing if still traversing
	return turn_order

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
