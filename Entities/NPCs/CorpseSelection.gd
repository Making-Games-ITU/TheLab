extends Node
class_name Corpse_Selection

enum gender_enum {Male, Female}



@export var male_head : MeshInstance3D
@export var male_body : MeshInstance3D
@export var male_textures : Array[SurfaceData]
@export var male_hair : Array[MeshInstance3D]

@export var female_head : MeshInstance3D
@export var female_body : MeshInstance3D
@export var female_hair : Array[MeshInstance3D]
@export var female_textures : Array[SurfaceData]

var current_body
var current_head

func _ready():
	
	#EXAMPLE ON HOW TO USE THE BODY CHANGER
	#USE THIS FUNCTION TO CHANGE THE GENDER AND SICKNESS TYPE 
	##TODO WE NEED ANOTHER SICKNESS ENUM WHEN THE BODY IS HEALTHY AND NOT SICK.
	change_character(gender_enum.Female, SurfaceData.sickness_enum.M)
	
	##USE THIS FUNCTION TO CHANGE THE SICKNESS LEVEL. 1 BEING NOT SICK 0 BEING VERY SICK
	change_character_sickness_level(1)

#Please use values between 0 and 1. 0 is infected 1 is healthy
func change_character_sickness_level(sickness_threshold : float):
	if(current_body == null || 	current_head == null) : return
	current_body.set_shader_parameter("blending_threshold", sickness_threshold)
	current_head.set_shader_parameter("blending_threshold", sickness_threshold)



func change_character(gender : gender_enum, sickness : SurfaceData.sickness_enum) -> void:
	female_body.hide()
	female_head.hide()
	male_body.hide()
	male_head.hide()
	
	match gender:
		gender_enum.Female:
			for data in female_textures :
				if(data.sickness == sickness):
					var body_material = female_body.mesh.surface_get_material(0) as ShaderMaterial
					var head_material = female_head.mesh.surface_get_material(0) as ShaderMaterial
					body_material.set_shader_parameter("texture_albedo_a",data.healthy_body_texture)
					body_material.set_shader_parameter("texture_albedo_b", data.infected_body_texture)
					
					head_material.set_shader_parameter("texture_albedo_a",data.healthy_body_texture)
					head_material.set_shader_parameter("texture_albedo_b", data.infected_body_texture)
					
					current_body = body_material
					current_head = head_material
			female_body.show()
			female_head.show()
		gender_enum.Male:
			for data in male_textures :
				if(data.sickness == sickness):
					var body_material = male_body.mesh.surface_get_material(0) as ShaderMaterial
					var head_material = male_head.mesh.surface_get_material(0) as ShaderMaterial
					body_material.set_shader_parameter("texture_albedo_a",data.healthy_body_texture)
					body_material.set_shader_parameter("texture_albedo_b", data.infected_body_texture)
					
					head_material.set_shader_parameter("texture_albedo_a",data.healthy_body_texture)
					head_material.set_shader_parameter("texture_albedo_b", data.infected_body_texture)
					
					current_body = body_material
					current_head = head_material
			male_body.show()
			male_head.show()
