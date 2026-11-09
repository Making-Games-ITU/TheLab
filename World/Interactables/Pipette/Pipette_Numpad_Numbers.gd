extends Interactable

@onready var _pipette_chemical_amount_label: Label = %Pipette_Chemical_Amount_Label
@export var press_anim : ButtonPressAnimation 
var _prompt_text_original: String

func _ready() -> void:
	super()
	_prompt_text_original = prompt_text

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.pipette_chemical_amount.length() < GameStats.PIPETTE_CHARACTERS_MAX:
		prompt_text = _prompt_text_original
	else:
		prompt_text = "Number too long"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	press_anim.press()
	if GameStats.pipette_chemical_amount.length() < GameStats.PIPETTE_CHARACTERS_MAX:
		_add_number_to_pipette()
	else:
		_uninteractable()

func _add_number_to_pipette() -> void:
	GameStats.pipette_chemical_amount += _prompt_text_original
	_pipette_chemical_amount_label.text = GameStats.pipette_chemical_amount + " ml"
	AudioManager.one_shot(sound_emitter)
	print("Added number. Current number: ", GameStats.pipette_chemical_amount)

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Number in pipette is too long")
