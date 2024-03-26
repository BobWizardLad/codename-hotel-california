extends Node3D

# Is it the player's turn?
@export var player_turn: bool = true

signal take_enemy_turn
signal take_player_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _player_turn_end():
	player_turn = false
	print("Player Turn Ended!")
	emit_signal("take_enemy_turn")

func _enemy_turn_end():
	player_turn = true
	print("Enemy Turn Ended!")
	emit_signal("take_player_turn")
