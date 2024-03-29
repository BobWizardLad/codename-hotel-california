extends Node3D

@onready var cast_group := get_child(0)

# This function will get raycasts from each raycast in the raycast group, and will
# return the given node by NAME. (i.e. the parameter is the name of the node
# you are seeking.
func get_enemy_raycast() -> Object:
	if cast_group.is_colliding():
		return cast_group.collider
	else:
		return null
