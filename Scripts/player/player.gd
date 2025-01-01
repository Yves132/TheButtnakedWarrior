extends CharacterBody2D
class_name Player #giving this class a name so we can call it from other scripts

const FIREBALL = preload("res://Scenes/Magic/fireball.tscn") 
const DUSTWALK = preload("res://Scenes/Particles/DustWalk.tscn")
const DUSTRUN = preload("res://Scenes/Particles/DustRun.tscn")
const DUSTJUMP = preload("res://Scenes/Particles/DustJump.tscn")
const DUSTWALLJUMP = preload("res://Scenes/Particles/dustWallJump.tscn")
#const DUSTWALLSLIDE = preload("res://Scenes/Particles/DustWallSlide.tscn")#not implemented not needed
const DUSTDASH = preload("res://Scenes/Particles/DustDash.tscn")

@onready var animations = $AnimationPlayer
@onready var sprite = $PlayerNaked
@onready var weaponright = $Weaponsright
@onready var weaponleft = $Weaponsleft
@onready var weaponrightback = $WeaponsrightBack
@onready var weaponleftback = $WeaponsleftBack
@onready var Hat = $Hat
@onready var levelup = $"LevelUP!"
@onready var dodge = $"Dodged!"
@onready var leveluptimer = $Leveluptimer
@onready var dodgetimer = $DodgeTimer
@onready var crit = $"Critical!"
@onready var crittimer = $CritTimer
@onready var interact_ui = $Interact_ui
@onready var PlayerCamera = $Camera2D

var ladder_checker := false #is player on ladder
var climbing := false #is player climbing
var dead := false #is player dead
var Hit := false#is player hit? used for hit animation
var blink := 0 #used for player blinking when hit
var hurtTimer  #it's used to call hurtTimer.start() in Gamemanager.lose_health()
var HitBox#i think it's not used
var fell :=false #used to check if player fell off screen so hit animation does not play 
var magic := false #used to play magic anim
var direction #used to get player direction
#var last_jump_direction = 0
var wall_sliding := false #is player wallsliding?
var falling #i think it's not used
var resting := false
var attacking := false
var can_attack := true
var walkattack := false
var jumpattack := false
var idleattack:= false
var can_dash := true
var Playerposx : float
var Playerposy : float
var dodged := false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_spawn_particle = true
var landing = false
var regencounter = 0#used for regen effect of item



func _ready():#called when you start the program
	PlayerData.player_dic["skillpoints"] = 100
	#WorldData.world_dic["first_boss_defeated"] = false#for testing purposes
	GameManager.player = self #Assigning to the variable "player" in GameManager script this node : "Player"
	InventoryManager.set_player_reference(self)#sets reference for inventory manager
	hurtTimer = $HurtTimer
	HitBox = $HitBox
	position.x = PlayerData.player_dic["positionx"]
	position.y = PlayerData.player_dic["positiony"]
	PlayerData.player_dic["speed"] = PlayerData.speed
	PlayerData.player_dic["runspeed"] = PlayerData.runspeed
	#print(position)
	PlayerData.player_dic["mana"] = PlayerData.player_dic["max_mana"]
	PlayerData.player_dic["dashes"] = PlayerData.player_dic["max_dashes"]

