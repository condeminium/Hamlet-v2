@tool
extends Panel

@export var reset : bool = false

@onready var UI = $".."
var current_buildable : String = ""
var columnCount : int = 2
var buttons = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LoadButtons()
	for button in buttons:
		button.connect("pressed", OnButtonPressed.bind(button))
	pass # Replace with function body.

func OnButtonPressed(button : Button):
	OpenSubMenu(button.text)
	
func OpenSubMenu(menu):
	if menu == current_buildable:
		find_child("pnl_buildable").set_visible(false)
		current_buildable = ""
	else:
		current_buildable = menu
		find_child("pnl_buildable").set_visible(true)
		match menu:
			"Structure":
				LoadArchitectBuildableMenu()
	
func LoadArchitectBuildableMenu():
	var pnl_buildable = find_child("pnl_buildable")
	for i in range(pnl_buildable.get_child_count()):
		pnl_buildable.get_child(i).queue_free()
	var buildables = ["Cancel", "Wall", "Door", "Fence"]
	
	for i in range(len(buildables)):
		var button = Button.new()
		pnl_buildable.add_child(button)
		button.text = buildables[i]
		var buttonSize = pnl_buildable.size.x / 20
		button.position = Vector2(buttonSize * i, pnl_buildable.size.y - buttonSize)
		button.size = Vector2(buttonSize, buttonSize)
		button.add_theme_font_size_override("font_size", 10)
	
func _process(delta: float) -> void:
	if reset:
		reset = false
		LoadButtons()
		ArrangeSelf()
		ArrangeButtons()
	pass

func LoadButtons():
	buttons = []
	for child in get_children():
		if child is Button:
			buttons.append(child)

func ArrangeSelf():
	anchor_left = 0
	anchor_right = 0.2
	anchor_bottom = 1 - UI.buttonHeight
	var rows = (len(buttons) + 1) / columnCount
	anchor_top =  anchor_bottom -  UI.buttonHeight * rows
	
	offset_bottom = 0
	offset_top = 0
	offset_left = 0
	offset_right = 0
func ArrangeButtons():
	var rows = (len(buttons) + 1) / columnCount
	for i in range(len(buttons)):
		var column = i%columnCount
		var row = i / columnCount
		buttons[i].anchor_top = row * 1/float(rows)
		buttons[i].anchor_bottom = 1/float(rows) + row * 1/float(rows)
		buttons[i].anchor_left = column * 1/float(columnCount)
		buttons[i].anchor_right = 1/float(columnCount) + column * 1/float(columnCount)
		
		buttons[i].offset_bottom = 0
		buttons[i].offset_top = 0
		buttons[i].offset_left = 0
		buttons[i].offset_right = 0
	pass
