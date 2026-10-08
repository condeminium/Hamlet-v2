@tool
extends Node2D

@onready var terrain = $"../Terrain"

var astar_grid = AStarGrid2D.new()

@export var start : Vector2i
@export var end : Vector2i
@export var calculate : bool

var path = []


# Called when the node enters the scene tree for the first time.
func _ready():
	InitPathfinding()
	pass

func _draw():
	print("redrawing")
	if len(path) > 0:
		for i in range(len(path) - 1):
			draw_line(path[i], path[i+1], Color.PURPLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if calculate:
		calculate = false
		InitPathfinding()
		RequestPath(start, end)
		
func RequestPath(start: Vector2i, end: Vector2i):
	path = astar_grid.get_point_path(start, end)
	
	for i in range(len(path)):
		path[i] += Vector2(terrain.rendering_quadrant_size/2, terrain.rendering_quadrant_size/2)
	
	queue_redraw()
	
	return path
	
func InitPathfinding():
	astar_grid.region = Rect2i(0, 0, terrain.mapWidth, terrain.mapHeight)
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	
	for x in range(terrain.mapWidth):
		for y in range(terrain.mapHeight):	
			if GetTerrainDifficulty(Vector2i(x,y)) == -1:
				astar_grid.set_point_solid(Vector2i(x,y))
			else:
				astar_grid.set_point_weight_scale(Vector2i(x,y), GetTerrainDifficulty(Vector2i(x, y)))
			
			
			
	
	
func GetTerrainDifficulty(coords : Vector2i):
	var tile_data = terrain.get_cell_tile_data(coords)
	return tile_data.get_custom_data("walk_difficulty")
	