func _physics_process(delta):
	#Engine.time_scale = 0.2
	#print(PlayerData.player_dic["max_mana"])
	#print(PlayerData.player_dic["mana"])
	#print(PlayerData.player_dic["magic_dmg"])
	#print(PlayerData.player_dic["melee_dmg"])
	Playerposx = position.x
	
	
	if not PlayerData.player_dic["has_spell"]:
		$"../UIManager/ManaFull".visible = false
		$"../UIManager/ManaEmpty".visible = false
	elif PlayerData.player_dic["has_spell"]:
		$"../UIManager/ManaFull".visible = true
		$"../UIManager/ManaEmpty".visible = true
	#Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta

	#Handles movement/deceleration no acceleration
			#if left_or_right:
				#if Input.is_action_pressed("run"):
					#velocity.x = left_or_right * runspeed
				#else:
					#velocity.x = left_or_right * speed
			#else:
				#velocity.x = move_toward(velocity.x, 0, speed)
	if GameManager.cutscene:
		velocity.x = 0
	if not dead:
		
		
		#print(velocity.x)
		# Get the input direction
		var left_or_right = Input.get_axis("left", "right")
		var up_or_down = Input.get_axis("up", "down")
		
		#player stops if pressing both left and right so it can play idle
		if Input.is_action_pressed("right") and Input.is_action_pressed("left"):
			velocity.x=0
		
		if Input.is_action_just_pressed("Equip Weapon") and PlayerData.player_dic["weapon_found"]:
			PlayerData.player_dic["has_weapon"] = not PlayerData.player_dic["has_weapon"]
		if Input.is_action_just_pressed("Equip Armor") and PlayerData.player_dic["hat_found"]:
			PlayerData.player_dic["has_hat"] = not PlayerData.player_dic["has_hat"]
		
		if not PlayerData.player_dic["has_weapon"]:
			weaponleft.visible = false
			weaponright.visible = false
			weaponleftback.visible = false
			weaponrightback.visible = false
		elif PlayerData.player_dic["has_weapon"] and direction == 1:
			weaponright.visible = true
			if climbing and direction == 1:
				weaponrightback.visible = true
				weaponright.visible = false
			else:
				weaponrightback.visible = false
		elif PlayerData.player_dic["has_weapon"] and direction == -1:
			weaponleft.visible = true
			if climbing and direction == -1:
				weaponleftback.visible=true
				weaponleft.visible = false
			else:
				weaponleftback.visible = false
				
		if not PlayerData.player_dic["has_hat"]:
			Hat.visible = false
		elif PlayerData.player_dic["has_hat"]:
			Hat.visible = true
		#print(has_weapon)
		#rotate sprite based on direction
		if Input.is_action_pressed("right") and not Input.is_action_pressed("left") and not wall_sliding:
			sprite.flip_h = false
			Hat.flip_h = false
			weaponleft.visible = false
			weaponleftback.visible = false
			$UNFWeaponV1.flip_h = false
			$UNFWeaponV1.offset.x = 0
			$UNFWeaponV2.flip_h = false
			$UNFWeaponV2.offset.x = 0
			$UNFWeaponV3.flip_h = false
			$UNFWeaponV3.offset.x = 0
			$UNFWeaponV4.flip_h = false
			$UNFWeaponV4.offset.x = 0
		if Input.is_action_pressed("left") and not Input.is_action_pressed("right") and not wall_sliding:
			sprite.flip_h = true
			Hat.flip_h = true
			weaponright.visible = false
			weaponrightback.visible = false
			$UNFWeaponV1.flip_h = true
			$UNFWeaponV1.offset.x = -436
			$UNFWeaponV2.flip_h = true
			$UNFWeaponV2.offset.x = -560
			$UNFWeaponV3.flip_h = true
			$UNFWeaponV3.offset.x = -700
			$UNFWeaponV4.flip_h = true
			$UNFWeaponV4.offset.x = -775
			
		if is_on_floor() and not GameManager.cutscene:#floor mechanics
			#print("walking")
			#actual_speed = speed
			 ##Handle jump.
			if Input.is_action_just_pressed("jump"):
				velocity.y = PlayerData.player_dic["jump_height"]
			
			##handle the acceleration/deceleration.
			if Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
				if Input.is_action_pressed("run"):
					velocity.x = move_toward(velocity.x, PlayerData.player_dic["runspeed"], 52)
				else:
					velocity.x = move_toward(velocity.x, PlayerData.player_dic["speed"], 40)
			elif Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
				if Input.is_action_pressed("run"):
					velocity.x = move_toward(velocity.x, -PlayerData.player_dic["runspeed"], 52)
				else:
					velocity.x = move_toward(velocity.x, -PlayerData.player_dic["speed"], 40)
			else:
				velocity.x = move_toward(velocity.x, 0, 40)
			
			
			#PARTICLES
			if Input.is_action_pressed("right") and Input.is_action_pressed("left"):
				can_spawn_particle = false
			if Input.is_action_just_released("right") or Input.is_action_just_released("left") or Input.is_action_just_released("run"):
				can_spawn_particle = true
			if ((Input.is_action_pressed("right") or Input.is_action_pressed("left")) and can_spawn_particle == true) and not Input.is_action_pressed("run"):
				can_spawn_particle = false
				$DustTimerW.start()
				dust_walk()
			if ((Input.is_action_pressed("right") or Input.is_action_pressed("left")) and can_spawn_particle == true) and Input.is_action_pressed("run"):
				can_spawn_particle = false
				$DustTimerR.start()
				dust_run()
			if Input.is_action_just_pressed("jump"):
				dust_jump()
			if landing == true:
				dust_jump()
				landing = false
			if Input.is_action_just_pressed("Dash") and can_dash and PlayerData.player_dic["dashes"] > 0 and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
				dust_dash()
			
			fire()
			melee()
			dash()
			
			if should_climb_ladder():
				velocity.y = up_or_down * PlayerData.player_dic["speed"]


		if  not is_on_floor() and not climbing and not wall_sliding:#falling mechanics
			landing = true
			#print(should_climb_ladder())
			#print("falling")
			if should_wall_slide():
				wall_sliding = true
				$UNFWeaponV1.visible = false
				$UNFWeaponV2.visible = false
				$UNFWeaponV3.visible = false
				$UNFWeaponV4.visible = false
			if should_climb_ladder():
				climbing = true
				$UNFWeaponV1.visible = false
				$UNFWeaponV2.visible = false
				$UNFWeaponV3.visible = false
				$UNFWeaponV4.visible = false
				
			if Input.is_action_pressed("right"):#accelerates by 40 each frame
					velocity.x = move_toward(velocity.x, PlayerData.player_dic["speed"], 40) if velocity.x < PlayerData.player_dic["speed"] else move_toward(velocity.x, PlayerData.player_dic["speed"], 10)#if i was running decelerate to speed by 10 each frame
			elif Input.is_action_pressed("left"):
					velocity.x = move_toward(velocity.x, -PlayerData.player_dic["speed"], 40) if velocity.x > -PlayerData.player_dic["speed"] else move_toward(velocity.x, -PlayerData.player_dic["speed"], 10)#if i was running decelerate to speed by 10 each frame
			else:
				velocity.x = move_toward(velocity.x, 0, 100)
			velocity.y += gravity * delta
			fire()
			melee()

		if climbing: #climbing mechanics
			#print("climbing")
			## Handle jump.
			if is_on_floor():
				climbing = false
			#print("climbing")
			velocity.y = up_or_down * PlayerData.player_dic["speed"]
			
			if Input.is_action_just_pressed("jump"):
				velocity.y = PlayerData.player_dic["jump_height"]
				#print(velocity.y)
				climbing = false
			if ladder_checker == false:
				climbing = false
			if left_or_right:
				velocity.x = left_or_right * PlayerData.player_dic["speed"]/2
			else:
				velocity.x = move_toward(velocity.x, 0, PlayerData.player_dic["speed"])
			#print(ladder_checker)
			
		if wall_sliding:#wall sliding mechanics
			#print("wall sliding")
			if should_climb_ladder():
				wall_sliding = false
				climbing = true
			if not should_wall_slide():
				wall_sliding = false
				
			if Input.is_action_pressed("jump") and (Input.is_action_pressed("right") and direction == -1) and not Input.is_action_pressed("left"):
				#print("jump?")
				velocity.y = PlayerData.player_dic["jump_height"]
				velocity.x = move_toward(velocity.x, PlayerData.player_dic["speed"], 40) 
				#PARTICLES
				dust_wall_jump()
			elif Input.is_action_pressed("jump") and (Input.is_action_pressed("left") and direction ==1) and not Input.is_action_pressed("right"):
				velocity.y = PlayerData.player_dic["jump_height"]
				velocity.x = move_toward(velocity.x, -PlayerData.player_dic["speed"], 40) 
				#PARTICLES
				dust_wall_jump()
			elif Input.is_action_pressed("down"):
				velocity.y = PlayerData.player_dic["speed"]
				#PARTICLES
				#dust_wall_slide()
			else:
				#print("here?")
				velocity.y = 2 * gravity * delta
			
			if Input.is_action_pressed("right"):#accelerates by 40 each frame
				velocity.x = move_toward(velocity.x, PlayerData.player_dic["speed"], 40) 
			elif Input.is_action_pressed("left"):
				velocity.x = move_toward(velocity.x, -PlayerData.player_dic["speed"], 40) 
				

		
		
	if dead:
		velocity.x = 0
		velocity.y = 0
	#print(is_on_floor())
	set_direction()
	GameManager.uimanager.Update_mana(PlayerData.player_dic["mana"])
	GameManager.uimanager.Update_dashes(PlayerData.player_dic["dashes"])
	animation_handler()
	move_and_slide()
	
	
