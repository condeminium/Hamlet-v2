extends Node
@onready var taskManager = $"../../TaskManager"
@onready var itemManager = $"../../ItemManager"
@onready var charController = $".."
@onready var hungerBar  = $"../hungerBar"
enum PawnAction {Idle, DoingSubTask}

var currentAction : PawnAction = PawnAction.Idle

var currentTask : Task = null
var inHand 

var foodNeed : float = 0.4 #0 = min , 1 = max
var eatSpeed : float = 0.5
var foodNeedDepleteSpeed : float = 0.1


func _process(delta: float) -> void:
	foodNeed -= foodNeedDepleteSpeed * delta
	hungerBar.value = foodNeed * 100
	if currentTask != null:
		DoCurrentTask(delta)
	else:
		if foodNeed < 0.5:
			currentTask = taskManager.RequestTask()
func OnPickUpItem(item):
	inHand = item
	itemManager.RemoveItemFromWorld(item)
func DoCurrentTask(delta):
	var subTask = currentTask.GetCurrentSubtask()
	
	if currentAction == PawnAction.Idle:
		StartCurrentSubTask(subTask)
	else:
		match subTask.taskType:
			Task.TaskType.WalkTo:
				if charController.HasReachedDestination():
					currentTask.OnReachedDestination()
					OnFinishedSubTask()	
			Task.TaskType.Eat:
				if inHand.nutrition > 0 and foodNeed < 1:
					inHand.nutrition -= eatSpeed * delta
					foodNeed += eatSpeed * delta
				else:
					print("finished eating food")
					inHand = null
					
					currentTask.OnFinishSubtask()
					OnFinishedSubTask()
func OnFinishedSubTask():
	currentAction = PawnAction.Idle
	if currentTask.IsFinished():
		currentTask = null
		
func StartCurrentSubTask(subTask):
	print("Starting subtask ", Task.TaskType.keys()[subTask.taskType])
	
	match subTask.taskType:
		Task.TaskType.FindItem:
			var targetItem = itemManager.FindNearestItem(subTask.targetItemType, charController.position)
			if targetItem == null:
				print("No item, force task to finish")
				currentTask.Finish()
			else:
				currentTask.OnFoundItem(targetItem)
				
				OnFinishedSubTask()
		Task.TaskType.WalkTo:
			charController.SetMoveTarget(subTask.targetItem.position)
			currentAction = PawnAction.DoingSubTask
		Task.TaskType.PickUp:
			OnPickUpItem(subTask.targetItem)
			currentTask.OnFinishSubtask()
			OnFinishedSubTask()
		Task.TaskType.Eat:
			currentAction = PawnAction.DoingSubTask
	pass

 
