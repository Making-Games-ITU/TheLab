class_name SurfaceData
extends Resource

# P = Parasites M = Mutation
enum sickness_enum {P, M, PM}
 
@export var sickness : sickness_enum

@export var healthy_head_texture: Texture2D
@export var healthy_body_texture: Texture2D

@export var infected_head_texture: Texture2D
@export var infected_body_texture: Texture2D
