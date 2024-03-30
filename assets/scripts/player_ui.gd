extends Control

# External Nodes
@onready var PLAYER: Node = get_node("../Player")

# Child Nodes
@onready var POPUP_DIALOG: Label = $PopupDialog
@onready var HEALTH: TextureProgressBar = $BottomPanel/Health
@onready var FOCUS_FIGHTER: TextureProgressBar = $PartyLeft/FighterFocus
@onready var FOCUS_ROUGE: TextureProgressBar = $PartyLeft/RougeFocus
@onready var FOCUS_MAGE: TextureProgressBar = $PartyRight/MageFocus
@onready var FOCUS_PALADIN: TextureProgressBar = $PartyRight/PaladinFocus
@onready var HELP_OVERLAY: TextureRect = $HelpOverlay

@onready var FIGHTER_STATE: TextureRect = $PartyLeft/Fighter
@onready var ROUGE_STATE: TextureRect = $PartyLeft/Rouge
@onready var MAGE_STATE: TextureRect = $PartyRight/Mage
@onready var PALADIN_STATE: TextureRect = $PartyRight/Paladin

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

# Called when the node enters the scene tree for the first time.
func _ready():
	POPUP_DIALOG.hide()
	
	FOCUS_FIGHTER.max_value = PLAYER.find_child("CombatComponent").FIGHTER_FOCUS_MAX
	FOCUS_ROUGE.max_value = PLAYER.find_child("CombatComponent").ROUGE_FOCUS_MAX
	FOCUS_MAGE.max_value = PLAYER.find_child("CombatComponent").MAGE_FOCUS_MAX
	FOCUS_PALADIN.max_value = PLAYER.find_child("CombatComponent").PALADIN_FOCUS_MAX

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	HEALTH.value = PLAYER.find_child("CombatComponent").health
	FOCUS_FIGHTER.value = PLAYER.find_child("CombatComponent").fighter_focus
	FOCUS_ROUGE.value = PLAYER.find_child("CombatComponent").rouge_focus
	FOCUS_MAGE.value = PLAYER.find_child("CombatComponent").mage_focus
	FOCUS_PALADIN.value = PLAYER.find_child("CombatComponent").paladin_focus
	
	if PLAYER.fighter_is_active:
		FIGHTER_STATE.texture.region = Rect2(48, 96, 32, 32)
	else:
		FIGHTER_STATE.texture.region = Rect2(112, 128, 32, 32)
	if PLAYER.rouge_is_active:
		ROUGE_STATE.texture.region = Rect2(80, 96, 32, 32)
	else:
		ROUGE_STATE.texture.region = Rect2(112, 128, 32, 32)
	if PLAYER.paladin_is_active:
		PALADIN_STATE.texture.region = Rect2(48, 128, 32, 32)
	else:
		PALADIN_STATE.texture.region = Rect2(112, 128, 32, 32)
	if PLAYER.mage_is_active:
		MAGE_STATE.texture.region = Rect2(80, 128, 32, 32)
	else:
		MAGE_STATE.texture.region = Rect2(112, 128, 32, 32)

func _on_player_popup_interact(msg: String):
	POPUP_DIALOG.text = msg 
	POPUP_DIALOG.show()

func _on_player_popup_close():
	POPUP_DIALOG.text = ""
	POPUP_DIALOG.hide()

func _on_help_pressed():
	if HELP_OVERLAY.visible:
		HELP_OVERLAY.hide()
	else:
		HELP_OVERLAY.show()
