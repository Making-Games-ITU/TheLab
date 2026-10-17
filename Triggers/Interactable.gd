class_name Interactable
extends Node3D

signal interacted(interactor: Node)

@export_group("General")
@export var prompt_text := "<NO PROMPT SET>"
@export var anim: AnimationPlayer = null
@export var area: Area3D
@export var sound_emitter: FmodEventEmitter3D

@export_group("Outline Shader")
@export var outline_material: ShaderMaterial = preload("res://Shaders/Outline_Shader_Material.tres")
@export var outline_meshes: Array[MeshInstance3D] = [] # In case multiple things in mesh

#REMEMBER TO SET COLLISION LAYER IN THE INSPECTOR OF THE AREA3D NODE FOR INTERACTION TO BE DETECTED WITH RAYCAST.
func _ready() -> void:
	if outline_meshes.is_empty(): # In case multiple things in mesh
		for m in find_children("*", "MeshInstance3D", true, false):
			outline_meshes.append(m)

func _set_outline(enabled: bool) -> void:
	if area == null:
		area = find_child("*", true, false) as Area3D
	for m in outline_meshes:
		if is_instance_valid(m):
			m.material_overlay = outline_material if enabled else null

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
