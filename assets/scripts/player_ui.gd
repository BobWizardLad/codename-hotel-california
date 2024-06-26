extends Control

# External Nodes
@onready var PLAYER: Node = get_node("../Player")

# Child Nodes
@onready var POPUP_DIALOG: Label = $PopupDialog
@onready var RESTORE_OVERLAY: ColorRect = $RestoreOverlay
@onready var HEALTH: TextureProgressBar = $BottomPanel/Health
@onready var FOCUS_FIGHTER: TextureProgressBar = $PartyLeft/FighterFocus
@onready var FOCUS_ROUGE: TextureProgressBar = $PartyLeft/RougeFocus
@onready var FOCUS_MAGE: TextureProgressBar = $PartyRight/MageFocus
@onready var FOCUS_PALADIN: TextureProgressBar = $PartyRight/PaladinFocus
@onready var HELP_OVERLAY: TextureRect = $HelpOverlay
@onready var TOKEN_DISPLAY: HBoxContainer = $TokenDisplay
@onready var TOKEN_COUNT: Label = $TokenDisplay/Count
@onready var TIMER := $Timer

@onready var FIGHTER_ARTIFACT: TextureRect = $BottomPanel/FighterArtifact/Artifact
@onready var ROUGE_ARTIFACT: TextureRect = $BottomPanel/RougeArtifact/Artifact
@onready var PALADIN_ARTIFACT: TextureRect = $BottomPanel/PaladinArtifact/Artifact
@onready var MAGE_ARTIFACT: TextureRect = $BottomPanel/MageArtifact/Artifact

@onready var PORTRAIT := $BottomPanel/Portrait
@onready var FIGHTER_STATE: TextureRect = $PartyLeft/Fighter
@onready var ROUGE_STATE: TextureRect = $PartyLeft/Rouge
@onready var MAGE_STATE: TextureRect = $PartyRight/Mage
@onready var PALADIN_STATE: TextureRect = $PartyRight/Paladin

var color_tween: Tween
var color_tween_factor: float = 0.6

var inactive_modulate: Color = Color(0.4, 0.4, 0.4, 1.0)
var normal_modulate: Color = Color(1.0, 1.0, 1.0, 1.0)

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
func _process(_delta):
	HEALTH.value = PLAYER.find_child("CombatComponent").health
	FOCUS_FIGHTER.value = PLAYER.find_child("CombatComponent").fighter_focus
	FOCUS_ROUGE.value = PLAYER.find_child("CombatComponent").rouge_focus
	FOCUS_MAGE.value = PLAYER.find_child("CombatComponent").mage_focus
	FOCUS_PALADIN.value = PLAYER.find_child("CombatComponent").paladin_focus
	TOKEN_COUNT.text = String.num_int64(PLAYER.tokens)
	
	if PLAYER.fighter_has_attacked:
		FIGHTER_STATE.modulate = inactive_modulate
	else:
		FIGHTER_STATE.modulate = normal_modulate
	if PLAYER.rouge_has_attacked:
		ROUGE_STATE.modulate = inactive_modulate
	else:
		ROUGE_STATE.modulate = normal_modulate
	if PLAYER.paladin_has_attacked:
		PALADIN_STATE.modulate = inactive_modulate
	else:
		PALADIN_STATE.modulate = normal_modulate
	if PLAYER.mage_has_attacked:
		MAGE_STATE.modulate = inactive_modulate
	else:
		MAGE_STATE.modulate = normal_modulate
	
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

func portrait_animation():
	var attempt = randi_range(0, 100)
	if attempt < 20:
		PORTRAIT.texture.region = Rect2(144, 64, 32, 32)
	if attempt > 80:
		PORTRAIT.texture.region = Rect2(112, 64, 32, 32)
	else:
		PORTRAIT.texture.region = Rect2(112, 96, 32, 32)


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

func _on_player_restore_focus():
	color_tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	color_tween.tween_property(RESTORE_OVERLAY, "color", Color(0.0, 0.0, 1.0, 0.7), color_tween_factor)
	RESTORE_OVERLAY.show()
	await color_tween.finished
	RESTORE_OVERLAY.hide()
	RESTORE_OVERLAY.color = Color(1.0, 1.0, 1.0, 0.0)

func _on_player_restore_health():
	color_tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	color_tween.tween_property(RESTORE_OVERLAY, "color", Color(0.0, 1.0, 0.0, 0.7), color_tween_factor)
	RESTORE_OVERLAY.show()
	await color_tween.finished
	RESTORE_OVERLAY.hide()
	RESTORE_OVERLAY.color = Color(1.0, 1.0, 1.0, 0.0)

func _on_skip_turn_pressed():
	_on_player_popup_interact("Turn Skipped...")
	await get_tree().create_timer(1.0).timeout
	_on_player_popup_close()

func _on_inventory_pressed():
	if TOKEN_DISPLAY.visible:
		TOKEN_DISPLAY.hide()
	else:
		TOKEN_DISPLAY.show()
