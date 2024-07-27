extends Camera2D

@export var target: Node2D

signal camera_move_finished

func _ready():
	pass

func _process(_delta):
	pass#position = target.global_position

# Tween the camera to the next unit 
func focus_next_unit(new_focus: Node2D):
	target = new_focus
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'position', target.global_position, 0.8).set_trans(Tween.TRANS_SINE)
	await tween.finished
	emit_signal("camera_move_finished")
