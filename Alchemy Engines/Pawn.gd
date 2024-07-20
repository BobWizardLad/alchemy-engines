extends Sprite2D
class_name Pawn

@onready var motion_tween: Tween

@export var HEALTH_MAX: float # Persistent health
@export var ARMOR_MAX: float # Per-combat temp health
@export var RESISTANCE: float # % dmg reduction
@export var DAMAGE: int # damage dealing potential
@export var SPECIAL_DAMAGE: int # potions and chassis move potency
@export var INITIATIVE: float # Unit turn priority
@export var unit_chassis: Chassis # The chassis the unit is using

var current_health: float
var current_armor: float
var current_resistance: float
var current_damage: int
var current_special_damage: int
var current_initiative: float

var grid_pos: Vector2i

enum Chassis{Bigg, Fast, Help}

func _ready():
	current_health = HEALTH_MAX
	current_armor = ARMOR_MAX
	current_resistance = RESISTANCE
	current_damage = DAMAGE
	current_special_damage = SPECIAL_DAMAGE
	current_initiative = INITIATIVE
