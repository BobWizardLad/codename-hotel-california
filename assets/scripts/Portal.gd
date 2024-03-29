extends Area3D

@export var destination: Vector3i
@export var is_active: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Portals")

func warp(interactor: Node3D):
	interactor.position = destination