func set_direction():
	direction = 1 if not $PlayerNaked.flip_h else -1
	$WallChecker.rotation_degrees = 90 * -direction
	$Weapon/CollisionShape2D.position.x = $Weapon/CollisionShape2D.position.x * direction
	
		
func is_near_wall():
	return $WallChecker.is_colliding()

func should_wall_slide() -> bool:
	if is_near_wall() and not is_on_floor():
		return true
	else:
		return false

func should_climb_ladder() -> bool:
	if ladder_checker and (Input.is_action_pressed("down") or Input.is_action_pressed("up")):
		return true
	else:
		return false

func animation_handler():#animations
	
	if velocity.x == 0 and is_on_floor() and not dead and not Hit and not resting:#if not moving play idle animation
		if not magic and not attacking and not Hit:
			animations.play("Idle")
			#print(attacking)
		elif magic and not attacking and not Hit:
			animations.play("MagicIdle")
		elif attacking and not magic and not walkattack and not jumpattack and not Hit:
			animations.play("IdleMelee")
			idleattack = true
			#print("isthis?", walkattack)
			
	if (Input.is_action_pressed("right") or Input.is_action_pressed("left")) and is_on_floor() and not dead and not Hit and not Input.is_action_pressed("run") and velocity.x !=0:#If moving play walk animation
		if not magic and not attacking:
			animations.play("Walk")
		elif magic and not attacking and not Hit:
			animations.play("MagicWalk")
		elif attacking and not magic and not jumpattack and not idleattack and not Hit:
			#print("doesitwork?")
			animations.play("MeleeWalk")
			walkattack = true
			#print(walkattack)
		resting = false
	if (Input.is_action_pressed("right") or Input.is_action_pressed("left")) and is_on_floor() and not dead and not Hit and Input.is_action_pressed("run") and velocity.x !=0:#If moving play run animation
		if not magic and not attacking:
			animations.play("Run")
		elif magic and not attacking and not Hit:
			animations.play("MagicWalk")
		elif attacking and not magic and not jumpattack and not idleattack and not Hit:
			#print("doesitwork?")
			animations.play("MeleeWalk")
			walkattack = true
		resting = false
	if Input.is_action_just_pressed("jump") and not dead and not Hit and not GameManager.cutscene:#if jump button is pressed play jump animation
		if not magic and not attacking:
			#print("doesitwork?jump")
			animations.play("Jump")
		elif magic and not attacking:
			#print("doesitwork?Magic")
			animations.play("MagicJump")
		elif attacking and not magic and not walkattack and not idleattack:
			#print("doesitwork?")
			animations.play("MeleeJump")
			jumpattack = true
		resting = false
	if not is_on_floor() and not climbing and not dead and not Hit:#if player is falling play fall animation
		#print(climbing)
		if not magic and not attacking:
			animations.play("Fall")
		elif magic and not attacking:
			animations.play("MagicJump")
		elif attacking and not magic and not walkattack and not idleattack and not climbing:
			#print("doesitwork?")
			animations.play("MeleeJump")
			jumpattack = true
			
	if climbing and (Input.is_action_pressed("down") or Input.is_action_pressed("up")) and not dead and not Hit:#only if player climbing play climb animation
		animations.play("Climb")
	elif climbing and not (Input.is_action_pressed("down") or Input.is_action_pressed("up")) and not dead and not Hit:#stops animation on ladder when i stop moving
		animations.stop()
		
	if wall_sliding and not dead:
		attacking = false
		jumpattack = false
		$Weapon.set_collision_layer_value(11, false)
		#print(jumpattack)
		animations.play("WallSlide")
		
	if dead:#plays death animation
		animations.play("Death")
		PlayerCamera.zoom.x = 4
		PlayerCamera.zoom.y = 4
	if Hit and not dead and not fell:
		animations.play("Hit")
		attacking = false
		jumpattack = false
		$Weapon.set_collision_layer_value(11, false)
	if resting:
		animations.play("resting")

