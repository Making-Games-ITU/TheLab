class_name IButton 
extends Interactable

func _ready() -> void:
	super()

func interact(interactor: Node) -> void:
	_press_button()

func _press_button() -> void:
	if anim:
		anim.play("press")
