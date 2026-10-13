extends Node3D

@onready var display_color = $SubViewport/GUI/Display_Color
@onready var display_text = $SubViewport/GUI/Display_Text
@onready var baby_text = $SubViewport/GUI/Baby_Text

enum Answer { CORRECT,INCORRECT,NONE }

var _old_correct_count : int = 0
var _old_wrong_count : int = 0
var input : Answer = Answer.NONE

func _ready() -> void:
	_checkAnswer(Answer.NONE)

func _changeText(string: String):
	display_text.text = string

func _changeColor(c: Color):
	display_color.color = c

func _checkAnswer(ans: Answer):
	match ans:
		Answer.CORRECT:
			_changeColor(Color.GREEN)
			_changeText("Correct")
		Answer.INCORRECT:
			_changeColor(Color.RED)
			_changeText("Incorrect")
		Answer.NONE:
			_changeText("")
			_changeColor(Color.TRANSPARENT)

func _process(_delta: float) -> void:
	var _correct_count : int = GameStats.correct_count
	var _wrong_count : int = GameStats.wrong_count
	baby_text.text = GameStats.baby_ID
	
	if _correct_count > _old_correct_count:
		_old_correct_count = _correct_count
		input = Answer.CORRECT
		
	elif _wrong_count > _old_wrong_count:
		_old_wrong_count = _wrong_count
		input = Answer.INCORRECT
	
	_checkAnswer(input)
