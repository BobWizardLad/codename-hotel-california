extends Node

@export var HEALTH_MAX: int = 100

@export var FIGHTER_POWER: int = 20
@export var MAGE_POWER: int = 17
@export var MAGE_FOCUS_POWER: int = 25
@export var ROUGE_POWER: int = 17
@export var PALADIN_POWER: int = 20
@export var PALADIN_FOCUS_POWER: int = 30

@export var FIGHTER_FOCUS_MAX: int = 4
@export var ROUGE_FOCUS_MAX: int = 4
@export var MAGE_FOCUS_MAX: int = 4
@export var PALADIN_FOCUS_MAX: int = 4

var health
var fighter_focus
var rouge_focus
var mage_focus
var paladin_focus

# Called when the node enters the scene tree for the first time.
func _ready():
	health = HEALTH_MAX
	fighter_focus = FIGHTER_FOCUS_MAX
	rouge_focus = ROUGE_FOCUS_MAX
	mage_focus = MAGE_FOCUS_MAX
	paladin_focus = PALADIN_FOCUS_MAX

# Called with the target of the attack (must be a CombatComponent)
# Attempts a normal attack, returns if the attack was successful
# or not (invalid target).
func fighter_attack(target: Node) -> bool:
	if target.name == "CombatComponent" or target.name == "PlayerCombatComponent":
		target.take_damage(FIGHTER_POWER)
		return true
	else:
		return false

# Called with the target of the attack (must be a CombatComponent)
# Attempts a normal attack, returns if the attack was successful
# or not (invalid target).
func rouge_attack(target: Node) -> bool:
	if target.name == "CombatComponent" or target.name == "PlayerCombatComponent":
		target.take_damage(ROUGE_POWER)
		return true
	else:
		return false

# Called with the target of the attack (must be a CombatComponent)
# Attempts a normal attack, returns if the attack was successful
# or not (invalid target).
func mage_attack(target: Node) -> bool:
	if target.name == "CombatComponent" or target.name == "PlayerCombatComponent":
		target.take_damage(MAGE_POWER)
		return true
	else:
		return false

# Called with the target of the attack (must be a CombatComponent)
# Attempts a normal attack, returns if the attack was successful
# or not (invalid target).
func paladin_attack(target: Node) -> bool:
	if target.name == "CombatComponent" or target.name == "PlayerCombatComponent":
		target.take_damage(PALADIN_POWER)
		return true
	else:
		return false

# Called with the target of the attack (must be a CombatComponent)
# Attempts a focus attack and drains focus, returns if the attack was successful
# or not (invalid target, no focus).
func fighter_focus_attack(target: Node) -> bool:
	if target.name == "CombatComponent":
		if fighter_focus > 0:
			fighter_focus -= 1
			target.take_damage(FIGHTER_POWER)
			return true
		else:
			return false
	else:
		return false

# Called with the target of the attack (must be a CombatComponent)
# Attempts a focus attack and drains focus, returns if the attack was successful
# or not (invalid target, no focus).
func rouge_focus_attack(target: Node) -> bool:
	if target.name == "CombatComponent":
		if rouge_focus > 0:
			rouge_focus -= 1
			target.take_damage(ROUGE_POWER)
			target.is_poisoned = true # Rouge's special causes DOT
			return true
		else:
			return false
	else:
		return false

# Called with the target of the attack (must be a CombatComponent)
# Attempts a focus attack and drains focus, returns if the attack was successful
# or not (invalid target, no focus).
func mage_focus_attack(target: Node) -> bool:
	if target.name == "CombatComponent":
		if mage_focus > 0:
			mage_focus -= 1
			target.take_damage(MAGE_FOCUS_POWER)
			return true
		else:
			return false
	else:
		return false

# Called with the target of the attack (must be a CombatComponent)
# Attempts a focus attack and drains focus, returns if the attack was successful
# or not (invalid target, no focus).
func paladin_focus_attack(target: Node) -> bool:
	if target.name == "CombatComponent":
		if paladin_focus > 0:
			paladin_focus -= 1
			target.take_damage(PALADIN_FOCUS_POWER)
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
