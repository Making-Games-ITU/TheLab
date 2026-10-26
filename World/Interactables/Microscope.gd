extends Interactable

var _is_sample_placed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super() # Replace with function body.

func focus() -> void:
	_update_prompt()

func _update_prompt() -> void:
	_set_outline(true)
	if %Micrograph.visible:
		InteractionPrompt.instance.hide_prompt()
		return
	if PlayerStats.has_new_vial or PlayerStats.has_sample:
		prompt_text = "Place sample"
	elif _is_sample_placed:
		prompt_text = "Analyze sample"
	else:
		prompt_text = "No sample to be analyzed"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if %Micrograph.visible:
		%Micrograph.visible = false
		PlayerStats.is_analyzing = false
		%Microscope_Vial.visible = false
		PlayerStats.has_sample = true
	elif PlayerStats.has_new_vial or PlayerStats.has_sample:
		_is_sample_placed = true
		PlayerStats.has_new_vial = false
		PlayerStats.has_sample = false
		%Microscope_Vial.visible = true
		print("Sample placed")
	elif _is_sample_placed:
		%Micrograph.visible = true
		PlayerStats.is_analyzing = true
		print("Analyzing")
	else:
		return # play weird sound here
	_update_prompt()
