extends CharacterBody2D

@onready var terrain = $"../Terrain"
@onready var pathfinding = $"../Pathfinding"
@onready var itemManager = $"../ItemManager"

const SPEED = 300.0

var path = []

func SetMoveTarget(worldPos : Vector2):
	var pos = position / terrain.rendering_quadrant_size
	var targetPos = worldPos / terrain.rendering_quadrant_size
	
	path = pathfinding.RequestPath(pos, targetPos)
	
func HasReachedDestination():
	return len(path) == 0

func _physics_process(delta):
	
			
	if len(path) > 0:
		var direction = global_position.direction_to(path[0])
		var terrainDifficulty = pathfinding.GetTerrainDifficulty(position / terrain.rendering_quadrant_size)
		velocity = direction * SPEED * (1 / terrainDifficulty)
		
		if position.distance_to(path[0]) < SPEED * delta:
			path.remove_at(0)
			
	else:
		velocity = Vector2(0,0)


	move_and_slide()
