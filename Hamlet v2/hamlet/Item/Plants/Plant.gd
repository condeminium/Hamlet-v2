extends Item

class_name Plant

var harvestProgress : float = 0
var harvestDifficulty : float = 4

var harvestItem : String = "res://Item/Food/Berries.tscn"
var harvestAmount : Vector2i = Vector2i(5, 15)

func _init():
	super._init()
	add_to_group("Plant")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func TryHarvest(amount : float) -> bool:
	harvestProgress += amount * 1/harvestDifficulty
	
	if harvestProgress >= 1:
		itemManager.RemoveItemFromWorld(self)
		var rng = RandomNumberGenerator.new()
		itemManager.SpawnItemByName(harvestItem, randi_range(harvestAmount.x, harvestAmount.y), ItemManager.WorldToMapPosition(position))
		return true
	else:
		return false
		
func OnClick():
	taskManager.AddTask(Task.TaskType.Harvest, self)
