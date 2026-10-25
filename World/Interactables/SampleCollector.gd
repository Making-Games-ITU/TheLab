extends Interactable

var _vial_inserted : bool = false
var _sample_ready : bool = false

@export var _sample_collector : Area3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	_toggle_interaction() 

func _process(delta: float) -> void:
	_toggle_interaction()

func _toggle_interaction():
	if GameStats.toggle_sample_collector:
		_sample_collector.set_collision_layer_value(9, true)
	else:
		if anim:
			anim.play("close")
		_sample_collector.set_collision_layer_value(9, false)

func interact(interactor: Node) -> void:
	if _vial_inserted:
		if anim:
			anim.play("remove")
		_take_vial()
	else:
		if anim:
			anim.play("insert")
		_insert_vial()	

func _insert_vial():
	if PlayerStats.has_new_vial: 
		PlayerStats.has_new_vial = false
		_vial_inserted = true
		print("Vial inserted")
		prompt_text = "Take vial"
		_refresh_prompt()
	else:
		print("No Vial in inventory.")

func _take_vial():
	#PlayerStats.has_sample = true
	_vial_inserted = false
	print("Picked up Vial: ", PlayerStats.has_sample)
	
	prompt_text = "Insert Vial"
	_refresh_prompt()
