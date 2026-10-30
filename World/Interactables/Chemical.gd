extends Interactable


@export var chemName : String
@export var composite : VialStats.Composite
@export var bottle : Node

func _ready() -> void:
	prompt_text = "Take " + chemName
	_refresh_prompt()
	super()

func interact(interactor: Node) -> void:
	if PlayerStats.has_chemical:
		GameStats.current_chemical = VialStats.Composite.None
		PlayerStats.has_chemical = false
		bottle.visible = true
		print(GameStats.current_chemical)
		
		prompt_text = "Take " + chemName
		_refresh_prompt()
	else:
		bottle.visible = false
		PlayerStats.has_chemical = true
		GameStats.current_chemical = composite
		print(GameStats.current_chemical)
		
		prompt_text = "Place " + chemName
		_refresh_prompt()
	
