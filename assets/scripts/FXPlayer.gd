extends AudioStreamPlayer

@onready var death := load("res://assets/audio/death.ogg")
@onready var enmy_atk := load("res://assets/audio/powaah.ogg")

func on_death_fx():
	stream = death
	play()

func on_enemy_attack_fx():
	stream = enmy_atk
	play()
