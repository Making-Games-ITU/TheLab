extends Interactable

@onready var _centrifuge_state_label: Label = %Centrifuge_State_Label
@export var press_anim : ButtonPressAnimation 

signal centrifuge_start_pressed

func _ready() -> void:
	super()
	
func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if GameStats.vial_in_centrifuge:
		if VialStats.empty:
			prompt_text = "Vial is empty"
		else:
			prompt_text = "Start centrifuge"
	else:
		prompt_text = "No vial in centrifuge"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	press_anim.press()
	if GameStats.vial_in_centrifuge:
		if VialStats.empty:
			_uninteractable()
		else:
			_start_centrifuge()
	else:
		_uninteractable()

func _start_centrifuge():
	press_anim.press()
	if anim and anim.animation_finished:
		anim.play("Start Mixer")
		await anim.animation_finished
		_centrifuge_state_label.text = "Mixing"
		AudioManager.one_shot(sound_emitter)
		anim.play("Mixing")
		await get_tree().create_timer(5).timeout
		anim.play("Stop Mixer")
		VialStats.centrifuge(GameStats.centrifuge_current_speed)
		centrifuge_start_pressed.emit() # For the micrograph, should rename
		_centrifuge_state_label.text = "Done"
		_update_prompt()
		print("Centrifuged")


func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
	print("No vial in centrifuge or vial is empty")
