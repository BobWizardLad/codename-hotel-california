extends Node

@export var HEALTH_MAX: int = 100
@export var POWER: int = 27
@export var FOCUS_MAX: int = 4
@export var FOCUS_POWER: int = 65
@export var DOT_SEVERITY: int = 15

var health: int
var focus: int
var is_poisoned: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	health = HEALTH_MAX
	focus = FOCUS_MAX

# Called with the target of the attack (must be a CombatComponent)
# Attempts a normal attack, returns if the attack was successful
# or not (invalid target).
func attack(target: Node) -> bool:
	if target.name == "CombatComponent":
		target.take_damage(POWER)
		return true
	else:
		return false

# Called with the target of the attack (must be a CombatComponent)
# Attempts a focus attack and drains focus, returns if the attack was successful
# or not (invalid target, no focus).
func focus_attack(target: Node) -> bool:
	if target.name == "CombatComponent":
		if focus > 0:
			focus -= 1
			target.take_damage(FOCUS_POWER)
			return true
		else:
			return false
	else:
		return false

# Is called with incoming damage as a parameter, and 
# returns the clamped health value.
func take_damage(damage: int) -> int:
	health -= damage
	health = clamp(health, 0, HEALTH_MAX)
	return health

func take_DOT() -> int:
	health -= DOT_SEVERITY
	health = clamp(health, 0, HEALTH_MAX)
	return health
