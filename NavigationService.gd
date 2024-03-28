extends Node

var current_level: GridMap

var astar_service: AStar3D
var valid_locations: Array[Vector3i]
var pitfalls: Array[Vector3i]

# Called when the node enters the scene tree for the first time.
func _ready():
	astar_service = AStar3D.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_directions(from: Vector3i, to: Vector3i) -> PackedVector3Array:
	print(astar_service.get_closest_point(from))
	print(astar_service.get_closest_point(to))
	return astar_service.get_point_path(astar_service.get_closest_point(from), astar_service.get_closest_point(to))

# Gets called to set the level being pathed around
func set_current_level(level: GridMap):
	current_level = level

# Creates the astar navigation service so that this service can provide
# directions to any given point
func build_navigation():
	# Add Points
	var index = 0 # (.(
	for each in valid_locations:
		astar_service.add_point(index, each)
		index += 1

	# Connection rules for points
	# Points must have z and x values within + or - 2=[GRID SCALE] from each other
	for n in range(0, valid_locations.size() - 1):
		for m in range(n+1, valid_locations.size()):
			if (valid_locations[n].z+2 == valid_locations[m].z or valid_locations[n].z-2 == valid_locations[m].z or valid_locations[n].z == valid_locations[m].z) and (valid_locations[n].x+2 == valid_locations[m].x or valid_locations[n].x-2 == valid_locations[m].x or valid_locations[n].x == valid_locations[m].x):
				if not astar_service.are_points_connected(n, m):
					astar_service.connect_points(n, m)

# This function builds the array of valid locations in the game level
# set by the set_current_level. This 
func build_pathfinding():
	valid_locations = current_level.get_used_cells()
	print(valid_locations)
	# Keep the location of pitfalls excluded from pathfinding unless 
	# the enemy floats
	pitfalls = current_level.get_used_cells_by_item(3)
	pitfalls.append_array(current_level.get_used_cells_by_item(12))
	pitfalls.append_array(current_level.get_used_cells_by_item(21))
	pitfalls.append_array(current_level.get_used_cells_by_item(25))
	pitfalls.append_array(current_level.get_used_cells_by_item(32))
	# Set grid y-level to 1 and remove pitfalls from pathfinding
	for each in valid_locations:
		#if pitfalls.has(each):
		#	valid_locations.remove_at(valid_locations.find(each))
		#	continue
		valid_locations[valid_locations.find(each)] = Vector3i(each.x*2, 1, each.z*2) # 2=[GRID_SCALE]
	
	print(valid_locations)
