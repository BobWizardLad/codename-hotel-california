extends AudioStreamPlayer

@onready var euh := load("res://assets/audio/euh.ogg")
@onready var aow := load("res://assets/audio/aow.ogg")

func on_wall_collide():
	stream = euh
	play()

func on_attack_fx():
	stream = aow
	play()
