extends Node

class_name ItemManager

enum ItemCategory {ITEM = 0, FOOD = 1, WEAPON = 2, MELEEWEAPON = 3, PROJECTILEWEAPON = 4}
var itemCategories = ["Item", "Food", "Weapons", "MeleeWeapon", "ProjectileWeapon"]

var foodPrototypes = []
var itemPrototypes = []

var itemsInWorld = []

# Called when the node enters the scene tree for the first time.
func _ready():
	LoadFood()
	LoadItemPrototypes()
	
	SpawnItem(foodPrototypes[0], Vector2(5,10))
	SpawnItemByName("res://Item/Plants/BerryBush.tscn", 1, Vector2i(10,10))
	SpawnItemByName("res://Item/Plants/BerryBush.tscn", 1, Vector2i(15,12))
	#SpawnItem(foodPrototypes[1], Vector2(6,12))
	#SpawnItem(foodPrototypes[1], Vector2(8,3))
	#SpawnItem(foodPrototypes[0], Vector2(10,10))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func MapToWorldPosition(mapPosX : int, mapPosY : int) -> Vector2:
	return Vector2(mapPosX * 16 + 8, mapPosY * 16 + 8)
	
static func WorldToMapPosition(worldPos : Vector2) -> Vector2i:
	return Vector2i(worldPos.x / 16, worldPos.y / 16)
	
func RemoveItemFromWorld(item):
	remove_child(item)
	itemsInWorld.erase(item)
	
func SpawnItemByName(itemName : String, amount: int, mapPosition : Vector2i):
	var newItem
	
	for item in itemPrototypes:
		if item.get_path() == itemName:
			newItem = item.instantiate()
			newItem.count = amount
			
	if newItem != null:
		add_child(newItem)
		itemsInWorld.append(newItem)
		newItem.position = MapToWorldPosition(mapPosition.x, mapPosition.y)
	
func SpawnItem(item, mapPosition):
	var newItem = item.instantiate()
	add_child(newItem)
	itemsInWorld.append(newItem)
	newItem.position = MapToWorldPosition(mapPosition.x, mapPosition.y)
	
func FindNearestItem(itemCategory : ItemCategory, worldPosition : Vector2):
	if len(itemsInWorld) == 0:
		return null
		
	var nearestItem = null
	var nearestDistance = 999999
	
	for item in itemsInWorld:
		if IsItemInCategory(item, itemCategory):
			var distance = worldPosition.distance_to(item.position)
			
			if nearestItem == null:
				nearestItem = item
				nearestDistance = distance
				continue
				
			if distance < nearestDistance:				
				nearestItem = item
				nearestDistance = distance
				
	return nearestItem
				
		

func IsItemInCategory(item, itemCategory) -> bool:
	return item.is_in_group(itemCategories[itemCategory])
	
func LoadItemPrototypes():
	var allFileNames = _dir_contents("res://Item/", ".tscn")
	for fileName in allFileNames:
		itemPrototypes.append(load(fileName))
		print(fileName)
	
func LoadFood():
	var path = "res://Item/Food"
	var dir = DirAccess.open(path)
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif file_name.ends_with(".tscn"):
			foodPrototypes.append(load(path + "/" + file_name))
	dir.list_dir_end()
	
static func _dir_contents(path, suffix) -> Array[String]:
	var dir = DirAccess.open(path)
	if !dir:
		print("An error occurred when trying to access path: %s" % [path])
		return []

	var files: Array[String]
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		file_name = file_name.replace('.remap', '') 
		if dir.current_is_dir():
			files.append_array(_dir_contents("%s/%s" % [path, file_name], suffix))
		elif file_name.ends_with(suffix):
			files.append("%s/%s" % [path, file_name])
		file_name = dir.get_next()
		
	return files
