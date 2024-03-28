# Generic Control Node that will get the current viewport width, and overlay a
# black color rect node with label text for duaration, configurable via 
# parameters passed into the function/signal to function
extends Control

@onready var COLOR_RECT: ColorRect = $ColorRect
@onready var LABEL: Label = $Label
@onready var TIMER: Timer = $Timer

@export var COLOR_LERP_FACTOR = 0.3
var lerp_progression = false

func _ready():
	hide()

func _process(_delta):
	# Resize myself to cover the display
	position = get_viewport_rect().position
	size = get_viewport_rect().size

# Prompt Text Overlay will be called by signals in the program and
# will mediate text overlays. This function makes it's node visible
# for duration seconds and changes the Label text to display message.
func _prompt_text_overlay(message: String, duration: int):
	# Corrent the display and show for time
	LABEL.text = message
	show()
	TIMER.wait_time = duration
	TIMER.start()
	await TIMER.timeout
	hide()
