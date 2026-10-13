class_name GameManager
extends Node

# Which baby emotion each physical button answers
var button_to_emotion := {
	GameStats.Buttons.BUTTON1: GameStats.Emotion.HAPPY,
	GameStats.Buttons.BUTTON2: GameStats.Emotion.SAD,
	GameStats.Buttons.BUTTON3: GameStats.Emotion.ANGRY,
}

var babyIdString : String = "BABY #"
var pressed : GameStats.Buttons = GameStats.interacted_button

func _ready() -> void:
	_next_baby()

func _process(_delta: float) -> void:
	pressed = GameStats.interacted_button
	GameStats.interacted_button = GameStats.Buttons.NONE
	if pressed == GameStats.Buttons.NONE or GameStats.game_over:
		return
	
	if pressed == GameStats.Buttons.NEW_BABY: 
		if GameStats.ready_for_next_baby:
			GameStats.ready_for_next_baby = false
			_next_baby()
		return

	if button_to_emotion[pressed] == GameStats.baby_state:
		print("Correct!")
		GameStats.correct_count += 1
	else:
		print("Wrong!")
		GameStats.wrong_count += 1
		
	if GameStats.correct_count + GameStats.wrong_count <= GameStats.answers_max:
		_pick_new_emotion()
	elif GameStats.correct_count > GameStats.wrong_count:
		GameStats.ready_for_next_baby = true
	else:
		_game_over()

func _pick_new_emotion() -> void:
	# NONE is the last enum value, so it's excluded from the roll
	GameStats.baby_state = randi_range(0, GameStats.Emotion.NONE - 1) as GameStats.Emotion
	print("Baby is: ", GameStats.Emotion.keys()[GameStats.baby_state])
	# Sound stuff would be set here

func _next_baby():
	print("Next baby coming")
	GameStats.correct_count = 0
	GameStats.wrong_count = 0
	GameStats.answers_max += 2
	_increase_babyID()
	_pick_new_emotion()
	# Potential game difficulty increase would be set here

func _increase_babyID() -> void:
	GameStats.baby_number += 1 
	GameStats.baby_ID = babyIdString+ "%04d" % GameStats.baby_number
	

func _game_over() -> void:
	print("You lose!")
	GameStats.game_over = true
	# Scary stuff can be set here
