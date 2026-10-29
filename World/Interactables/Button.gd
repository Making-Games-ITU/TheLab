class_name IButton 
extends Interactable

func interact(interactor: Node) -> void:
	_press_button()

func _press_button() -> void:
	if anim:
		anim.play("press")
