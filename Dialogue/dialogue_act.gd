class_name DialogueAct
extends Resource

@export var sentences: Array[Sentence] = []

func get_sentence(sentence_id : String) -> Sentence:
	for sentence in sentences:
		if(sentence.sentence_id == sentence_id):
			return sentence
	return null
