extends Node

enum Emotion { HAPPY, SAD, ANGRY, NONE }
var baby_state : Emotion = Emotion.NONE
var baby_number : int = 0
var baby_ID : String = ""

enum Buttons { BUTTON1, BUTTON2, BUTTON3, NEW_BABY, NONE }
var interacted_button : Buttons = Buttons.NONE

var wrong_count: int = 0
var correct_count: int = 0
var answers_max: int = 3
var game_over: bool = false
var ready_for_next_baby: bool = false
