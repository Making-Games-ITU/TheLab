extends Interactable

var _vial_inserted : bool = false
var _sample_ready : bool = false
@onready var _sample_collector = $Area3D2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super() 

func _process(delta: float) -> void:
	_check4body()
	
func interact(interactor: Node) -> void:
	if _vial_inserted:
		if anim:
			anim.play("remove")
		_take_vial()
	else:
		if anim:
			anim.play("insert")
		_insert_vial()	

func _check4body():
	if GameStats.body_exists:
		_sample_collector.set_collision_layer_value(9, true)
	else:
		_sample_collector.set_collision_layer_value(9, false)


func _insert_vial():
	if PlayerStats.has_new_vial: 
		_vial_inserted = true
		print("Vial inserted")
		prompt_text = "Take sample"
		_refresh_prompt()
	else:
		print("No Vial in inventory. Take a new vial")

func _take_vial():
	PlayerStats.has_sample = true
	PlayerStats.has_new_vial = false
	_vial_inserted = false
	print("Sample collected: ", PlayerStats.has_sample)
	
	prompt_text = "Insert empty Vial"
	_refresh_prompt()
