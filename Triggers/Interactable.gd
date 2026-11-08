class_name Interactable
extends Node3D

signal interacted(interactor: Node)

@export_group("General")
@export var prompt_text := "<NO PROMPT SET>"
@export var anim: AnimationPlayer = null
@export var area: Area3D
@export var sound_emitter: FmodEventEmitter3D
@export var uninteractable_sound: FmodEventEmitter3D

@export_group("Outline Shader")
@export var outline_material: ShaderMaterial = preload("res://Shaders/Outline_Shader_Material.tres")
@export var outline_meshes: Array[MeshInstance3D] = [] # In case multiple things in mesh
var _original_overlays: Dictionary = {}
var _combined_overlays: Dictionary = {}

#REMEMBER TO SET COLLISION LAYER IN THE INSPECTOR OF THE AREA3D NODE FOR INTERACTION TO BE DETECTED WITH RAYCAST.
#InteractableObject.tscn can be placed as a child node of a given asset/model to give it an interactable hitbox. Remember to make it local to assign the Area3D.
func _ready() -> void:
	if outline_meshes.is_empty(): # In case multiple things in mesh
		for m in find_children("*", "MeshInstance3D", true, false):
			outline_meshes.append(m)

func _set_outline(enabled: bool) -> void:
	if area == null:
		area = find_child("*", true, false) as Area3D
	for m in outline_meshes:
		if not is_instance_valid(m):
			continue
		# Remember the mesh's own overlay the first time we touch it
		if not _original_overlays.has(m):
			_original_overlays[m] = m.material_overlay
		var original: Material = _original_overlays[m]

		if not enabled:
			m.material_overlay = original
		elif original == null:
			m.material_overlay = outline_material
		else:
			# Mesh already uses the overlay (e.g. note text): draw the outline as an extra pass
			if not _combined_overlays.has(m):
				var combined: Material = original.duplicate()
				combined.next_pass = outline_material
				_combined_overlays[m] = combined
			m.material_overlay = _combined_overlays[m]

func focus() -> void:
	_set_outline(true)
	InteractionPrompt.instance.show_prompt(prompt_text)

func unfocus() -> void:
	_set_outline(false)
	InteractionPrompt.instance.hide_prompt()

func interact(interactor: Node) -> void:
	if sound_emitter != null:
		AudioManager.one_shot(sound_emitter)
	interacted.emit(interactor)
	InteractionPrompt.instance.show_prompt(prompt_text)

func _refresh_prompt() -> void:
	if PlayerStats.current_interactable == self:
		InteractionPrompt.instance.show_prompt(prompt_text)

func _uninteractable() -> void:
	AudioManager.one_shot(uninteractable_sound)
