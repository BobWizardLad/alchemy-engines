extends Sprite2D
class_name Pawn

@onready var motion_tween: Tween

@export var HEALTH_MAX: float
@export var initiative: float

var current_health: float
var grid_pos: Vector2i
