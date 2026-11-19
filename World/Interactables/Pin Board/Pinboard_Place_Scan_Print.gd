extends Machine

@export var pinboard_print_interact_area: CollisionShape3D
@export var pinboard_chest_scan_0: MeshInstance3D
@export var pinboard_chest_scan_1: MeshInstance3D
@export var pinboard_chest_scan_2: MeshInstance3D
@export var pinboard_chest_scan_3: MeshInstance3D
@export var pinboard_chest_scan_4: MeshInstance3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	prompt_text = "Place print"
	InteractionPrompt.instance.show_prompt(prompt_text)

func _on_interact(_interactor: Node) -> void:
	_place_scan_print()

func _hide_player_prints() -> void:
	%Player_Scanner_Chest_0.visible = false
	%Player_Scanner_Chest_1.visible = false
	%Player_Scanner_Chest_2.visible = false
	%Player_Scanner_Chest_3.visible = false
	%Player_Scanner_Chest_4.visible = false

func _place_print_on_pinboard() -> void:
	match GameStats.body_state:
		1: pinboard_chest_scan_0.visible = true
		2: pinboard_chest_scan_1.visible = true
		3: pinboard_chest_scan_2.visible = true
		4: pinboard_chest_scan_3.visible = true
		5: pinboard_chest_scan_4.visible = true

func _place_scan_print() -> void:
	_hide_player_prints()
	pinboard_print_interact_area.disabled = true
	PlayerStats.is_holding = PlayerStats.HoldState.NONE
	_place_print_on_pinboard()
	AudioManager.one_shot(sound_emitter)
	print("Got scan print")

func _uninteractable() -> void:
	super()
	print("Can't take scan print")
