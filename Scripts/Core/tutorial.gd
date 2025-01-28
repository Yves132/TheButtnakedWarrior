extends Control

@onready var MovementK = $KeyboardLabel/First
@onready var MovementJ = $JoypadLabel/First
@onready var RunK = $KeyboardLabel2/Second
@onready var RunJ = $JoypadLabel2/Second
@onready var SwordK = $KeyboardLabel3/Third
@onready var SwordJ = $JoypadLabel3/Third
@onready var Shrine = $ShrineLabel/Fifth
@onready var LaddersK = $KeyboardLabel4/Sixth
@onready var LaddersJ = $JoypadLabel4/Sixth
@onready var WallJumpK = $KeyboardLabel5/Seventh
@onready var WallJumpJ = $JoypadLabel5/Seventh
@onready var MagicK = $KeyboardLabel6/Eighth
@onready var MagicJ = $JoypadLabel6/Eighth
@onready var ninth = $Label9/Ninth
@onready var tenth = $Label7/Tenth


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if MovementJ.overlaps_body(GameManager.player) or MovementK.overlaps_body(GameManager.player):
		if GameManager.keyboarddetected:
			$KeyboardLabel.show()
			$JoypadLabel.hide()
		if GameManager.joypaddetected:
			$JoypadLabel.show()
			$KeyboardLabel.hide()
	else:
		$KeyboardLabel.hide()
		$JoypadLabel.hide()
		
	if RunK.overlaps_body(GameManager.player) or RunJ.overlaps_body(GameManager.player):
		if GameManager.keyboarddetected:
			$KeyboardLabel2.show()
			$JoypadLabel2.hide()
		if GameManager.joypaddetected:
			$JoypadLabel2.show()
			$KeyboardLabel2.hide()
	else:
		$KeyboardLabel2.hide()
		$JoypadLabel2.hide()
		
	if SwordK.overlaps_body(GameManager.player) or SwordJ.overlaps_body(GameManager.player):
		if GameManager.keyboarddetected:
			$KeyboardLabel3.show()
			$JoypadLabel3.hide()
		if GameManager.joypaddetected:
			$JoypadLabel3.show()
			$KeyboardLabel3.hide()
	else:
		$KeyboardLabel3.hide()
		$JoypadLabel3.hide()
		
	if Shrine.overlaps_body(GameManager.player):
		$ShrineLabel.show()
	else:
		$ShrineLabel.hide()
		
	if LaddersK.overlaps_body(GameManager.player) or LaddersJ.overlaps_body(GameManager.player):
		if GameManager.keyboarddetected:
			$KeyboardLabel4.show()
			$JoypadLabel4.hide()
		if GameManager.joypaddetected:
			$JoypadLabel4.show()
			$KeyboardLabel4.hide()
	else:
		$JoypadLabel4.hide()
		$KeyboardLabel4.hide()
		
	if WallJumpK.overlaps_body(GameManager.player) or WallJumpJ.overlaps_body(GameManager.player):
		if GameManager.keyboarddetected:
			$KeyboardLabel5.show()
			$JoypadLabel5.hide()
		if GameManager.joypaddetected:
			$JoypadLabel5.show()
			$KeyboardLabel5.hide()
	else:
		$JoypadLabel5.hide()
		$KeyboardLabel5.hide()
		
	if MagicK.overlaps_body(GameManager.player) or MagicJ.overlaps_body(GameManager.player):
		if GameManager.keyboarddetected:
			$KeyboardLabel6.show()
			$JoypadLabel6.hide()
		if GameManager.joypaddetected:
			$JoypadLabel6.show()
			$KeyboardLabel6.hide()
	else:
		$KeyboardLabel6.hide()
		$JoypadLabel6.hide()
	if ninth.overlaps_body(GameManager.player):
		$Label9.show()
	else:
		$Label9.hide()
	if tenth.overlaps_body(GameManager.player):
		$Label7.show()
	else:
		$Label7.hide()
