extends Control

@onready var popup_dialog: Label = $PopupDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	popup_dialog.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_popup_interact(msg: String):
	popup_dialog.text = msg
	popup_dialog.show()

func _on_player_popup_close():
	popup_dialog.text = ""
	popup_dialog.hide()
