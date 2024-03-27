extends Node3D

signal turn_end

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if get_child(0) != null:
			get_child(0).move_step(Vector3(0,0,0))
			emit_signal("turn_end")