func melee():
	
		if not resting:
			if blink == 0:
				if Input.is_action_just_pressed("Melee") and can_attack and PlayerData.player_dic["has_weapon"]:
					if randi() %100 +1 < PlayerData.player_dic["crit_chance"]:
						GameManager.crit = true
					#print("click")
					#print(jumpattack)
					can_attack = false
					$WeaponSpeed.start()
					attacking = true
					$Weapon.set_collision_layer_value(11, true)


func fire():
	if not resting:
		if PlayerData.player_dic["has_spell"]:
			if blink == 0:
				if Input.is_action_just_pressed("Magic") and not is_near_wall() and PlayerData.player_dic["mana"] > 0:
					magic = true
					#var direction = 1 if not $Sprite2D.flip_h else -1
					var Fire = FIREBALL.instantiate()
					Fire.direction = direction
					get_parent().add_child(Fire)
					Fire.position.x = position.x + 30 * direction
					Fire.position.y = position.y 
					PlayerData.player_dic["mana"] -= 1
					$ManaRegenTimer.start()
					#print (mana)
		
func dash():
	if PlayerData.player_dic["dashes"] > 0:
		if can_dash and Input.is_action_just_pressed("Dash") and Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
			velocity.x = PlayerData.player_dic["dash_speed"]
			can_dash = false
			PlayerData.player_dic["dashes"] -=1
			$DashTimer.start()
			$DashRegenTimer.start()
			set_collision_layer_value(1,false)
			HitBox.set_collision_layer_value(1,false)
			$DashIframes.start()
			set_modulate(Color(1,1,1,0.8))
		elif can_dash and Input.is_action_just_pressed("Dash") and Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
			velocity.x = -PlayerData.player_dic["dash_speed"]
			can_dash = false
			PlayerData.player_dic["dashes"] -=1
			$DashTimer.start()
			$DashRegenTimer.start()
			set_collision_layer_value(1,false)
			HitBox.set_collision_layer_value(1,false)
			$DashIframes.start()
			set_modulate(Color(1,1,1,0.8))
				
