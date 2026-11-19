extends Machine

@export var chest_print_0_paper: MeshInstance3D
@export var chest_print_1_paper: MeshInstance3D
@export var chest_print_2_paper: MeshInstance3D
@export var chest_print_3_paper: MeshInstance3D
@export var chest_print_4_paper: MeshInstance3D
@export var chest_print_interact_area: CollisionShape3D 

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.has_scanned:
		if GameStats.is_scanning:
			prompt_text = "Scanning in progress"
		else:
			prompt_text = "Request Scan Paper"
	else:
		prompt_text = "Body not scanned"
	InteractionPrompt.instance.show_prompt(prompt_text)

func _on_interact(_interactor: Node) -> void:
	if GameStats.has_scanned:
		if GameStats.is_scanning:
			_uninteractable()
		else:
			_get_scan_paper()
	else:
		_uninteractable()

func _hide_all_prints() -> void:
	chest_print_0_paper.visible = false
	chest_print_1_paper.visible = false
	chest_print_2_paper.visible = false
	chest_print_3_paper.visible = false
	chest_print_4_paper.visible = false

func _get_scan_paper() -> void:
	_hide_all_prints()
	match GameStats.body_state:
		1: chest_print_0_paper.visible = true
		2: chest_print_1_paper.visible = true
		3: chest_print_2_paper.visible = true
		4: chest_print_3_paper.visible = true
		5: chest_print_4_paper.visible = true
	chest_print_interact_area.disabled = false
	AudioManager.one_shot(sound_emitter)
	print("Got scan paper")

func _uninteractable() -> void:
	super()
	print("Scanning in progress or body not scanned")
