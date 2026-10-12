extends Interactable

@export var button: GameStats.Buttons = GameStats.Buttons.NONE

func _ready() -> void:
	super()
	
func interact(interactor: Node) -> void:
	_press_button()

func _press_button() -> void:
	GameStats.interacted_button = button
	if anim:
		anim.play("press")
