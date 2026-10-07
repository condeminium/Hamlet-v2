extends Camera2D
var zoomTarget : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoomTarget = zoom
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Zoom(delta)
	SimplePan()
	ClickAndDrag()

func Zoom(delta):
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoomTarget *= 1.1
	elif Input.is_action_just_pressed("camera_zoom_out"):
		zoomTarget *= 0.9
	zoom = zoom.slerp(zoomTarget, 10 * delta)
	
	
func SimplePan():
	if Input.is_action_pressed("camera_move_left"):
		position.x -= 1
	elif Input.is_action_pressed("camera_move_right"):
		position.x += 1
	elif Input.is_action_pressed("camera_move_up"):
		position.y -= 1
	elif Input.is_action_pressed("camera_move_down"):
		position.y += 1
	pass
func ClickAndDrag():
	pass
