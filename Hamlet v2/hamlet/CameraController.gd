extends Camera2D
var zoomTarget : Vector2
@export var zoomSpeed : float = 10
@export var panSpeed : float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoomTarget = zoom
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Zoom(delta)
	SimplePan(delta)
	ClickAndDrag()

func Zoom(delta):
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoomTarget *= 1.1
	elif Input.is_action_just_pressed("camera_zoom_out"):
		zoomTarget *= 0.9
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)
	
	
func SimplePan(delta):
	var moveAmount = Vector2.ZERO  
	if Input.is_action_pressed("camera_move_left"):
		moveAmount.x -= 1
	elif Input.is_action_pressed("camera_move_right"):
		moveAmount.x += 1
	elif Input.is_action_pressed("camera_move_up"):
		moveAmount.y -= 1
	elif Input.is_action_pressed("camera_move_down"):
		moveAmount.y += 1
	moveAmount = moveAmount.normalized()
	position += moveAmount * delta * 1000 * (1/zoom.x)
func ClickAndDrag():
	pass
