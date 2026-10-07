extends CharacterBody2D
@onready var terrain = $"../Terrain"
@onready var pathfinding = $"../Pathfinding"
@onready var itemManager = $"../ItemManager"
const SPEED = 100.0

var path = []

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		var pos = position / terrain.rendering_quadrant_size
		var targetPos = get_global_mouse_position() / terrain.rendering_quadrant_size
		path =  pathfinding.RequestPath(pos, targetPos)
		
	if Input.is_action_just_pressed("ui_accept"):
		var pos = position / terrain.rendering_quadrant_size
		var targetPos = itemManager.FindNearestItem(itemManager.ItemCategory.FOOD, position).position / terrain.rendering_quadrant_size
		print(targetPos)
		path =  pathfinding.RequestPath(pos, targetPos)
	
	if len(path) > 0:
		var direction = global_position.direction_to(path[0])
		var terrainDifficulty = pathfinding.GetTerrainDifficulty(position / terrain.rendering_quadrant_size)
		velocity = direction * SPEED * (1 / terrainDifficulty)
		if position.distance_to(path[0]) < SPEED * delta:
			path.remove_at(0)
	else:
		velocity  = Vector2i(0,0)
	move_and_slide()
