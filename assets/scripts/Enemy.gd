# Similar function to a player, but does not hold a camera and moves according
# to an AI/ sees according to raycasts.
extends Node3D

@onready var CAST_NORTH: RayCast3D = $CastNorth # Dir 0
@onready var CAST_EAST: RayCast3D = $CastEast # Dir 1
@onready var CAST_SOUTH: RayCast3D = $CastSouth # Dir 2
@onready var CAST_WEST: RayCast3D = $CastWest # Dir 3
@onready var COMBAT_COMPONENT: Node = $CombatComponent # Unit Combat Controller
@onready var SPRITE: AnimatedSprite3D = $Sprite # Visual Component

@export var TWEEN_FACTOR = 0.3 # Affects camera interpolation speed
@export var GRID_SCALE = 2 # Factor for movement; constrains grid
@export var animation_death: SpriteFrames

var motion_tween: Tween
var is_player_visible: bool

var target: Vector3i
var current_path: PackedVector3Array

func _ready():
	pass

func _process(_delta):
	var health_modulate = COMBAT_COMPONENT.health * .01
	SPRITE.modulate = Color(1.0, health_modulate, health_modulate, 1.0)
	
	if COMBAT_COMPONENT.health == 0:
		queue_free()

func set_target(target_val: Vector3i):
	target = target_val

func animate_death():
	SPRITE.sprite_frames = animation_death
	SPRITE.play()
	await SPRITE.animation_finished

# move_step takes a target location and will move the enemy towards it
# target location is detemined by the greatest distance to travel. i.e. if
# the location is 4, 8 (x, z) and the target is 12, -2, the enemy will move
# in the +z direction because that is the biggest distance it has to travel.
# if the favored direction is blocked, it will pick the next unblocked direction
# (+x, +z, -x, -z priority order)
func move_step() -> bool:
	if motion_tween is Tween: # Halt another tween if one is running
		if motion_tween.is_running():
			return false
	if current_path.size() > 2:
		current_path.remove_at(0) # First location is always my lcoation
		target = current_path[0] # Set next step in path as target
	else:
		return false
	
	if abs(target.x - global_transform.origin.x) > abs(target.z - global_transform.origin.z):
		if target.x > global_transform.origin.x and not CAST_SOUTH.is_colliding():
			motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			motion_tween.tween_property(self, "transform", transform.translated(Vector3(GRID_SCALE, 0, 0)), TWEEN_FACTOR)
			current_path.remove_at(0) # Clean up the path step we just moved to
			await motion_tween.finished
			return true
		elif target.x < global_transform.origin.x and not CAST_NORTH.is_colliding():
			motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			motion_tween.tween_property(self, "transform", transform.translated(Vector3(-GRID_SCALE, 0, 0)), TWEEN_FACTOR)
			current_path.remove_at(0) # Clean up the path step we just moved to
			await motion_tween.finished
			return true
		else: 
			return false
	elif abs(target.x - global_transform.origin.x) <= abs(target.z - global_transform.origin.z):
		if target.z > global_transform.origin.z and not CAST_WEST.is_colliding():
			motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			motion_tween.tween_property(self, "transform", transform.translated(Vector3(0, 0, GRID_SCALE)), TWEEN_FACTOR)
			current_path.remove_at(0) # Clean up the path step we just moved to
			await motion_tween.finished
			return true
		elif target.z < global_transform.origin.z and not CAST_EAST.is_colliding():
			motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			motion_tween.tween_property(self, "transform", transform.translated(Vector3(0, 0, -GRID_SCALE)), TWEEN_FACTOR)
			current_path.remove_at(0) # Clean up the path step we just moved to
			await motion_tween.finished
			return true
		else:
			return false
	else:
		return false

# This function will check each collider and see if the player is adjacent
# i.e. if the parent of any collider is in group "Player"
# Will return that parent node if it collided, will return null
# if nothing is found
func get_player_adjacent() -> Node3D:
	if CAST_EAST.get_collider() != null and CAST_EAST.get_collider().get_parent().is_in_group("Player"):
		return CAST_EAST.get_collider().get_parent()
	elif CAST_NORTH.get_collider() != null and CAST_NORTH.get_collider().get_parent().is_in_group("Player"):
		return CAST_NORTH.get_collider().get_parent()
	elif CAST_SOUTH.get_collider() != null and CAST_SOUTH.get_collider().get_parent().is_in_group("Player"):
		return CAST_SOUTH.get_collider().get_parent()
	elif CAST_WEST.get_collider() != null and CAST_WEST.get_collider().get_parent().is_in_group("Player"):
		return CAST_WEST.get_collider().get_parent()
	else:
		return null

func _on_player_visible_screen_entered():
	is_player_visible = true

func _on_player_visible_screen_exited():
	is_player_visible = false
