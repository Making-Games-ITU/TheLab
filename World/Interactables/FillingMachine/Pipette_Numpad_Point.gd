extends Interactable

@export var number: String
@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.pipette_chemical_amount.length() < GameStats.PIPETTE_CHARACTERS_MAX:
		prompt_text = number
	else:
		prompt_text = "Number too long"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.pipette_chemical_amount.length() < GameStats.PIPETTE_CHARACTERS_MAX-1:
		_add_point_to_pipette()
	else:
		_uninteractable()

func _add_point_to_pipette() -> void:
	if GameStats.amount == "":
		GameStats.amount += "0."
	else:
		GameStats.amount += "."
	print("Added point. Current number: ", GameStats.pipette_chemical_amount)

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Number in pipette is too long / First number can't be 0")
