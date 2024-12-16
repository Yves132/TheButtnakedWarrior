extends CharacterBody2D



@export var max_health = 10
@export var speed = 75
@export var damage = 2
@export var direction = -1

@onready var current_health = max_health
@onready var myposx = position.x
@onready var dead = false
@onready var burnt = false
@onready var sliced = false
@onready var animations = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hit = false#used to prevent player sword to hit 2 times


func _physics_process(delta):
	myposx = position.x
	if not dead and GameManager.BossBattleStart:
		#movement start
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if direction == 1:#right movement
			velocity.x = direction * speed
			sprite.flip_h = false
		if direction == -1: #left movement
			velocity.x = direction * speed
			sprite.flip_h = true
		
		hit_management()#used to change status of hit variable to prevent player from hitting twice in one swing
		chase_player(myposx)
		move_and_slide()
		#movement finish
		#animations when fighting
		animation_handler()
		
	#cutscene animations
	if GameManager.cutscene :
		animation_handler()
	#cutscene animations
	
	#healthbar management start
	if GameManager.BossBattleStart:#to make sure healthbar shows only when battle starts
		$HealthBar.show()
	else:
		$HealthBar.hide()
	
	$HealthBar.update_health(max_health, current_health)
	#healthbar management finish
	
	
func animation_handler():
	if GameManager.cutscene == true:#cutscene animation WAAAAAGH
		animations.play("WAAAAGH")

func chase_player(posx):
	if posx < GameManager.player.Playerposx:
		direction = 1
	if posx > GameManager.player.Playerposx:
		direction = -1

func hit_management():
		if GameManager.player.can_attack:
			hit = false
		
func lose_health(dmg):
	current_health -= dmg#troll loses health equal to player damage
	#print(current_health)
	if current_health > 0:#if is not dead we reset the causes of death
		burnt = false
		sliced = false
	if (sliced or burnt) and current_health <= 0:#if it is dead we use causes of death in animation handler to show correct animation
		dead = true
	
func _on_hit_box_body_entered(body):#detecting if troll hit player with body
	if body is Player:
		if PlayerData.player_dic["health"] < damage:#this is done to prevent visual bugs on playerhealth
			damage = PlayerData.player_dic["health"]#setting damage equal to playerhealth
		GameManager.lose_health(damage)#call function in globalscript gamemanager to make player lose health
		GameManager.player.Hurt(myposx)#call function in player script through gamemanager reference to hurt player
		GameManager.frame_freeze(0.2,0.1)
		if PlayerData.player_dic["health"] == 0:#if player dies
			GameManager.BossBattleStart = false#we reset this variable to prevent the boss from wandering when not in battle
		

func _on_hit_detector_body_entered(body):#detecting if player hit with fireball
	if body is Fireball:
		burnt = true#it is used to determine cause of death for troll in losehealth func
		lose_health(PlayerData.player_dic["magic_dmg"])#troll loses health equal to magic damage in playerdictionary
		GameManager.frame_freeze(0.1,0.3)
		body.queue_free()#delete fireball


func _on_hit_detector_area_entered(area):#detecting if player hit with sword
	if area.get_parent() is Player and not hit:
		hit = true
		sliced = true#it is used to determine cause of death for troll in losehealth func
		lose_health(PlayerData.player_dic["melee_dmg"])#troll loses health equal to melee damage in playerdictionary
		GameManager.frame_freeze(0.1,0.3)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "WAAAAGH":#this determines the end of the cutscene and the start of the battle
		GameManager.cutscene = false
		GameManager.BossBattleStart = true


func _on_attack_area_area_entered(area):
	pass # Replace with function body.
