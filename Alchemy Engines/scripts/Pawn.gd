extends Sprite2D
class_name Pawn

@onready var ANIMATION_PLAYER: AnimationPlayer = $AnimationPlayer

@export var pawn_name: String
@export var unit_type: Class # The chassis the unit is using
@export var HEALTH_MAX: float # Persistent health
@export var ARMOR_MAX: float # Per-combat temp health
@export var RESISTANCE: float # % dmg reduction
@export var DAMAGE: int # damage dealing potential
@export var SPECIAL_DAMAGE: int # potions and chassis move potency
@export var INITIATIVE: float # Unit turn priority
@export var MOVE: int # Unit max tiles travel per turn
@export var ATK_RANGE: int
@export var will_animate: bool = true # Turn off animations for dummies, etc

var motion_tween: Tween

var current_health: float
var current_armor: float
var current_resistance: float
var current_damage: int
var current_special_damage: int
var current_initiative: float
var current_move: int
var current_atk_range: int

var grid_pos: Vector2i

enum Class{Bigg, Fast, Help, Fat, Run, Shot}

func _ready():
	current_health = HEALTH_MAX
	current_armor = ARMOR_MAX
	current_resistance = RESISTANCE
	current_damage = DAMAGE
	current_special_damage = SPECIAL_DAMAGE
	current_initiative = INITIATIVE
	current_move = MOVE
	current_atk_range = ATK_RANGE
	ANIMATION_PLAYER.get_animation("idle").loop_mode = Animation.LOOP_LINEAR
	get_tree().create_timer(randi_range(0, 3)).connect("timeout", start_idle_anim)

func start_idle_anim():
	if will_animate:
		ANIMATION_PLAYER.play("idle")
