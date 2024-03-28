extends Node3D

@onready var UNIT_CONTROLLER := $UnitController
@onready var NAVIGATION_SERVICE := $NavigationService
@onready var PLAYER := $Player
@onready var level: GridMap

func _ready():
	level = find_child("Level01")
	
	# Handling Navservice here
	NAVIGATION_SERVICE.set_current_level(level)
	NAVIGATION_SERVICE.build_pathfinding()
	NAVIGATION_SERVICE.build_navigation()

func _process(_delta):
	sprite_facing()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		UNIT_CONTROLLER.on_enemy_turn()

# This function will orient all enemies' sprites on the map
# towards the player's location, creating an effect of the
# player always seeing the sprite of enemies.
func sprite_facing():
	for x in UNIT_CONTROLLER.get_children():
		x.find_child("Sprite").look_at(PLAYER.position)
