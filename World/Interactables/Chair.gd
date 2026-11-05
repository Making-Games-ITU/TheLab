extends Interactable

@export_group("Chair")
@export var seat_point: Marker3D
@export var exit_point: Marker3D 
@export var stand_sound: FmodEventEmitter3D

func _ready() -> void:
	super()

func focus() -> void:
	_set_outline(true)
	_update_prompt()
	
func _update_prompt() -> void:
	if PlayerStats.is_sitting:
		prompt_text = "Stand"
	else:
		prompt_text = "Sit"
	InteractionPrompt.instance.show_prompt(prompt_text)

func interact(interactor: Node) -> void:
	if PlayerStats.current_chair == self:
		stand(interactor)
	else:
		sit(interactor)

func sit(interactor: Node) -> void:
	if PlayerStats.is_sitting:
		return
	var player : Player = interactor
	player.teleport_to(seat_point.global_position, seat_point.global_rotation.y)
	PlayerStats.is_sitting = true
	PlayerStats.current_chair = self
	AudioManager.one_shot(sound_emitter)

func stand(interactor: Node) -> void:
	var player : Player = interactor
	player.teleport_to(exit_point.global_position)
	PlayerStats.is_sitting = false
	PlayerStats.current_chair = null
	AudioManager.one_shot(stand_sound)
