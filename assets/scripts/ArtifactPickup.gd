extends Node3D

@export var identity: String
@export var graphic: Texture

@onready var SPRITE: Sprite3D = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	SPRITE.texture = graphic
	add_to_group("Artifacts")

