extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super() # Replace with function body.


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
	
