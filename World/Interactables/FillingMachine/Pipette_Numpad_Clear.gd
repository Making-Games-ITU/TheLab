extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.pipette_chemical_amount == "":
		prompt_text = "No number set"
	else:
		prompt_text = "Clear number"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.pipette_chemical_amount == "":
		_uninteractable()
	else:
		_clear_chemical_amount()

func _clear_chemical_amount() -> void:
	GameStats.pipette_chemical_amount = ""
	AudioManager.one_shot(sound_emitter)
	print("Number cleared in pipette")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No number to clear in pipette")
