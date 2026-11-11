class_name Sentence
extends Resource

@export var voice_over: AudioStream
@export var phrases: Array[Dictionary] = []
@export var sentence_id : String
@export var next_sentence_id : String #Can be blank
var on_finished: Callable = Callable()
