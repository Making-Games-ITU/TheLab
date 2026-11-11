extends Node3D
class_name  Character

@export var dialogue_acts: Array[DialogueAct] = []

@export var audioPlayer : AudioStreamPlayer3D

@export var current_act : int = 0
@export var current_scene : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_dialogue(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_dialogue(act: int) -> void:
	if act < 0 or act >= dialogue_acts.size():
		return

	var dialogue_act := dialogue_acts[act]
	if dialogue_act == null:
		return
	if current_scene < 0 or current_scene >= dialogue_act.sentences.size():
		return

	var sentence := dialogue_act.sentences[current_scene]
	if sentence == null:
		return

	current_act = act
	%Dialogue.next_sentence(sentence, self)
