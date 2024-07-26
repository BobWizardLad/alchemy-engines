extends Resource
class_name Potion

# Potion stat layout for fuel burning
@export var armor_stat: float # armor
@export var damage_stat: int # damage
@export var resistance_stat: float # resistance
@export var special_stat: int # special_damage
@export var initiative_stat: int # initiative

# Potion stats for city burn
@export var city_burn_duration: int # burn_duration
@export var farming_yield: int # farming_yield

# Potion effects for thrown tile effects
@export var is_dot: bool # is_dot - bool
@export var damage_over_time: int # damage_over_time - int
@export var dot_duration: int # dot_duration - int
@export var engage_damage: int # engage_damage - int
@export var will_glow: bool # will_glow - bool
@export var tile_duration: int # tile_duration - int
@export var spread: int # spread - int
