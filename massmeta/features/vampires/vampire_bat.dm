/mob/living/simple_animal/hostile/vampire_bat
	name = "vampire bat"
	desc = "A bat that sucks blood. Keep away from medical bays."
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	turns_per_move = 1
	speak_chance = 0
	maxHealth = 20
	health = 20
	speed = 0
	melee_damage_lower = 5
	melee_damage_upper = 7
	butcher_results = list(/obj/item/food/meat/slab = 1)
	pass_flags = PASSTABLE
	faction = list("hostile", "vampire")
	attack_sound = 'sound/weapons/bite.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	mob_size = MOB_SIZE_TINY
	movement_type = FLYING
	speak_emote = list("squeaks")

	var/mob/living/controller


	//Space bats need no air to fly in.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/vampire_bat/death()
	if(isliving(controller))
		controller.forceMove(loc)
		mind.transfer_to(controller)
		controller.status_flags &= ~GODMODE
		controller.Knockdown(120)
		controller.adjustBruteLoss(20)
		to_chat(controller, span_userdanger("The force of being exiled from your bat form painfully throws you to the ground!"))
		qdel()
	. = ..()
