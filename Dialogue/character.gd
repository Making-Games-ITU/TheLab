extends Node3D
class_name  Character

@export var dialogue_acts: Array[DialogueAct] = []
@export var audioPlayer : AudioStreamPlayer3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func start_dialogue(sentence_id: String) -> void:
	var current_sentence = get_sentence_from_act(sentence_id)
	
	if(current_sentence.next_sentence_id != ""):
		current_sentence.on_finished = func(): start_dialogue(current_sentence.next_sentence_id)
	
	%Dialogue.next_sentence(current_sentence, self)

func get_sentence_from_act(sentence_id: String) -> Sentence:
	for act in dialogue_acts:
		if(act.get_sentence(sentence_id) != null):
			return act.get_sentence(sentence_id)
	return null
