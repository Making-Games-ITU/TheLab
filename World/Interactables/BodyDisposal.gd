extends Interactable

func interact(interactor: Node) -> void:
	_dispose_body()

func _dispose_body():
	if anim:
		anim.play("RESET")
	
	if GameStats.body_exists:
		print("Subject disposed.")
		GameStats.body_exists = false
	else:
		print("No body to dispose")
	
