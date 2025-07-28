extends StaticBody3D
class_name Chunk

const CHUNK_WIDTH = 16
const CHUNK_HEIGHT = 256
const CHUNK_DEPTH = 16

var blocks = []
var noise = FastNoiseLite.new()

func _init():
	blocks.resize(CHUNK_WIDTH * CHUNK_HEIGHT * CHUNK_DEPTH)
	noise.seed = randi()
	noise.fractal_octaves = 4
	noise.fractal_lacunarity = 2.0
	noise.fractal_gain = 0.5
	noise.frequency = 0.015

func generate(chunk_x: int, chunk_z: int):
	for x in range(CHUNK_WIDTH):
		for z in range(CHUNK_DEPTH):
			var world_x = chunk_x * CHUNK_WIDTH + x
			var world_z = chunk_z * CHUNK_DEPTH + z
			var height = int(noise.get_noise_2d(world_x, world_z) * 10 + 20)

			for y in range(CHUNK_HEIGHT):
				if y == 0:
					set_block(x, y, z, BlockDataManager.get_block("Bedrock"))
				elif y < height - 3:
					set_block(x, y, z, BlockDataManager.get_block("Stone"))
				elif y < height:
					set_block(x, y, z, BlockDataManager.get_block("Dirt"))
				elif y == height:
					set_block(x, y, z, BlockDataManager.get_block("Grass"))
				else:
					set_block(x, y, z, BlockDataManager.get_block("Air"))

func set_block(x: int, y: int, z: int, block: Block):
	blocks[y * CHUNK_WIDTH * CHUNK_DEPTH + x * CHUNK_DEPTH + z] = block

func get_block(x: int, y: int, z: int) -> Block:
	if x < 0 or x >= CHUNK_WIDTH or y < 0 or y >= CHUNK_HEIGHT or z < 0 or z >= CHUNK_DEPTH:
		return BlockDataManager.get_block("Air")
	return blocks[y * CHUNK_WIDTH * CHUNK_DEPTH + x * CHUNK_DEPTH + z]

func draw():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	for y in range(CHUNK_HEIGHT):
		for x in range(CHUNK_WIDTH):
			for z in range(CHUNK_DEPTH):
				var block = get_block(x, y, z)
				if block.solid:
					# Check each face of the block
					if not get_block(x, y + 1, z).solid: # Top face
						var u = float(block.texture_id % 16) / 16.0
						var v = float(block.texture_id / 16) / 16.0
						surface_tool.set_uv(Vector2(u, v))
						surface_tool.add_vertex(Vector3(x, y + 1, z))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x + 1, y + 1, z))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y + 1, z + 1))
						surface_tool.set_uv(Vector2(u + 0.0625, v + 0.0625))
						surface_tool.add_vertex(Vector3(x + 1, y + 1, z + 1))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y + 1, z + 1))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x + 1, y + 1, z))
					if not get_block(x, y - 1, z).solid: # Bottom face
						var u = float(block.texture_id % 16) / 16.0
						var v = float(block.texture_id / 16) / 16.0
						surface_tool.set_uv(Vector2(u, v))
						surface_tool.add_vertex(Vector3(x, y, z))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y, z + 1))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x + 1, y, z))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x + 1, y, z))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y, z + 1))
						surface_tool.set_uv(Vector2(u + 0.0625, v + 0.0625))
						surface_tool.add_vertex(Vector3(x + 1, y, z + 1))
					if not get_block(x + 1, y, z).solid: # Right face
						var u = float(block.texture_id % 16) / 16.0
						var v = float(block.texture_id / 16) / 16.0
						surface_tool.set_uv(Vector2(u, v))
						surface_tool.add_vertex(Vector3(x + 1, y, z))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x + 1, y, z + 1))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x + 1, y + 1, z))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x + 1, y + 1, z))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x + 1, y, z + 1))
						surface_tool.set_uv(Vector2(u + 0.0625, v + 0.0625))
						surface_tool.add_vertex(Vector3(x + 1, y + 1, z + 1))
					if not get_block(x - 1, y, z).solid: # Left face
						var u = float(block.texture_id % 16) / 16.0
						var v = float(block.texture_id / 16) / 16.0
						surface_tool.set_uv(Vector2(u, v))
						surface_tool.add_vertex(Vector3(x, y, z))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y + 1, z))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x, y, z + 1))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x, y, z + 1))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y + 1, z))
						surface_tool.set_uv(Vector2(u + 0.0625, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y + 1, z + 1))
					if not get_block(x, y, z + 1).solid: # Front face
						var u = float(block.texture_id % 16) / 16.0
						var v = float(block.texture_id / 16) / 16.0
						surface_tool.set_uv(Vector2(u, v))
						surface_tool.add_vertex(Vector3(x, y, z + 1))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y + 1, z + 1))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x + 1, y, z + 1))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x + 1, y, z + 1))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y + 1, z + 1))
						surface_tool.set_uv(Vector2(u + 0.0625, v + 0.0625))
						surface_tool.add_vertex(Vector3(x + 1, y + 1, z + 1))
					if not get_block(x, y, z - 1).solid: # Back face
						var u = float(block.texture_id % 16) / 16.0
						var v = float(block.texture_id / 16) / 16.0
						surface_tool.set_uv(Vector2(u, v))
						surface_tool.add_vertex(Vector3(x, y, z))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x + 1, y, z))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y + 1, z))
						surface_tool.set_uv(Vector2(u, v + 0.0625))
						surface_tool.add_vertex(Vector3(x, y + 1, z))
						surface_tool.set_uv(Vector2(u + 0.0625, v))
						surface_tool.add_vertex(Vector3(x + 1, y, z))
						surface_tool.set_uv(Vector2(u + 0.0625, v + 0.0625))
						surface_tool.add_vertex(Vector3(x + 1, y + 1, z))

	surface_tool.generate_normals()
	var mesh = surface_tool.commit()
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	add_child(mesh_instance)

	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = mesh.create_trimesh_shape()
	add_child(collision_shape)
