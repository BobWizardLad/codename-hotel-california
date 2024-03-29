# Camera Controls
extends Node3D

# Children
@onready var CAMERA := $PlayerCameraView
@onready var CAST_FORWARD := $CastForward
@onready var CAST_BACKWARDS := $CastBackwards
@onready var COMBAT_COMPONENT := $CombatComponent

# Constant Scalar Values
@export var GRID_SCALE = 2 # Factor for movement; constrains grid
@export var ROTATE_SCALE = PI/2 # Factor for rotation; constrains grid
@export var TWEEN_FACTOR = 0.3 # Affects camera interpolation speed

# Signals
signal turn_end

var is_on_turn: bool
var has_attacked: bool = false
var has_moved: bool = false

# Tweens
var motion_tween

func _ready():
	pass

func _process(_delta):
	if has_moved or has_attacked:
		on_turn_end()

func _unhandled_input(event):
	if is_on_turn:
		player_move(event)
		if event.is_action_pressed("Attack") and CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().get_parent().get_parent().name == "UnitController":
			COMBAT_COMPONENT.attack(CAST_FORWARD.get_collider().get_parent().find_child("CombatComponent"))
			has_attacked = true

func player_move(event):
	if motion_tween is Tween: # Halt another tween if one is running
		if motion_tween.is_running():
			return
	# Tween forwards
	if event.is_action_pressed("Move_Forward") and not CAST_FORWARD.is_colliding():
		motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		motion_tween.tween_property(self, "transform", transform.translated(CAMERA.get_global_transform().basis.z * -1 * GRID_SCALE), TWEEN_FACTOR)
		await motion_tween.finished
		has_moved = true
	# Tween backwards
	elif event.is_action_pressed("Move_Back") and not CAST_BACKWARDS.is_colliding():
		motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		motion_tween.tween_property(self, "transform", transform.translated(CAMERA.get_global_transform().basis.z * 1 * GRID_SCALE), TWEEN_FACTOR)
		await motion_tween.finished
		has_moved = true
	# Tween rotate left
	elif event.is_action_pressed("Rotate_Left"):
		motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		motion_tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, ROTATE_SCALE), TWEEN_FACTOR)
	# Tween rotate right
	elif event.is_action_pressed("Rotate_Right"):
		motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		motion_tween.tween_property(self, "transform:basis", transform.basis.rotated(Vector3.UP, -1 * ROTATE_SCALE), TWEEN_FACTOR)

func _on_player_turn():
	is_on_turn = true

func on_turn_end():
	is_on_turn = false
	has_attacked = false
	has_moved = false
	emit_signal("turn_end")
