extends Note_Interactions
@export var character_ref : Character 
@export var collision_shape: CollisionShape3D
var already_read : bool = false

func _ready() -> void:
	super()
	hide()
	collision_shape.set_deferred("disabled", true)
	var request_reading_sentence = character_ref.get_sentence_from_act("e43c0813-d836-499a-9d7f-1879744e3400")
	request_reading_sentence.on_finished = func(): 
		show()
		collision_shape.set_deferred("disabled", false)

func focus() -> void:
	super()
	
func _update_prompt() -> void:
	super()

func _start_reading() -> void:
	super()

func _stop_reading() -> void:
	super()
	if already_read : return
	character_ref.start_dialogue("c18da72b-b90b-491d-8be9-84f066fa8570")
	already_read = true
