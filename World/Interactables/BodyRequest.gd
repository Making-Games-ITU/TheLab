extends Interactable

var bodyIdString : String = "BODY #"

func interact(interactor: Node) -> void:
	_request_body()

func _request_body() -> void:			
	if (GameStats.body_exists):
		print("Warning: Containment chamber at max capacity. Dispose current subject.")
	else:
		_new_body()
		GameStats.body_exists = true
		if anim:
			anim.play("request")
			await anim.animation_finished
		GameStats.toggle_sample_collector = true

func _new_body():
	print("New subject requested")
	_increase_bodyID()
	print(GameStats.body_ID)
	# Body variance should be here
	# Potential game difficulty increase would be set here

func _increase_bodyID() -> void:
	GameStats.body_number += 1 
	GameStats.body_ID = bodyIdString+ "%04d" % GameStats.body_number
	
