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

var motion_tween
var rand

func _ready():
	pass

func _process(_delta):
	var health_modulate = COMBAT_COMPONENT.health * .01
	SPRITE.modulate = Color(1.0, health_modulate, health_modulate, 1.0)
	
	if COMBAT_COMPONENT.health == 0:
		queue_free()

# move_step takes a target location and will move the enemy towards it
# target location is detemined by the greatest distance to travel. i.e. if
# the location is 4, 8 (x, z) and the target is 12, -2, the enemy will move
# in the +z direction because that is the biggest distance it has to travel.
# if the favored direction is blocked, it will pick the next unblocked direction
# (+x, +z, -x, -z priority order)
func move_step(target: Vector3):
	if motion_tween is Tween: # Halt another tween if one is running
		if motion_tween.is_running():
			return
	if abs(target.x - global_transform.origin.x) > abs(target.z - global_transform.origin.z):
		if target.x > global_transform.origin.x and not CAST_SOUTH.is_colliding():
			motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			motion_tween.tween_property(self, "transform", transform.translated(Vector3(GRID_SCALE, 0, 0)), TWEEN_FACTOR)
		elif target.x < global_transform.origin.x and not CAST_NORTH.is_colliding():
			motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			motion_tween.tween_property(self, "transform", transform.translated(Vector3(-GRID_SCALE, 0, 0)), TWEEN_FACTOR)
	elif abs(target.x - global_transform.origin.x) <= abs(target.z - global_transform.origin.z):
		if target.z > global_transform.origin.z and not CAST_WEST.is_colliding():
			motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			motion_tween.tween_property(self, "transform", transform.translated(Vector3(0, 0, GRID_SCALE)), TWEEN_FACTOR)
		elif target.z < global_transform.origin.z and not CAST_EAST.is_colliding():
			motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
			motion_tween.tween_property(self, "transform", transform.translated(Vector3(0, 0, -GRID_SCALE)), TWEEN_FACTOR)
