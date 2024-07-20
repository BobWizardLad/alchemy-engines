extends Node2D
class_name Health

@export var HEALTH_MAX: float

@onready var HEALTH_BAR: TextureProgressBar = $HealthBar

var current_health: float

func _ready():
	current_health = HEALTH_MAX

func take_damage(damage: float) -> float:
	current_health -= damage
	return current_health
