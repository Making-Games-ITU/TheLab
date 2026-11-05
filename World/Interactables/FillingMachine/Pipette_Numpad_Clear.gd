extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D
@onready var _pipette_chemical_amount_label: Label = %Pipette_Chemical_Amount_Label

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
	_pipette_chemical_amount_label.text = "0.0 ml"
	GameStats.pipette_point_added = false
	AudioManager.one_shot(sound_emitter)
	print("Number cleared in pipette")

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No number to clear in pipette")
