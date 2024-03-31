extends Node3D

@onready var PLAYER_UI := $PlayerUI
@onready var UNIT_CONTROLLER := $UnitController
@onready var NAVIGATION_SERVICE := $NavigationService
@onready var TURN_CONTROLLER := $TurnController
@onready var PLAYER := $Player
@onready var GAME_LEVEL := $GameLevel
@onready var TEXT_OVERLAY: Control = $TextOverlay
@onready var level: GridMap

@export var fighter_artifact_get: bool = true
@export var rouge_artifact_get: bool = true
@export var paladin_artifact_get: bool = true
@export var mage_artifact_get: bool = true
var valid_persona_range: Array = []

func _ready():
	level = find_child("GameLevel")
	
	# Handling Navservice here
	NAVIGATION_SERVICE.set_current_level(level)
	NAVIGATION_SERVICE.build_pathfinding()
	NAVIGATION_SERVICE.build_navigation()
	
	TURN_CONTROLLER.emit_signal("take_player_turn")
	_on_portal_transition()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if PLAYER_UI.HELP_OVERLAY.visible:
			PLAYER_UI.HELP_OVERLAY.hide()
		else:
			PLAYER_UI.HELP_OVERLAY.show()

func _on_portal_transition():
	var message
	
	if fighter_artifact_get:
		PLAYER.fighter_is_active = true
	else:
		valid_persona_range.append(0)
	if rouge_artifact_get:
		PLAYER.rouge_is_active = true
	else:
		valid_persona_range.append(1)
	if paladin_artifact_get:
		PLAYER.paladin_is_active = true
	else:
		valid_persona_range.append(2)
	if mage_artifact_get:
		PLAYER.mage_is_active = true
	else:
		valid_persona_range.append(3)
	
	var persona: int
	if valid_persona_range.size() > 0:
		persona = valid_persona_range.pick_random()
	else:
		message = "You have regained mastery over your mind..."
		persona = 5
	
	if persona == 0:
		PLAYER.fighter_is_active = true
		message = "The persona of the Beserk takes hold..."
	elif persona == 1:
		PLAYER.rouge_is_active = true
		message = "The persona of the Rouge takes hold..."
	elif persona == 2:
		PLAYER.paladin_is_active = true
		message = "The persona of the Holy takes hold..."
	elif persona == 3:
		PLAYER.mage_is_active = true
		message = "The persona of the Mystic takes hold..."
	else:
		pass
	
	TEXT_OVERLAY._prompt_text_overlay(message, 2.5)
	valid_persona_range = []

func _process(_delta):
	sprite_facing()

# This function will orient all enemies' sprites on the map
# towards the player's location, creating an effect of the
# player always seeing the sprite of enemies.
func sprite_facing():
	for x in UNIT_CONTROLLER.get_children():
		x.find_child("Sprite").look_at(PLAYER.position)


func _on_player_artifact_pickup(identity: String):
	print("SIGNAL PASSED")
	if identity == "Fighter":
		fighter_artifact_get = true
		PLAYER_UI.FIGHTER_ARTIFACT.show()
		TEXT_OVERLAY._prompt_text_overlay("You have aquired the beserker artifact", 2.5)
	elif identity == "Rouge":
		rouge_artifact_get = true
		PLAYER_UI.ROUGE_ARTIFACT.show()
		TEXT_OVERLAY._prompt_text_overlay("You have aquired the rouge artifact", 2.5)
	elif identity == "Paladin":
		paladin_artifact_get = true
		PLAYER_UI.PALADIN_ARTIFACT.show()
		TEXT_OVERLAY._prompt_text_overlay("You have aquired the holy artifact", 2.5)
	elif identity == "Mage":
		mage_artifact_get = true
		PLAYER_UI.MAGE_ARTIFACT.show()
		TEXT_OVERLAY._prompt_text_overlay("You have aquired the mystic artifact", 2.5)
	else:
		return
