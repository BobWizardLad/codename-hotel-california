extends Control

# External Nodes
@onready var PLAYER: Node = get_node("../Player")

# Signals
signal fighter_attack
signal fighter_focus_attack
signal rouge_attack
signal rouge_focus_attack
signal mage_attack
signal mage_focus_attack
signal paladin_attack
signal paladin_focus_attack

signal open_options
signal open_help
signal open_inventory
signal all_attack
signal skip_turn

# Child Nodes
@onready var POPUP_DIALOG: Label = $PopupDialog
@onready var HEALTH: TextureProgressBar = $BottomPanel/Health
@onready var FOCUS_FIGHTER: TextureProgressBar = $PartyLeft/FighterFocus
@onready var FOCUS_ROUGE: TextureProgressBar = $PartyLeft/RougeFocus
@onready var FOCUS_MAGE: TextureProgressBar = $PartyRight/MageFocus
@onready var FOCUS_PALADIN: TextureProgressBar = $PartyRight/PaladinFocus

@onready var FIGHTER_ATTACK: TextureButton = $PartyLeft/FighterControl/Attack
@onready var ROUGE_ATTACK: TextureButton = $PartyLeft/RougeControl/Attack
@onready var MAGE_ATTACK: TextureButton = $PartyRight/MageControl/Attack
#@onready var PALADIN_ATTACK: TextureButtonb = $

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
