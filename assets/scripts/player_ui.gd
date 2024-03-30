extends Control

# External Nodes
@onready var PLAYER: Node = get_node("../Player")

# Child Nodes
@onready var POPUP_DIALOG: Label = $PopupDialog
#@onready var 

# Called when the node enters the scene tree for the first time.
func _ready():
	POPUP_DIALOG.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_popup_interact(msg: String):
	POPUP_DIALOG.text = msg
	POPUP_DIALOG.show()

func _on_player_popup_close():
	POPUP_DIALOG.text = ""
	POPUP_DIALOG.hide()
