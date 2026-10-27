extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	_toggle_interaction() 

func _process(delta: float) -> void:
	_toggle_interaction()

func _toggle_interaction():
	if GameStats.toggle_sample_collector:
		area.set_collision_layer_value(9, true)
	else:
		area.set_collision_layer_value(9, false)

func interact(interactor: Node) -> void:
	_extractBlood()
	
func _extractBlood() -> void:
	if anim:
		anim.play("extract")
	VialStats.infection = 1
	print(VialStats.infection)
