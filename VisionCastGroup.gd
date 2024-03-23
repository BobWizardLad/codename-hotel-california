extends Node3D

@onready var cast_group := get_children()

# This function will get raycasts from each raycast in the raycast group, and will
# return the given node by NAME. (i.e. the parameter is the name of the node
# you are seeking.
func get_enemy_raycast(name: String) -> Node:
	for each in cast_group:
		var obstacle = each.get_collider()
		if obstacle != null and obstacle.get_name() == name:
			return obstacle
	return null
