extends Interactable

var is_open := false # only used by doors

func _ready() -> void:
	super()

func interact(interactor: Node) -> void:
	_toggle_door()
	
func _toggle_door() -> void:
	is_open = not is_open
	prompt_text = "Close" if is_open else "Open"
	if anim:
		if is_open:
			anim.play("Cube_Bounce")
		else:
			anim.play_backwards("Cube_Bounce")
