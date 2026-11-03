extends Interactable

func _ready() -> void:
	super()
	_prewarm()

func _prewarm() -> void:
	visible = true
	_set_outline(true)
	await RenderingServer.frame_post_draw
	_set_outline(false)
	InteractionPrompt.instance.hide_prompt()
	self.queue_free()

func _focus() -> void:
	InteractionPrompt.instance.hide_prompt()
