extends CharacterBody2D

const COINS = preload("res://Scenes/Coins/CoinDrops.tscn")
const WINGS = preload("res://Scenes/Inventory/InventoryItem/inventory_item.tscn")
const BLOOD = preload("res://Scenes/Particles/blood.tscn")
const EXPLOSION = preload("res://Scenes/Particles/explosion_fire.tscn")


@export var speed = 75
@export var direction = 1
@export var rangeSX = - 100
@export var rangeDX = + 100
@export var damage = 1
@export var max_health = 1


@onready var current_health = max_health
@onready var initialpositionx = position.x#used to determine x range of bat
@onready var initialpositiony = position.y#used to determine y range of bat
@onready var spotted = false#used to determine whether player is underneath bat
@onready var done = false#used to determine when the bat has touched floor or player
@onready var myposx = position.x#passed to hurt function in player script
@onready var sprite = $AnimatedSprite2D
@onready var dropsprite = $Drop
@onready var sliced = false#used to determine which death anim to play
@onready var burnt = false#used to determine which death anim to play
@onready var dead = false#used to determine whther the bat is dead
@onready var hit = false#used to prevent the player sword from hitting 2 times


func _physics_process(delta):
	myposx = position.x
	#movement start
	if not dead:
		if direction == 1 or direction == -1:#this tells the bat to go left or right based on direction
			velocity.x = direction * speed
			
		if position.x >= (initialpositionx + rangeDX):#this tells the bat to stay in range and turn around once he's reached max range
			direction = -1
			sprite.flip_h = true
		if position.x <= (initialpositionx + rangeSX):#this tells the bat to stay in range and turn around once he's reached max range
			direction = 1
			sprite.flip_h = false

		if spotted:#this is given by player entering spotbox of bat
			velocity += get_gravity() * delta * 2#try to attack player by plunging on his head
			#print(velocity)
			
		if position.y <= initialpositiony and not done:#if bat has risen at least to the initial height
			velocity.y = 0#stop vertical movement
			done = true#it's done
			
		if is_on_floor():#if touches floor or player, stop going down, start to go up
			velocity.y -= speed * 2.5#rise again and preapre for a second attack
			spotted = false
			done = false
		
		hit_management()
		#animations when alive
		animation_handler()
		
		
		
	if dead:
		if not is_on_floor():#if bat dies it plunges to the floor
			velocity += get_gravity() * delta * 2
		if is_on_floor():#used to stop the bat from gliding on floor when dead
			velocity.x = 0
		#movement finish
	
	#healthbar start
	$HealthBar.update_health(max_health,current_health)
	#healthbar finish
	
	
	move_and_slide()

func animation_handler():
	if not dead and not spotted and not dead:
		sprite.play("Fly")
	if spotted and not dead:
		sprite.play("Plunging")
	if sliced and dead:
		sprite.play("Sliced")
	if burnt and dead:
		sprite.play("Burnt")

func hit_management():
	if GameManager.player.can_attack:
			hit = false

func lose_health(dmg):
	current_health -= dmg#lose health based on player damage
	GameManager.frame_freeze(0, 0.1)
	if (sliced or burnt) and current_health <= 0:#if dead by sword
		dead = true
		$DeathTimer.start()#used to allow the animation to play
		$SpotBox.set_collision_mask_value(1, false)#set to false so cannot spot player when dead
		$HitBox.set_collision_mask_value(1, false)#set to false so cannot hurt player when dead
		animation_handler()#animations when dead

func _on_spot_box_body_entered(body):#this is used to determine if the player is spotted by the bat
	if body is Player:#if player eneters spotbox area
		spotted = true


func _on_hit_box_body_entered(body):#this is used to determine if bat hit the player
	if body is Player:
		#GameManager.frame_freeze(0, 0.2)
		GameManager.lose_health(damage)#calls lose health function for player in gamemanager script
		GameManager.player.Hurt(myposx)#calls hurt function in player script, used to determine player blinking and immunity


func _on_hit_detector_area_entered(area):#this is used to determine if the player hit the bat with sword
	if area.get_parent() is Player and not hit:
		hit = true
		sliced = true
		bleed()
		lose_health(PlayerData.player_dic["melee_dmg"])#bat loses helath equal to player melee dmg, stored in playerdata playerdictionary


func _on_hit_detector_body_entered(body):#this is used to determine if the player hit the bat with fireball
	if body is Fireball:
		burnt = true
		lose_health(PlayerData.player_dic["magic_dmg"])#bat loses helath equal to player magic dmg, stored in playerdata playerdictionary
		spawn_explosion()
		body.queue_free()#delete fireball

func spawn_coin():
	var coin = COINS.instantiate()#instantiate the scene of the coin
	coin.position = position#set it's position to bat's position
	get_parent().add_child(coin)#spawn it

func spawn_wing():#spawn wing which increases playerspeed 
	var wing = WINGS.instantiate()
	wing.position.x = position.x
	wing.position.y = position.y
	wing.item_texture = dropsprite.texture
	wing.item_name = "Bat Wing"
	wing.item_effect = "SPD+(20)"
	wing.item_type = "Consumable"
	wing.cost = 3
	get_parent().add_child(wing)

func bleed():
	var blood = BLOOD.instantiate()
	blood.position = position
	get_parent().add_child(blood)

func spawn_explosion():
	var explosion = EXPLOSION.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)

func _on_death_timer_timeout():
	var coinspawntrue = randi() % 3 + 1#random number of coins which spawn
	var wingspawnchance = randi() % 100 +1
	var counter = 0#how many coins have spawned
	if wingspawnchance <= 30:
		spawn_wing()
	while counter < coinspawntrue:
		spawn_coin()
		counter += 1
	queue_free()#delete bat
	GameManager.gain_xp(1)#calls a function in gamemanager script that gains xp to the player
