extends Control
class_name Dialogue_Manager

@export var talk_sound: FmodEventEmitter3D
@export var talk_sound: FmodEventEmitter3D
@export var dialogue_text_box : RichTextLabel
var current_audioPlayer : AudioStreamPlayer3D
var current_sentece : Sentence

var test : bool = true
var dialogue_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if current_sentece == null:
		return
	

	if(test == true) :
		dialogue_time += delta
	else :
		dialogue_time = maxf(dialogue_time, current_audioPlayer.get_playback_position())
	
	var time := dialogue_time
	var visables := 0
	var phrases := current_sentece.phrases
	
	for phrase in phrases:
		if(time < phrase["start"]):
			break
		
		var phrase_text: String = phrase["text"]
		var progress := clampf(inverse_lerp(phrase["start"], phrase["end"], time), 0.0, 1.0)
		visables += floori(phrase_text.length() * progress)
		
	dialogue_text_box.visible_characters = maxi(dialogue_text_box.visible_characters, visables)
	if dialogue_text_box.text[dialogue_text_box.visible_characters-1]!=" ":
		talk_sound.play()
	if dialogue_text_box.visible_characters >= dialogue_text_box.get_total_character_count():
		_on_finished_dialogue()

func next_sentence(next_sentence : Sentence, next_character : Character):
	dialogue_text_box.text = ""
	
	for phrase in next_sentence.phrases:
		dialogue_text_box.text += phrase["text"]
		
	current_audioPlayer = next_character.audioPlayer
	dialogue_text_box.visible_characters = 0
	
	if(current_audioPlayer != null):
		current_audioPlayer.play()
		current_audioPlayer.stream = next_sentence.voice_over
	current_sentece = next_sentence
	show()

func _on_finished_dialogue():
	var callback: Callable = current_sentece.on_finished
	current_sentece = null
	current_audioPlayer = null
	dialogue_time = 0
	await get_tree().create_timer(2).timeout
	
	if(current_sentece == null):
		hide()
	
	if(callback.is_valid()):
		callback.call()
