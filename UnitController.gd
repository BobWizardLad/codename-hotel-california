extends Node3D

@onready var NAVIGATION_SERVICE := get_node("../NavigationService")
@onready var PLAYER := get_node("../Player")

var directions: PackedVector3Array

signal turn_end

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_enemy_turn():
	for each in get_children():
		
		if each.is_player_visible:
			each.current_path = NAVIGATION_SERVICE.get_directions(each.position, PLAYER.position)
		if each.get_player_adjacent() != null:
			each.COMBAT_COMPONENT.attack(each.get_player_adjacent().COMBAT_COMPONENT)
		else:
			each.move_step()
		# if player not adjacent, call move step 
	emit_signal("turn_end")
