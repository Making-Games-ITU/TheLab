extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	_toggle_interaction() 

func _process(delta: float) -> void:
	_toggle_interaction()

func _toggle_interaction():
	if GameStats.vial_in_collector and not VialStats.empty:
		area.set_collision_layer_value(9, true)
	else:
		area.set_collision_layer_value(9, false)

func interact(interactor: Node) -> void:
	_inject()
	
func _inject() -> void:
	if anim:
		anim.play("inject")
	VialStats.empty_vial()
	print(VialStats.infection)
