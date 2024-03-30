extends AnimatedSprite2D

# Import attack animations
var basic_attack_animations: Array = []
var enemy_attack: SpriteFrames
var rouge_focus: SpriteFrames
var mage_focus: SpriteFrames
var paladin_focus: SpriteFrames

# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_viewport_rect().get_center()
	position.y -= 50
	
	hide()
	
	basic_attack_animations.append(load("res://assets/sprite_frames/slash_01.tres"))
	basic_attack_animations.append(load("res://assets/sprite_frames/slash_02.tres"))
	basic_attack_animations.append(load("res://assets/sprite_frames/slash_03.tres"))
	enemy_attack = load("res://assets/sprite_frames/eye_atk.tres")
	rouge_focus = load("res://assets/sprite_frames/attack_goo.tres")
	mage_focus = load("res://assets/sprite_frames/psi_attack.tres")
	paladin_focus = load("res://assets/sprite_frames/attack_boom.tres")
	pass

func _on_attack_anim():
	sprite_frames = basic_attack_animations.pick_random()
	show()
	play()
	await animation_finished
	hide()

func _on_rouge_focus_anim():
	sprite_frames = rouge_focus
	show()
	play()
	await animation_finished
	hide()

func _on_mage_focus_anim():
	sprite_frames = mage_focus
	show()
	play()
	await animation_finished
	hide()

func _on_paladin_focus_anim():
	sprite_frames = paladin_focus
	show()
	play()
	await animation_finished
	hide()

func _on_enemy_attack_anim():
	await animation_finished
	sprite_frames = enemy_attack
	show()
	play()
	await animation_finished
	hide()
