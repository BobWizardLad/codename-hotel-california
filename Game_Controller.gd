extends Node3D

@onready var UNIT_CONTROLLER := $UnitController
@onready var PLAYER := $Player
@onready var LEVEL: GridMap = $Level01

var valid_locations: Array[Vector3i]
var pitfalls: Array[Vector3i]

func _ready():
	build_pathfinding()

func _process(_delta):
	sprite_facing()

# This function 
func build_pathfinding():
	valid_locations = LEVEL.get_used_cells()
	# Keep the location of pitfalls excluded from pathfinding unless 
	# the enemy floats
	pitfalls = LEVEL.get_used_cells_by_item(3)
	pitfalls.append_array(LEVEL.get_used_cells_by_item(12))
	pitfalls.append_array(LEVEL.get_used_cells_by_item(21))
	pitfalls.append_array(LEVEL.get_used_cells_by_item(25))
	pitfalls.append_array(LEVEL.get_used_cells_by_item(32))
	# Set grid y-level to 1 and remove pitfalls from pathfinding
	for each in valid_locations:
		if pitfalls.has(each):
			valid_locations.remove_at(valid_locations.find(each))
			continue
		valid_locations[valid_locations.find(each)] = Vector3i(each.x, 1, each.z)
	
	print(valid_locations)

# This function will orient all enemies' sprites on the map
# towards the player's location, creating an effect of the
# player always seeing the sprite of enemies.
func sprite_facing():
	for x in UNIT_CONTROLLER.get_children():
		x.find_child("Sprite").look_at(PLAYER.position)