func regen_health():
	$Healthregen.start()
		
func dust_walk():
	var DustWalk = DUSTWALK.instantiate()
	if Input.is_action_pressed("right"):
		DustWalk.direction = 1
	if Input.is_action_pressed("left"):
		DustWalk.direction = -1
	DustWalk.global_position = $DustWalk.global_position
	get_parent().add_child(DustWalk)

func dust_run():
	var DustRun = DUSTRUN.instantiate()
	if Input.is_action_pressed("right"):
		DustRun.direction = 1
	if Input.is_action_pressed("left"):
		DustRun.direction = -1
	DustRun.global_position = $DustWalk.global_position
	get_parent().add_child(DustRun)

func dust_jump():
	var DustJump = DUSTJUMP.instantiate()
	DustJump.global_position = $DustWalk.global_position
	get_parent().add_child(DustJump)
	
func dust_wall_jump():
	var DustWallJump = DUSTWALLJUMP.instantiate()
	if Input.is_action_pressed("right"):
		DustWallJump.direction = 1
	if Input.is_action_pressed("left"):
		DustWallJump.direction = -1
	DustWallJump.global_position = $DustWalk.global_position
	get_parent().add_child(DustWallJump)

func dust_dash():
	var DustDash = DUSTDASH.instantiate()
	if Input.is_action_pressed("right"):
		DustDash.direction = 1
	if Input.is_action_pressed("left"):
		DustDash.direction = -1
	DustDash.global_position = $DustDash.global_position
	get_parent().add_child(DustDash)
