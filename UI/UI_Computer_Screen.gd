extends Node3D

@onready var display_color = $SubViewport/GUI/Display_Color
@onready var display_text = $SubViewport/GUI/Display_Text
@onready var body_text = $SubViewport/GUI/Body_Text
@onready var body_condition_text = $SubViewport/GUI/Body_Condition_Text
@onready var win_lose_text = $SubViewport/GUI/Win_Lose_Text

enum Answer { CORRECT, INCORRECT, NONE }

@export var result_display_time : float = 1.5  # seconds

var _old_correct_count : int = 0
var _old_wrong_count : int = 0
var _clear_timer : Timer

func _ready() -> void:
	_clear_timer = Timer.new()
	_clear_timer.one_shot = true
	_clear_timer.timeout.connect(_on_clear_timer_timeout)
	add_child(_clear_timer)
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

func _show_answer(ans: Answer) -> void:
	_checkAnswer(ans)
	_clear_timer.start(result_display_time)  # restarts if already running

func _on_clear_timer_timeout() -> void:
	_checkAnswer(Answer.NONE)

func _check_win_lose() -> void:
	if GameStats.game_over:
		win_lose_text.text = "YOU LOSE"

func _check_for_next_baby() -> void:
	if GameStats.ready_for_next_baby:
		win_lose_text.text = "Get new baby"
	else:
		win_lose_text.text = ""

func _process(_delta: float) -> void:
	body_text.text = GameStats.body_ID
	body_condition_text.text = "WIP"

	## Compare with != so a reset to 0 (new baby) doesn't leave stale counts behind
	#if GameStats.correct_count != _old_correct_count:
		#if GameStats.correct_count > _old_correct_count:
			#_show_answer(Answer.CORRECT)
		#_old_correct_count = GameStats.correct_count
#
	#if GameStats.wrong_count != _old_wrong_count:
		#if GameStats.wrong_count > _old_wrong_count:
			#_show_answer(Answer.INCORRECT)
		#_old_wrong_count = GameStats.wrong_count
#
	#_check_for_next_baby()
	#_check_win_lose()
