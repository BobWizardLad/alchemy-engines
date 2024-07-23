extends Node2D
class_name TurnService

# Turn order 0 == player | 1 == enemy
@export var turn: int = 0

var turn_order: Array[Node] = []

# Call to determine turn order within the units provided by parameter
# WARNING this will wipe the previous turn order.
func populate_initiative(units: Array[Node]) -> Array[Node]:
	turn_order = [] # Wipe old turn order
	
	for each in units:
		if turn_order.is_empty():
			turn_order.append(each)
		else:
			for i in range(0, turn_order.size()+1):
				if i == turn_order.size():
					turn_order.append(each) # Append to end if largest init
				elif each.current_initiative <= turn_order[i].current_initiative:
					turn_order.insert(i, each) # Insert in front of current init
					break
				elif each.current_initiative > turn_order[i].current_initiative:
					continue # Do nothing if still traversing
	return turn_order

# Return the current turn's pawn
func get_current_turn_pawn() -> Pawn:
	return turn_order[turn]

# Change the current turn
func change_turn() -> Node2D:
	if turn < turn_order.size()-1:
		turn += 1
	elif turn > turn_order.size()-1:
		turn = 0
	else:
		turn = 0
	
	return self
