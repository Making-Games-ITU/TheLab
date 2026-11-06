extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D
@onready var _pipette_chemical_amount_label: Label = %Pipette_Chemical_Amount_Label
var _prompt_text_original: String
@export var press_anim : ButtonPressAnimation 

func _ready() -> void:
	super()
	_prompt_text_original = prompt_text

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	if GameStats.pipette_point_added:
		prompt_text = "Point already added"
	else:
		if GameStats.pipette_chemical_amount.length() < GameStats.PIPETTE_CHARACTERS_MAX:
			prompt_text = _prompt_text_original
		else:
			prompt_text = "Number too long"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	press_anim.press()
	if GameStats.pipette_point_added:
		_uninteractable()
	else:
		if GameStats.pipette_chemical_amount.length() < GameStats.PIPETTE_CHARACTERS_MAX-1:
			_add_point_to_pipette()
		else:
			_uninteractable()

func _add_point_to_pipette() -> void:
	if GameStats.pipette_chemical_amount == "":
		GameStats.pipette_chemical_amount += "0."
	else:
		GameStats.pipette_chemical_amount += "."
	_pipette_chemical_amount_label.text = GameStats.pipette_chemical_amount
	GameStats.pipette_point_added = true
	AudioManager.one_shot(sound_emitter)
	print("Added point. Current number: ", GameStats.pipette_chemical_amount)

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Number in pipette is too long / Point already added / First number can't be 0")
