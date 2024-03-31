extends AudioStreamPlayer

@onready var collect := load("res://assets/audio/woloo.ogg")

func on_collect():
	stream = collect
	play()
