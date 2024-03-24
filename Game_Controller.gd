extends Node3D

@onready var UNIT_CONTROLLER := $UnitController
@onready var PLAYER := $Player

func _process(_delta):
	sprite_facing()

# This function will orient all enemies' sprites on the map
# towards the player's location, creating an effect of the
# player always seeing the sprite of enemies.
func sprite_facing():
	for x in UNIT_CONTROLLER.get_children():
		x.find_child("Sprite").look_at(PLAYER.position)