#func dust_wall_slide():#not implemented, not needed
	#var DustWallSlide = DUSTWALLSLIDE.instantiate()
	#if Input.is_action_pressed("right"):
	#	DustWallSlide.direction = 1
	#if Input.is_action_pressed("left"):
	#	DustWallSlide.direction = -1
	#DustWallSlide.global_position = $DustWalk.global_position
	#get_parent().add_child(DustWallSlide)

func Die(): #player has reached 0 health
	dead = true
	#animation_handler()#used to play death animation
	
	#used to apply the effect of items, based on effect description
func apply_item_effect(item):
	match  item["effect"]:
		"Heal 1 HP": 
			if PlayerData.player_dic["health"] < PlayerData.player_dic["max_health"]:
				PlayerData.player_dic["health"] += 1
				GameManager.uimanager.Update_health()
				InventoryManager.remove_item(item["type"],item["effect"])
				#InventoryManager.remove_hotbar_item(item["type"], item["effect"])
			else:
				$"MaxHealth!".show()
				$MaxHealthTimer.start()
		"SPD+(20)":
			$BuffTimer.start()
			PlayerData.player_dic["speed"] += 20
			PlayerData.player_dic["runspeed"] += 20
			InventoryManager.remove_item(item["type"],item["effect"])
		"Regen Health":
			if PlayerData.player_dic["health"] < PlayerData.player_dic["max_health"]:
				PlayerData.player_dic["health"] += 1
				regen_health()
				GameManager.uimanager.Update_health()
				InventoryManager.remove_item(item["type"],item["effect"])
			else:
				$"MaxHealth!".show()
				$MaxHealthTimer.start()
		#"Slot Boost":
			#InventoryManager.increase_inventory_size(5)
			#InventoryManager.remove_item(item["type"],item["effect"])
		_: 
			print("There is no effect for this item")
	
func _on_ladder_checker_body_entered(body):#signal for detecting "on ladders"
	ladder_checker = true

func _on_ladder_checker_body_exited(body):#signal for detecting "not on ladder"
	ladder_checker = false
	#print("this is the problem")

func _on_animation_player_animation_finished(anim_name):#signal for waiting end of death animation
	#Run Respawn_Player() func in GameManager script after death animation
	#CAREFUL THIS WORKS ONLY BECAUSE ONLY DEATH ANIMATION ISN'T LOOPING
	
	if anim_name == "Death":
		GameManager.deathscreen()
	
	if anim_name == "MagicIdle" or anim_name == "MagicWalk" or anim_name == "MagicJump":
		magic = false
		
	if anim_name == "IdleMelee" or anim_name == "MeleeJump" or anim_name == "MeleeWalk":
		attacking = false
		walkattack = false
		jumpattack = false
		idleattack = false
		$Weapon.set_collision_layer_value(11, false)
	
	if anim_name == "Hit":
		attacking = false
		walkattack = false
		#$Weapon.set_collision_layer_value(11, false)

