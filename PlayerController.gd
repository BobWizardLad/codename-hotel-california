# Camera Controls
extends Node3D

# Children
@onready var CAMERA := $PlayerCameraView
@onready var CAST_FORWARD := $CastForward
@onready var CAST_BACKWARDS := $CastBackwards

# Constant Scalar Values
@export var GRID_SCALE = 2 # Factor for movement; constrains grid
@export var ROTATE_SCALE = PI/2 # Factor for rotation; constrains grid
@export var TWEEN_FACTOR = 0.3 # Affects camera interpolation speed

# Tweens
var motion_tween

func _ready():
	pass

func _process(delta):
	pass

func _unhandled_input(event):
	if motion_tween is Tween: # Halt another tween if one is running
		if motion_tween.is_running():
			return
	# Tween forwards
	if event.is_action_pressed("Move_Forward") and not CAST_FORWARD.is_colliding():
		motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		motion_tween.tween_property(self, "transform", transform.translated(CAMERA.get_global_transform().basis.z * -1 * GRID_SCALE), TWEEN_FACTOR)
	# Tween backwards
	elif event.is_action_pressed("Move_Back") and not CAST_BACKWARDS.is_colliding():
		motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		motion_tween.tween_property(self, "transform", transform.translated(CAMERA.get_global_transform().basis.z * 1 * GRID_SCALE), TWEEN_FACTOR)
	# Tween rotate left
	elif event.is_action_pressed("Rotate_Left"):
		motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		motion_tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, ROTATE_SCALE), TWEEN_FACTOR)
	# Tween rotate right
	elif event.is_action_pressed("Rotate_Right"):
		motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		motion_tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, -1 * ROTATE_SCALE), TWEEN_FACTOR)
		
func player_move(direction: Vector3):
	pass
