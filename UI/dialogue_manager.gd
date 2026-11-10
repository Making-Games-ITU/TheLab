extends Control

@export var dialogue_text_box : RichTextLabel
@export var audioPlayer : AudioStreamPlayer3D
var current_sentece : Sentence

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await get_tree().create_timer(3.0).timeout
	var introduction_s = Sentence.new()
	introduction_s.phrases = [
		{"text": "If you can't sleep, ", "start": 0.0, "end": 1.1},
		{"text": "try staring at a bright flashlight until your eyes get tired. ", "start": 1.1, "end": 4.5},
	]
	introduction_s.voice_over = preload("res://Dialogue/if-you-cant-sleep-try-staring-at-a-bright-flashlight-until-your-eyes-get-tired-uncanny-ai-voice-assistant-jam-fx-if-you-cant-sleep-try-staring-at-a-bright-flashlight-awful-ai-advice-1-0m05s.mp3")
	_next_sentence(introduction_s)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if current_sentece == null:
		return
	
	var time := audioPlayer.get_playback_position()
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
		await get_tree().create_timer(2.0).timeout
		hide()

func _next_sentence(next_sentence : Sentence):
	dialogue_text_box.text = ""
	
	for phrase in next_sentence.phrases:
		dialogue_text_box.text += phrase["text"]
		
	dialogue_text_box.visible_characters = 0
	audioPlayer.stream = next_sentence.voice_over
	#audioPlayer.finished.connect(_on_dialogue_finished)
	audioPlayer.play()
	current_sentece = next_sentence
	show()
	
	
func _on_dialogue_finished():
	dialogue_text_box.visible_characters = -1
	current_sentece = null