func _on_fallzone_body_entered(body):
	if body is Player:
		fell = true
		GameManager.lose_health(1)#lose 1 health
		if PlayerData.player_dic["health"] > 0:
			GameManager.Respawn_Player()#respawn player
		set_process_input(false)
		if PlayerData.player_dic["health"] == 0:
			GameManager.deathscreen()
#func _on_change_scene_area_entered(area):
	#if area.get_parent() is Player:
		#PlayerData.player_dic["positionx"] = PlayerData.positionx
		#PlayerData.player_dic["positiony"] = PlayerData.positiony
		#get_tree().change_scene_to_file("res://Scenes/WorldScenes/levelTwo.tscn")

func _on_hurt_timer_timeout():
	if not dead:
		Hit=false
		blink -= 1
		if blink == 0:
			hurtTimer.stop()
			set_modulate(Color(1,1,1,1))
			set_collision_layer_value(1,true)
			HitBox.set_collision_layer_value(1,true)
		else:
			set_modulate(Color(5,5,5,0.9) if blink % 2 == 0 else Color(1,0.3,0.3,0.4))# % è il modulo 2, se blink/2 ha resto 0 (è pari) player è bianco, altrimenti è rosso trasparente
		
func bounce():
	velocity.y = PlayerData.player_dic["jump_height"] * 0.7

func Hurt(posx):
	if not dodged:
		if not dead:
			velocity.y = PlayerData.player_dic["jump_height"] * 0.7
			if posx > position.x:
				velocity.x = -750
			if posx < position.x:
				velocity.x = 750
			set_modulate(Color(5,5,5,0.9))
			blink = 4
			#Input.action_release("left")
			#Input.action_release("right")
			set_collision_layer_value(1,false)
			HitBox.set_collision_layer_value(1,false)
			GameManager.frame_freeze(0,0.1)
	dodged = false

func _on_mana_regen_timer_timeout():
	if PlayerData.player_dic["mana"] < PlayerData.player_dic["max_mana"]:
		PlayerData.player_dic["mana"]+=1
	elif PlayerData.player_dic["mana"] == PlayerData.player_dic["max_mana"]:
		$ManaRegenTimer.stop()
	#print (GameManager.mana)


func _on_weapon_speed_timeout():
	#print("Weapon speed timer")
	can_attack = true
	GameManager.crit = false


func _on_dash_timer_timeout():
	can_dash = true
	

func _on_dash_iframes_timeout():
	set_collision_layer_value(1,true)
	HitBox.set_collision_layer_value(1,true)
	set_modulate(Color(1,1,1,1))


func _on_dash_regen_timer_timeout():
	if PlayerData.player_dic["dashes"] < PlayerData.player_dic["max_dashes"]:
		PlayerData.player_dic["dashes"] +=1
	elif PlayerData.player_dic["dashes"] == PlayerData.player_dic["max_dashes"]:
		$DashRegenTimer.stop()


func _on_leveluptimer_timeout():
	levelup.hide()


func _on_dodge_timer_timeout():
	dodge.hide()


func _on_crit_timer_timeout():
	crit.hide()



func _on_dust_timer_timeout():
	can_spawn_particle = true


func _on_dust_timer_r_timeout():
	can_spawn_particle = true



func _on_max_health_timer_timeout():
	$"MaxHealth!".hide()


func _on_buff_timer_timeout():
	PlayerData.player_dic["speed"] = PlayerData.speed
	PlayerData.player_dic["runspeed"] = PlayerData.runspeed


func _on_healthregen_timeout():
	if PlayerData.player_dic["health"] < PlayerData.player_dic["max_health"]:
		PlayerData.player_dic["health"] += 1
		GameManager.uimanager.Update_health()
	regencounter +=1
	if regencounter == 2:
		$Healthregen.stop()
