extends Node3D

@onready var NAVIGATION_SERVICE := get_node("NavigationService")

signal turn_end

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_enemy_turn():
	for each in get_children():
		# Determine if player can see enemy - Enemy Func
		# Create Route, set in enemy
		# Execute attack if player is adjacent - Enemy Func x2
		# if player not adjacent, call move step 
		each.move_step()
	emit_signal("turn_end")
