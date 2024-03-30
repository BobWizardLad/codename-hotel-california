# Camera Controls
extends Node3D

# Children
@onready var CAMERA := $PlayerCameraView
@onready var CAST_FORWARD := $CastForward
@onready var CAST_LEFT := $CastLeft
@onready var CAST_RIGHT := $CastRight
@onready var CAST_BACKWARDS := $CastBackwards
@onready var COMBAT_COMPONENT := $CombatComponent

# Constant Scalar Values
@export var GRID_SCALE = 2 # Factor for movement; constrains grid
@export var ROTATE_SCALE = PI/2 # Factor for rotation; constrains grid
@export var TWEEN_FACTOR = 0.3 # Affects camera interpolation speed

# Signals
signal turn_end
signal popup_interact
signal popup_close

var fighter_is_active: bool = false
var mage_is_active: bool = false
var rouge_is_active: bool = false
var paladin_is_active: bool = false
var fighter_has_attacked: bool = false
var rouge_has_attacked: bool = false
var mage_has_attacked: bool = false
var paladin_has_attacked: bool = false

var is_on_turn: bool
var has_moved: bool = false
var looking_at_popup: bool = false

# Tweens
var motion_tween

func _ready():
	add_to_group("Player")

func _process(_delta):
	if has_moved or (mage_has_attacked and fighter_has_attacked and rouge_has_attacked and paladin_has_attacked):
		on_turn_end()
	if CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().is_in_group("Portals"):
		emit_signal("popup_interact", "Interact [F] to continue forward...")
		looking_at_popup = true
	elif looking_at_popup == true:
		emit_signal("popup_close")
		looking_at_popup = false

func _input(event):
	if is_on_turn:
		player_move(event)
		if event.is_action_pressed("Interact") and CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().is_in_group("Portals"):
			emit_signal("popup_close")
			CAST_FORWARD.get_collider().warp(self)

func _on_fighter_attack():
	if fighter_has_attacked == false and CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().get_parent().get_parent().name == "UnitController":
		COMBAT_COMPONENT.fighter_attack(CAST_FORWARD.get_collider().get_parent().find_child("CombatComponent"))
		fighter_has_attacked = true

func _on_rouge_attack():
	if rouge_has_attacked == false and CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().get_parent().get_parent().name == "UnitController":
		COMBAT_COMPONENT.rouge_attack(CAST_FORWARD.get_collider().get_parent().find_child("CombatComponent"))
		rouge_has_attacked = true

func _on_mage_attack():
	if mage_has_attacked == false and CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().get_parent().get_parent().name == "UnitController":
		COMBAT_COMPONENT.mage_attack(CAST_FORWARD.get_collider().get_parent().find_child("CombatComponent"))
		mage_has_attacked = true

func _on_paladin_attack():
	if paladin_has_attacked == false and CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().get_parent().get_parent().name == "UnitController":
		COMBAT_COMPONENT.paladin_attack(CAST_FORWARD.get_collider().get_parent().find_child("CombatComponent"))
		paladin_has_attacked = true

func _on_fighter_focus_attack():
	if CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().get_parent().get_parent().name == "UnitController":
		COMBAT_COMPONENT.fighter_focus_attack(CAST_FORWARD.get_collider().get_parent().find_child("CombatComponent"))
		fighter_has_attacked = true

func _on_rouge_focus_attack():
	if rouge_has_attacked == false and CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().get_parent().get_parent().name == "UnitController":
		COMBAT_COMPONENT.rouge_focus_attack(CAST_FORWARD.get_collider().get_parent().find_child("CombatComponent"))
		rouge_has_attacked = true

func _on_mage_focus_attack():
	if mage_has_attacked == false and CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().get_parent().get_parent().name == "UnitController":
		COMBAT_COMPONENT.mage_focus_attack(CAST_FORWARD.get_collider().get_parent().find_child("CombatComponent"))
		mage_has_attacked = true

func _on_paladin_focus_attack():
	if paladin_has_attacked == false and CAST_FORWARD.is_colliding() and CAST_FORWARD.get_collider().get_parent().get_parent().name == "UnitController":
		COMBAT_COMPONENT.paladin_focus_attack(CAST_FORWARD.get_collider().get_parent().find_child("CombatComponent"))
		paladin_has_attacked = true

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
	elif event.is_action_pressed("Move_Left") and not CAST_LEFT.is_colliding():
		motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		motion_tween.tween_property(self, "transform", transform.translated(CAMERA.get_global_transform().basis.x * -1 * GRID_SCALE), TWEEN_FACTOR)
		await motion_tween.finished
		has_moved = true
	elif event.is_action_pressed("Move_Right") and not CAST_RIGHT.is_colliding():
		motion_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		motion_tween.tween_property(self, "transform", transform.translated(CAMERA.get_global_transform().basis.x * 1 * GRID_SCALE), TWEEN_FACTOR)
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
	fighter_has_attacked = false
	rouge_has_attacked = false
	mage_has_attacked = false
	paladin_has_attacked = false
	has_moved = false
	emit_signal("turn_end")
