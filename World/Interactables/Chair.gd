extends Interactable

@export_group("Chair")
@export var seat_point: Marker3D
@export var exit_point: Marker3D 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

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
	prompt_text = "Stand"
	_refresh_prompt()

func stand(interactor: Node) -> void:
	var player : Player = interactor
	player.teleport_to(exit_point.global_position)
	PlayerStats.is_sitting = false
	PlayerStats.current_chair = null
	prompt_text = "Sit"
	_refresh_prompt()
