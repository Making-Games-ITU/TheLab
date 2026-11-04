extends Interactable

@export var uninteractable_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()

func _update_prompt() -> void:
	prompt_text = "Number too long"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if GameStats.chem_in_pip and GameStats.vial_in_pip:
		_start_pipette()
	else:
		_uninteractable()

func _start_pipette() -> void:
	var chemical_amount = GameStats.pipette_chemical_amount_string_to_float()
	var chemical = GameStats.current_chemical
	VialStats.add_chemical(chemical, chemical_amount)
	print("Adding ", chemical_amount, " of ", chemical, ". Current amount: ", VialStats.get_quantity(chemical))
	print("Integrated? ", VialStats.is_integrated(chemical))

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("Not all components in pipette")
