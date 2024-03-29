extends Node3D

# Is it the player's turn?
@export var player_turn: bool

signal take_enemy_turn
signal take_player_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	player_turn = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _player_turn_end():
	player_turn = false
	emit_signal("take_enemy_turn")

func _enemy_turn_end():
	player_turn = true
	emit_signal("take_player_turn")
