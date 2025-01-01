extends Control

@onready var first = $Label/First
@onready var second = $Label8/Second
@onready var third = $Label10/Third
@onready var fourth = $Label2/Fourth
@onready var fifth = $Label3/Fifth
@onready var sixth = $Label4/Sixth
@onready var seventh = $Label5/Seventh
@onready var eighth = $Label6/Eighth
@onready var ninth = $Label9/Ninth
@onready var tenth = $Label7/Tenth


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if first.overlaps_body(GameManager.player):
		$Label.show()
	else:
		$Label.hide()
	if second.overlaps_body(GameManager.player):
		$Label8.show()
	else:
		$Label8.hide()
	if third.overlaps_body(GameManager.player):
		$Label10.show()
	else:
		$Label10.hide()
	if fourth.overlaps_body(GameManager.player):
		$Label2.show()
	else:
		$Label2.hide()
	if fifth.overlaps_body(GameManager.player):
		$Label3.show()
	else:
		$Label3.hide()
	if sixth.overlaps_body(GameManager.player):
		$Label4.show()
	else:
		$Label4.hide()
	if seventh.overlaps_body(GameManager.player):
		$Label5.show()
	else:
		$Label5.hide()
	if eighth.overlaps_body(GameManager.player):
		$Label6.show()
	else:
		$Label6.hide()
	if ninth.overlaps_body(GameManager.player):
		$Label9.show()
	else:
		$Label9.hide()
	if tenth.overlaps_body(GameManager.player):
		$Label7.show()
	else:
		$Label7.hide()
