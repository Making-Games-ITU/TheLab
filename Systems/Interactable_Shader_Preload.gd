extends Interactable

@onready var loading_screen := %LoadingScreen

func _ready() -> void:
	super()
	_prewarm()

func _prewarm() -> void:
	loading_screen.visible = true
	visible = true
	_set_outline(true)
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	_set_outline(false)
	InteractionPrompt.instance.hide_prompt()
	loading_screen.visible = false
	self.queue_free()

func _focus() -> void:
	InteractionPrompt.instance.hide_prompt()
