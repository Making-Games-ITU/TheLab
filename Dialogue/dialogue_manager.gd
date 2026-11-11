extends Control
class_name Dialogue_Manager

@export var dialogue_text_box : RichTextLabel
var current_audioPlayer : AudioStreamPlayer3D
var current_sentece : Sentence

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if current_sentece == null:
		return
	
	var time := current_audioPlayer.get_playback_position()
	var visables := 0
	var phrases := current_sentece.phrases
	
	for phrase in phrases:
		if(time < phrase["start"]):
			break
		
		var phrase_text: String = phrase["text"]
		var progress := clampf(inverse_lerp(phrase["start"], phrase["end"], time), 0.0, 1.0)
		visables += floori(phrase_text.length() * progress)
	dialogue_text_box.visible_characters = maxi(dialogue_text_box.visible_characters, visables)
	if dialogue_text_box.visible_characters >= dialogue_text_box.get_total_character_count():
		current_sentece = null
		current_audioPlayer = null
		await get_tree().create_timer(2.0).timeout
		hide()

func next_sentence(next_sentence : Sentence, next_character : Character):
	dialogue_text_box.text = ""
	
	for phrase in next_sentence.phrases:
		dialogue_text_box.text += phrase["text"]
		
	current_audioPlayer = next_character.audioPlayer
	dialogue_text_box.visible_characters = 0
	current_audioPlayer.stream = next_sentence.voice_over
	current_audioPlayer.play()
	current_sentece = next_sentence
	show()
