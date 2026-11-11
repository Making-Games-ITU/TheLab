extends Interactable

@onready var _pipette_chemical_amount_label: Label = %Pipette_Chemical_Amount_Label
@export var press_anim : ButtonPressAnimation 

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func vial_in() -> bool:
	if GameStats.vial_location == GameStats.VialLocation.PIPETTE:
		return true
	else:
		return false

func _update_prompt() -> void:
	if vial_in():
		if GameStats.flask_in_pipette:
			if GameStats.pipette_chemical_amount_string_to_float() > 0.0:
				prompt_text = "Start"
			else:
				prompt_text = "Insufficient amount"
		else:
			prompt_text = "No flask in flask slot"
	else:
		prompt_text = "No vial in vial slot"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	press_anim.press()
	if vial_in() and GameStats.flask_in_pipette and GameStats.pipette_chemical_amount_string_to_float() > 0.0:
		_start_pipette()
	else:
		_uninteractable()

func _start_pipette() -> void:
	var _chemical_amount: float = GameStats.pipette_chemical_amount_string_to_float()
	var _chemical = GameStats.pipette_current_chemical
	VialStats.add_chemical(_chemical, _chemical_amount)
	GameStats.pipette_chemical_amount = ""
	GameStats.pipette_point_added = false
	_pipette_chemical_amount_label.text = "0.0 ml"
	AudioManager.one_shot(sound_emitter)
	_update_prompt()
	print("Adding chemical")

func _uninteractable() -> void:
	print("Not all components in pipette or insufficient amount")
