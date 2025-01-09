extends CharacterBody2D


const COINS = preload("res://Scenes/Coins/CoinDrops.tscn")
const TROLLBLOOD = preload("res://Scenes/Inventory/InventoryItem/inventory_item.tscn")
const BLOOD = preload("res://Scenes/Particles/big_blood.tscn")
const EXPLOSION = preload("res://Scenes/Particles/explosion_fire.tscn")


@export var max_health = 10
@export var speed = 100
@export var damage = 2
@export var direction = -1

@onready var current_health = max_health
@onready var myposx = position.x
@onready var dead = false#used to determoiine if troll dead
@onready var burnt = false#used to determine death anim
@onready var sliced = false#used to determine death anim
@onready var animations = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var dropsprite = $Drop
@onready var hit = false#used to prevent player sword to hit 2 times
@onready var attack = false#used to determine when troll is attacking
@onready var counter = 0#used to determine when to give the player breath

func _ready():
	if WorldData.world_dic["first_boss_defeated"]:#this prevents it from spawning if it is already killed
		queue_free()


func _physics_process(delta):
	myposx = position.x
	if not dead and GameManager.BossBattleStart:#this variable is set in gamemanager script when cutscene ends
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
		if attack:#if attacking stop
			velocity.x = 0
			$ArmR.set_collision_mask_value(1, true)
		if not attack:
			$ArmR.set_collision_mask_value(1, false)
		if counter == 3:#if it made 3 attacks stop
			velocity.x = 0
		
		
		hit_management()#used to change status of hit variable to prevent player from hitting twice in one swing
		if not attack:#when it attacks it is blocked in attack direction
			chase_player(myposx)
		move_and_slide()
		#movement finish
		#animations when fighting
		animation_handler()
		
	#cutscene animations
	if GameManager.cutscene :
		if direction == 1: 
			sprite.flip_h = false
		if direction == -1:
			sprite.flip_h = true
		animation_handler()
	#cutscene animations
	
	#healthbar management start
	if GameManager.BossBattleStart:#to make sure healthbar shows only when battle starts
		$HealthBar.show()
		$HealthBar/Name.show()
	else:
		$HealthBar.hide()
		$HealthBar/Name.show()
	
	$HealthBar.update_health(max_health, current_health)
	#healthbar management finish
	
	
func animation_handler():
	if GameManager.cutscene == true:#cutscene animation WAAAAAGH
		animations.play("WAAAAGH")
	if (is_on_wall() and not dead) or counter == 3:#if near wall or when attacking 3 times
		animations.play("WAAAAGH",-1,2.0)#play it double speed
	if velocity.x != 0 and not dead:
		animations.play("Walk")#if moving play walk animation
	if dead and burnt:
		animations.play("Burn")
	if dead and sliced:
		animations.play("sliced")
	if attack and not dead and direction == 1 and counter != 3:
		animations.play("ATKR")
	if attack and not dead and direction == -1 and counter != 3:
		animations.play("ATKL")

func chase_player(posx):
	if posx < GameManager.player.Playerposx:
		direction = 1
		$ArmR/CollisionShape2D.position.x = $ArmR/CollisionShape2D.position.x * direction
	if posx > GameManager.player.Playerposx:
		direction = -1
		$ArmR/CollisionShape2D.position.x = $ArmR/CollisionShape2D.position.x * direction
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
		if sliced:
			bleed()
		$HitBox.set_collision_mask_value(1, false)
		$DeathTimer.start()
	animation_handler()

func _on_hit_box_body_entered(body):#detecting if troll hit player with body
	if body is Player and GameManager.player.can_dash == true:
		if PlayerData.player_dic["health"] < damage:#this is done to prevent visual bugs on playerhealth
			damage = PlayerData.player_dic["health"]#setting damage equal to playerhealth
		GameManager.lose_health(damage)#call function in globalscript gamemanager to make player lose health
		GameManager.player.Hurt(myposx)#call function in player script through gamemanager reference to hurt player
		if PlayerData.player_dic["health"] == 0:#if player dies
			GameManager.BossBattleStart = false#we reset this variable to prevent the boss from wandering when not in battle
		

func _on_hit_detector_body_entered(body):#detecting if player hit with fireball
	if body is Fireball:
		burnt = true#it is used to determine cause of death for troll in losehealth func
		lose_health(PlayerData.player_dic["magic_dmg"])#troll loses health equal to magic damage in playerdictionary
		#GameManager.frame_freeze(0,frame_freeze_time)
		spawn_explosion(body.position)
		body.queue_free()#delete fireball


func _on_hit_detector_area_entered(area):#detecting if player hit with sword
	if area.get_parent() is Player and not hit:
		hit = true
		sliced = true#it is used to determine cause of death for troll in losehealth func
		lose_health(PlayerData.player_dic["melee_dmg"])#troll loses health equal to melee damage in playerdictionary
		#GameManager.frame_freeze(0,frame_freeze_time)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "WAAAAGH":#this determines the end of the cutscene and the start of the battle
		GameManager.cutscene = false
		GameManager.BossBattleStart = true
		counter = 0
	if anim_name == "ATKR" or anim_name == "ATKL":
		attack = false
		counter += 1
		#print(counter)

func spawn_coin():
	var coin = COINS.instantiate()#instantiate coin scene
	coin.position = position#set position to troll's position
	get_parent().add_child(coin)#spawn it
	
func spawn_blood():
	var trollblood = TROLLBLOOD.instantiate()
	trollblood.position.x = position.x
	trollblood.position.y = position.y
	trollblood.item_texture = dropsprite.texture
	trollblood.item_name = "Troll's Blood"
	trollblood.item_effect = "Regen Health"
	trollblood.item_type = "Consumable"
	trollblood.cost = 5
	get_parent().add_child(trollblood)
	
func bleed():
	var blood = BLOOD.instantiate()
	blood.position = position
	get_parent().add_child(blood)
	

func spawn_explosion(pos):
	var explosion = EXPLOSION.instantiate()
	explosion.position = pos
	get_parent().add_child(explosion)

func _on_death_timer_timeout():
	var coinspawntrue = randi() %20 + 5#random number of coins to spawn
	var bloodspawnchance = randi() %100 +1 #chance to spawn blood
	var coincount = 0#coins already spawned
	while coincount < coinspawntrue:
		spawn_coin()
		coincount += 1
	if bloodspawnchance <= 50:#100 for testing purposes, set it to 50 when done
		spawn_blood()
	GameManager.gain_xp(5)
	queue_free()
	GameManager.BossBattleStart = false#we set this variable in gamemanager script to false, so bossbattle logic stops
	GameManager.cutscene = true
	WorldData.world_dic["first_boss_defeated"] = true#we set this so even on loadgame the boss does not spawn
	GameManager.uimanager.saving_icon.show()
	GameManager.uimanager.saving_icon.play("Saving")
	SaveManager.save_game()#we save so player doesn't lose xp gained and stuff
	

func _on_at_karea_body_entered(body):
	attack = true#if player in range begin attack


func _on_arm_r_body_entered(body):
	if body is Player:
		if PlayerData.player_dic["health"] < damage:#this is done to prevent visual bugs on playerhealth
			damage = PlayerData.player_dic["health"]#setting damage equal to playerhealth
		GameManager.lose_health(damage)#call function in globalscript gamemanager to make player lose health
		GameManager.player.Hurt(myposx)#call function in player script through gamemanager reference to hurt player
		if PlayerData.player_dic["health"] == 0:#if player dies
			GameManager.BossBattleStart = false#we reset this variable to prevent the boss from wandering when not in battle
