extends Node3D

@export var torus_radius = 2.0
@export var tube_radius = 0.5
@export var radial_segments = 6 
@export var tubular_segments = 16 
@export var color = Color.ROYAL_BLUE
@onready var mesh_instance = $MeshInstance3D
@onready var cam = $Camera3D

func _ready():
	setup_scene()
	create_exploding_torus()

func _process(delta):
	if mesh_instance:
		mesh_instance.rotate_x(delta * 0.3) 
		mesh_instance.rotate_y(delta * 0.5)

func setup_scene():
	var env = Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("gainsboro")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color.WHITE * 0.3 
	
	var world_env = WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)

	$DirectionalLight3D.look_at(Vector3.ZERO)

func create_exploding_torus():
	mesh_instance.material_override.set_shader_parameter("color_base", color)
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for j in range(tubular_segments):
		for i in range(radial_segments):
			var u = float(i) / radial_segments * TAU
			var v = float(j) / tubular_segments * TAU
			
			var u_next = float(i + 1) / radial_segments * TAU
			var v_next = float(j + 1) / tubular_segments * TAU
			
			var p1 = get_torus_point(u, v)
			var p2 = get_torus_point(u_next, v)
			var p3 = get_torus_point(u_next, v_next)
			var p4 = get_torus_point(u, v_next)

			var center = (p1 + p2 + p3 + p4) / 4.0
			@warning_ignore("unused_variable")
			var normal = (p1 - center).normalized() 
			var n = (p2 - p1).cross(p4 - p1).normalized()

			var index = float(j * radial_segments + i)
			var seed_val = fmod(index * index, 100.0) / 100.0 
			var color_seed = Color(seed_val, 0, 0, 1) 
			
			st.set_color(color_seed)
			st.set_normal(n)
			st.set_uv(Vector2(0, 0))
			st.add_vertex(p1)
			
			st.set_color(color_seed)
			st.set_normal(n)
			st.set_uv(Vector2(1, 0))
			st.add_vertex(p2)
			
			st.set_color(color_seed)
			st.set_normal(n)
			st.set_uv(Vector2(0, 1))
			st.add_vertex(p4)
			
			st.set_color(color_seed)
			st.set_normal(n)
			st.set_uv(Vector2(1, 0))
			st.add_vertex(p2)
			
			st.set_color(color_seed)
			st.set_normal(n)
			st.set_uv(Vector2(1, 1))
			st.add_vertex(p3)
			
			st.set_color(color_seed)
			st.set_normal(n)
			st.set_uv(Vector2(0, 1))
			st.add_vertex(p4)

	mesh_instance.mesh = st.commit()

func get_torus_point(u, v) -> Vector3:
	var r = tube_radius * cos(u) 
	var x = (torus_radius + r) * cos(v)
	var y = (torus_radius + r) * sin(v)
	var z = tube_radius * sin(u)
	return Vector3(x, y, z)
