extends Node

@export var HEALTH_MAX: int = 100
@export var POWER: int = 27
@export var FOCUS_MAX: int = 4
@export var FOCUS_POWER: int = 65

var health
var focus

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
		print("Not a Combat Component!")
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
			print("Out of Focus!")
			return false
	else:
		print("Not a Combat Component!")
		return false

# Is called with incoming damage as a parameter, and 
# returns the clamped health value.
func take_damage(damage: int) -> int:
	health -= damage
	health = clamp(health, 0, HEALTH_MAX)
	print(health)
	return health
