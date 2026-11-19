extends Machine

@export var chest_print_0_paper: MeshInstance3D
@export var chest_print_1_paper: MeshInstance3D
@export var chest_print_2_paper: MeshInstance3D
@export var chest_print_3_paper: MeshInstance3D
@export var chest_print_4_paper: MeshInstance3D
@export var chest_print_interact_area: CollisionShape3D
@export var pinboard_print_interact_area: CollisionShape3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	prompt_text = "Take print"
	InteractionPrompt.instance.show_prompt(prompt_text)

func _on_interact(interactor: Node) -> void:
	_get_scan_paper()

func _hide_all_prints() -> void:
	chest_print_0_paper.visible = false
	chest_print_1_paper.visible = false
	chest_print_2_paper.visible = false
	chest_print_3_paper.visible = false
	chest_print_4_paper.visible = false

func _get_scan_paper() -> void:
	chest_print_interact_area.disabled = true
	pinboard_print_interact_area.disabled = false
	PlayerStats.is_holding = PlayerStats.HoldState.PRINT
	_hide_all_prints()
	match GameStats.body_state:
		1: %Player_Scanner_Chest_0.visible = true
		2: %Player_Scanner_Chest_1.visible = true
		3: %Player_Scanner_Chest_2.visible = true
		4: %Player_Scanner_Chest_3.visible = true
		5: %Player_Scanner_Chest_4.visible = true
	AudioManager.one_shot(sound_emitter)
	print("Got scan print")

func _uninteractable() -> void:
	super()
	print("Can't take scan print")
