extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Zoom()
	SimplePan()
	ClickAndDrag()

func Zoom():
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom = zoom * 1.1
	elif Input.is_action_just_pressed("camera_zoom_out"):
		zoom = zoom * 0.9
		pass
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
