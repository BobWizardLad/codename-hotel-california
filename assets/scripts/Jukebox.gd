extends AudioStreamPlayer

@onready var Djam_2024: AudioStream = load("res://assets/audio/Dungeon_depths_and_treasures_untold.mp3")
@onready var thriller_ambient: AudioStream = load("res://assets/audio/thriller-ambient-14563.mp3")
@onready var wandering: AudioStream = load("res://assets/audio/wandering-6394.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	stream = wandering
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_3d_area_entered(area):
	stream = thriller_ambient
	play()

func _play_end_credits():
	stream = Djam_2024
	play()
