extends Node3D

@onready var UNIT_CONTROLLER := $UnitController
@onready var NAVIGATION_SERVICE := $NavigationService
@onready var TURN_CONTROLLER := $TurnController
@onready var PLAYER := $Player
@onready var TEXT_OVERLAY : Control = $TextOverlay
@onready var level: GridMap

@export var fighter_artifact_get: bool = false
@export var rouge_artifact_get: bool = false
@export var paladin_artifact_get: bool = false
@export var mage_artifact_get: bool = false

func _ready():
	level = find_child("Level02")
	
	# Handling Navservice here
	NAVIGATION_SERVICE.set_current_level(level)
	NAVIGATION_SERVICE.build_pathfinding()
	NAVIGATION_SERVICE.build_navigation()
	
	TURN_CONTROLLER.emit_signal("take_player_turn")
	_on_portal_transition()

func _on_portal_transition():
	# Check for artifacts and turn boys on
	var persona = randi_range(0, 3)
	var message
	
	# --TODO-- only pick boys that are on
	if persona == 0:
		PLAYER.fighter_is_active = true
		message = "The mind of the Fighter takes hold..."
	elif persona == 1:
		PLAYER.rouge_is_active = true
		message = "The mind of the Rouge takes hold..."
	elif persona == 2:
		PLAYER.paladin_is_active = true
		message = "The mind of the Paladin takes hold..."
	elif persona == 3:
		PLAYER.mage_is_active = true
		message = "The mind of the Mage takes hold..."
	else:
		PLAYER.fighter_is_active = true
		message = "The mind of the Fighter takes hold..."
	
	TEXT_OVERLAY._prompt_text_overlay(message, 3)

func _process(_delta):
	sprite_facing()

# This function will orient all enemies' sprites on the map
# towards the player's location, creating an effect of the
# player always seeing the sprite of enemies.
func sprite_facing():
	for x in UNIT_CONTROLLER.get_children():
		x.find_child("Sprite").look_at(PLAYER.position)
