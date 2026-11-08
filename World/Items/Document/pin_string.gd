extends Node3D
class_name EvidenceString

@export var start_pin: Marker3D
@export var end_pin: Marker3D

@export_range(0.0, 1.0, 0.01) var sag_amount: float = 0.15
@export_range(2, 50, 1) var segments: int = 20
@export var string_thickness: float = 0.003
@export var string_material: Material

var string_segments: Array[MeshInstance3D] = []

func _ready() -> void:
	create_string()
	update_string()


func create_string() -> void:
	for segment in string_segments:
		segment.queue_free()

	string_segments.clear()

	for i in range(segments):
		var mesh_instance = MeshInstance3D.new()
		var cylinder = CylinderMesh.new()

		cylinder.top_radius = string_thickness
		cylinder.bottom_radius = string_thickness

		mesh_instance.mesh = cylinder
		mesh_instance.material_override = string_material

		add_child(mesh_instance)
		string_segments.append(mesh_instance)


func update_string() -> void:
	if not start_pin or not end_pin:
		return

	var start = start_pin.global_position
	var end = end_pin.global_position

	for i in range(segments):
		var t1 = float(i) / segments
		var t2 = float(i + 1) / segments

		var point_a = get_curve_point(start, end, t1)
		var point_b = get_curve_point(start, end, t2)

		var direction = point_b - point_a
		var distance = direction.length()

		var mesh_instance = string_segments[i]
		var cylinder = mesh_instance.mesh as CylinderMesh

		cylinder.height = distance

		mesh_instance.global_position = (point_a + point_b) / 2.0
		mesh_instance.global_basis = Basis(
			Quaternion(Vector3.UP, direction.normalized())
		)


func get_curve_point(start: Vector3, end: Vector3, t: float) -> Vector3:
	var point = start.lerp(end, t)

	var sag = 4.0 * t * (1.0 - t) * sag_amount

	point.y -= sag

	return point
