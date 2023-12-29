/atom/movable/screen/fullscreen/blood_tracker
	layer = BELOW_MOB_LAYER

/datum/status_effect/miami
	id = "miami"
	tick_interval = 2
	alert_type = /atom/movable/screen/alert/status_effect/miami
	var/atom/cached_thrown_object
	var/atom/movable/plane_master_controller/cached_game_plane_master_controller

	var/elapsed_ticks = 0

/datum/status_effect/miami/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_INTERACTED_WITH_DOOR, PROC_REF(bust_open))
	RegisterSignal(owner, COMSIG_CARBON_THROW, PROC_REF(throw_relay))
	RegisterSignal(owner, COMSIG_MOB_ITEM_AFTERATTACK, PROC_REF(basically_curbstomp))
	RegisterSignal(owner.reagents, COMSIG_REAGENTS_ADD_REAGENT, PROC_REF(react_to_meds))

	cached_game_plane_master_controller = owner.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	cached_game_plane_master_controller.add_filter("miami_blur",2,angular_blur_filter(0,0,0.25))

/datum/status_effect/miami/tick()
	. = ..()
	elapsed_ticks++
	cached_game_plane_master_controller.remove_filter("miami")
	var/list/color_matrix = list(rgb(max(sin(elapsed_ticks)*220,120),0,0) , rgb(0,max(sin(elapsed_ticks + 120)*220,120),0) , rgb(0,0,max(sin(elapsed_ticks - 120)*220,120)))
	cached_game_plane_master_controller.add_filter("miami",1,color_matrix_filter(color_matrix))
	//похуй
	//owner.hallucination = min(owner.hallucination + 1 , 12)

/datum/status_effect/miami/on_remove()
	cached_game_plane_master_controller.remove_filter("miami_blur")
	cached_game_plane_master_controller.remove_filter("miami")
	SEND_SIGNAL(owner,COMSIG_MIAMI_CURED_DISORDER)
	return ..()

/datum/status_effect/miami/proc/bust_open(datum/source, obj/machinery/door/door, destination_state)
	SIGNAL_HANDLER

	owner.do_attack_animation(door, no_effect = TRUE)

	var/direction = get_dir(owner,door)

	var/turf/turf_in_direction = get_step(door,direction)

	for(var/mob/living/carbon/carbie in turf_in_direction)
		carbie.Knockdown(5 SECONDS)


/datum/status_effect/miami/proc/throw_relay(datum/source, atom/target, atom/thrown_thing)
	SIGNAL_HANDLER
	cached_thrown_object = thrown_thing
	if(isliving(thrown_thing))
		RegisterSignal(thrown_thing, COMSIG_MOVABLE_IMPACT, PROC_REF(mob_throw_knockdown))

	if(isitem(thrown_thing))
		RegisterSignal(thrown_thing, COMSIG_MOVABLE_IMPACT, PROC_REF(item_throw_knockdown))

/datum/status_effect/miami/proc/item_throw_knockdown(datum/source,atom/hit_atom, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	UnregisterSignal(cached_thrown_object, COMSIG_MOVABLE_THROW_LANDED)

	if(!iscarbon(hit_atom))
		return

	var/obj/item/this_item = source

	if(this_item.w_class < WEIGHT_CLASS_NORMAL)
		return

	var/mob/living/carbon/carbie_hit = hit_atom

	carbie_hit.Knockdown(3 SECONDS)

/datum/status_effect/miami/proc/mob_throw_knockdown(datum/source,atom/hit_atom, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	UnregisterSignal(cached_thrown_object,COMSIG_MOVABLE_THROW_LANDED)

	if(!iscarbon(hit_atom))
		return

	var/mob/living/this_mob = source

	if(this_mob.mob_size < MOB_SIZE_HUMAN)
		return

	var/mob/living/carbon/carbie_hit = hit_atom

	carbie_hit.Knockdown(4 SECONDS)

/datum/status_effect/miami/proc/basically_curbstomp(mob/living/source, atom/target, obj/item/weapon, proximity_flag, click_parameters)
	SIGNAL_HANDLER
	if(!proximity_flag)
		return

	if(!isliving(target))
		return

	var/mob/living/living_target = target

	if(!living_target.IsKnockdown())
		return
	INVOKE_ASYNC(src, PROC_REF(continue_with_stomping), weapon, target, click_parameters)
	living_target.AdjustKnockdown(1 SECONDS)

/datum/status_effect/miami/proc/continue_with_stomping(obj/item/weapon, atom/target, click_parameters)
	weapon.attack(target, owner, click_parameters)


/datum/status_effect/miami/proc/react_to_meds(datum/source,datum/reagent/reagent , amount, reagtemp, data, no_react)
	SIGNAL_HANDLER

	if(!istype(reagent, /datum/reagent/medicine/haloperidol) && !istype(reagent, /datum/reagent/medicine/psicodine))
		return
	//15u syringe stuns for 3 seconds, 5u pill drops you for 1 second, BS syringe will drop you for 12 seconds
	owner.Paralyze((amount / 5) SECONDS)

	owner.remove_status_effect(type)

	owner.drop_all_held_items()

/atom/movable/screen/alert/status_effect/miami
	name = "THE KILLING NEVER STOPS"
	desc = "Do you like hurting other people?"
	icon = 'massmeta/features/miami/icons/screen_alert.dmi'
	icon_state = "miami"

/datum/uplink_item/bundles_tc/miami
	name = "Old-World Rampage Kit"
	desc = "Blood, heat and dust. The wind howls, the russians are no more, but the ones that inherited wealth from them still stand tall. Prove yourself Operative, and make sure you don't go completely mad."
	item = /obj/item/storage/backpack/satchel/miami/prefilled
	cost = 17
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/obj/item/clothing/gloves/miami
	name = "old bloody rags"
	desc = "Those rags haven't seen use in eons, they were used tor terrible back then."
	icon = 'massmeta/features/miami/icons/gloves.dmi'
	worn_icon = 'massmeta/features/miami/icons/hands.dmi'
	icon_state = "miami"
	attack_verb_continuous = list("butchers")
	attack_verb_simple = list("butcher")
	resistance_flags = INDESTRUCTIBLE
	var/playback = FALSE
	var/datum/action/cooldown/rewind/replay

/obj/item/clothing/gloves/miami/Initialize()
	. = ..()
	replay = new()

//unwashable
/obj/item/clothing/gloves/miami/wash(clean_types)
	. = ..()
	return FALSE

/obj/item/clothing/gloves/miami/worn_overlays(isinhands = FALSE)
	. = ..()
	//always fucking bloody
	if(!isinhands)
		. += mutable_appearance('icons/effects/blood.dmi', "bloodyhands")

/obj/item/clothing/gloves/miami/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user) && slot == ITEM_SLOT_GLOVES)
		replay.Grant(user)
		RegisterSignal(user, COMSIG_MIAMI_CURED_DISORDER, PROC_REF(stop_the_slaughter))

/obj/item/clothing/gloves/miami/dropped(mob/user)
	if(user.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		replay.Remove(user)
		UnregisterSignal(user, COMSIG_MIAMI_CURED_DISORDER)
		if(!playback)
			return ..()
		stop_the_slaughter()
	return ..()

/obj/item/clothing/gloves/miami/update_icon(updates)
	. = ..()
	if(playback)
		icon_state = "miami_playback"
	else
		icon_state = "miami"

/obj/item/clothing/gloves/miami/proc/stop_the_slaughter()
	playback = FALSE
	update_icon()
	REMOVE_TRAIT(src, TRAIT_NODROP, replay.type)
	if(!isliving(loc))
		return

	var/mob/living/living_owner = loc
	SEND_SIGNAL(living_owner, COMSIG_MIAMI_END_SPREE)
	living_owner.remove_status_effect(/datum/status_effect/miami)
	living_owner.Unconscious(1 SECONDS)
	living_owner.dropItemToGround(src)
	return

/datum/action/cooldown/rewind
	name = "REWIND"
	desc = "The telephone rings, will you pick it up?"
	button_icon = 'massmeta/features/miami/icons/actions_items.dmi'
	button_icon_state = "playback"
	background_icon = 'massmeta/features/miami/icons/backgrounds.dmi'
	background_icon_state = "miami"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/rewind/Trigger(trigger_flags, atom/target)
	. = ..()
	var/mob/living/living_owner = owner
	var/obj/item/clothing/gloves/miami/miami = living_owner.get_item_by_slot(ITEM_SLOT_GLOVES)
	if(!istype(miami))
		return
	living_owner.apply_status_effect(/datum/status_effect/miami)
	playsound(owner, 'massmeta/features/miami/sounds/Rewind_effect.mp3', 50, FALSE)
	miami.playback = TRUE
	miami.update_icon()
	ADD_TRAIT(miami, TRAIT_NODROP, type)
	SEND_SIGNAL(living_owner, COMSIG_MIAMI_START_SPREE)
	Remove(owner)


/obj/item/clothing/mask/gas/miami
	name ="Generic Miami Mask"
	desc ="You stare into the eyes in the mask, and you can feel something staring back at you..."
	resistance_flags = INDESTRUCTIBLE
	flags_inv = HIDEHAIR
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH | PEPPERPROOF

	var/mob/living/carbon/human/local_wearer
	var/alert_type

/obj/item/clothing/mask/gas/miami/equipped(mob/M, slot)
	. = ..()
	if(slot != ITEM_SLOT_MASK)
		return
	RegisterSignal(M, COMSIG_MIAMI_START_SPREE, PROC_REF(on_killing_start))
	RegisterSignals(M, list(COMSIG_MIAMI_END_SPREE, COMSIG_LIVING_DEATH), PROC_REF(on_killing_stop))

	if(!ishuman(M))
		return
	local_wearer = M
	if(!local_wearer.has_status_effect(/datum/status_effect/miami))
		return
	on_killing_start()

/obj/item/clothing/mask/gas/miami/Destroy()
	on_killing_stop()
	local_wearer = null
	return ..()

/obj/item/clothing/mask/gas/miami/dropped(mob/M)
	UnregisterSignal(M, list(COMSIG_MIAMI_START_SPREE, COMSIG_LIVING_DEATH, COMSIG_MIAMI_END_SPREE))
	on_killing_stop()
	local_wearer = null
	return ..()

/obj/item/clothing/mask/gas/miami/proc/on_killing_start()
	if(alert_type)
		local_wearer.throw_alert("miami_mask",alert_type)

/obj/item/clothing/mask/gas/miami/proc/on_killing_stop()
	if(local_wearer)
		local_wearer.clear_alert("miami_mask")

/obj/item/clothing/mask/gas/miami/classic
	name = "The Classic"
	icon = 'massmeta/features/miami/icons/masks.dmi'
	icon_state = "miami_classic"
	worn_icon = 'massmeta/features/miami/icons/mask.dmi'
	worn_icon_state = "miami_classic"
	alert_type = /atom/movable/screen/alert/classic
	var/previous_tick_bonus = 0
	var/max_brute_resist = 0.4

/obj/item/clothing/mask/gas/miami/classic/on_killing_start()
	. = ..()
	START_PROCESSING(SSprocessing,src)

/obj/item/clothing/mask/gas/miami/classic/on_killing_stop()
	STOP_PROCESSING(SSprocessing,src)
	. = ..()

/obj/item/clothing/mask/gas/miami/classic/process(delta_time)

	var/current_tick_bonus = 0

	local_wearer.physiology.brute_mod += previous_tick_bonus

	for(var/mob/living/carbon/human/humie in orange(6,local_wearer))
		if(humie.stat != DEAD)
			//8% per person
			current_tick_bonus += 0.08

	current_tick_bonus = min(current_tick_bonus,max_brute_resist)

	local_wearer.physiology.brute_mod -= current_tick_bonus

	previous_tick_bonus = current_tick_bonus

/obj/item/clothing/mask/gas/miami/predator
	name = "The Predator"
	icon = 'massmeta/features/miami/icons/masks.dmi'
	icon_state = "miami_predator"
	worn_icon = 'massmeta/features/miami/icons/mask.dmi'
	worn_icon_state = "miami_predator"
	alert_type = /atom/movable/screen/alert/predator
	var/list/blood_tracker_dictionary = list()
	var/atom/movable/screen/fullscreen/blood_tracker/tracker
	var/x_offset = 208
	var/y_offset = 208

/obj/item/clothing/mask/gas/miami/predator/on_killing_start()
	. = ..()
	tracker = local_wearer.overlay_fullscreen("miami", /atom/movable/screen/fullscreen/blood_tracker)
	START_PROCESSING(SSprocessing, src)
	RegisterSignal(local_wearer, COMSIG_MOVABLE_MOVED, PROC_REF(update_tracking_self_moved))

/obj/item/clothing/mask/gas/miami/predator/on_killing_stop()
	STOP_PROCESSING(SSprocessing, src)
	for(var/person in blood_tracker_dictionary)
		if(local_wearer.client)
			local_wearer.client.images -= blood_tracker_dictionary[person]
		qdel(blood_tracker_dictionary[person])
		blood_tracker_dictionary -= person

	tracker = null
	if(local_wearer)
		local_wearer.clear_fullscreen("miami")
	UnregisterSignal(local_wearer, COMSIG_MOVABLE_MOVED, PROC_REF(update_tracking_self_moved))
	. = ..()

/obj/item/clothing/mask/gas/miami/predator/process(delta_time)

	var/list/people_in_range = list()
	for(var/person in GLOB.human_list - local_wearer)

		if(get_dist(local_wearer,person) > 32)
			continue
		var/mob/living/carbon/human/human_person = person
		if(human_person.health > 50 && !human_person.is_bleeding())
			continue
		if(human_person.z != local_wearer.z)
			continue
		people_in_range += person

	var/list/people_no_longer_in_range = blood_tracker_dictionary - people_in_range

	for(var/person in people_no_longer_in_range)
		UnregisterSignal(person, COMSIG_MOVABLE_MOVED)
		if(local_wearer.client)
			local_wearer.client.images -= blood_tracker_dictionary[person]
		qdel(blood_tracker_dictionary[person])
		blood_tracker_dictionary -= person

	var/list/new_people_in_range = people_in_range - blood_tracker_dictionary

	for(var/person in new_people_in_range)
		// add them to the blood pointer list, and initialize the proper image
		var/image/blood_tracker = image('massmeta/features/miami/icons/64x64.dmi', tracker, "blood_pointer", BELOW_MOB_LAYER)
		blood_tracker.pixel_x = x_offset
		blood_tracker.pixel_y = y_offset
		var/matrix/M = matrix()
		var/scaling_factor = (32 - clamp(get_dist(local_wearer,person),0,32) )/32//same as /32
		M.Turn(get_angle(local_wearer,person))
		M.Scale(scaling_factor,scaling_factor)
		blood_tracker.transform = M
		blood_tracker_dictionary[person] = blood_tracker
		if(local_wearer.client)
			local_wearer.client.images += blood_tracker

		RegisterSignal(person, COMSIG_MOVABLE_MOVED, PROC_REF(update_tracking_self_unmoved))

/obj/item/clothing/mask/gas/miami/predator/proc/update_tracking_self_unmoved(mob/living/carbon/human/someone_else)
	var/image/blood_tracker = blood_tracker_dictionary[someone_else]
	var/matrix/M = matrix()
	M.Turn(get_angle(local_wearer,someone_else))
	var/scaling_factor = (32 - clamp(get_dist(local_wearer,someone_else),0,32) )/32//same as /32
	M.Scale(scaling_factor,scaling_factor)
	blood_tracker.transform = M

/obj/item/clothing/mask/gas/miami/predator/proc/update_tracking_self_moved(mob/living/carbon/human/our_guy)
	for(var/person in blood_tracker_dictionary)
		var/image/blood_tracker = blood_tracker_dictionary[person]
		var/matrix/M = matrix()
		M.Turn(get_angle(local_wearer,person))
		var/scaling_factor = (32 - clamp(get_dist(local_wearer,person),0,32) )/32 //same as /32
		M.Scale(scaling_factor,scaling_factor)
		blood_tracker.transform = M

/obj/item/clothing/mask/gas/miami/butcher
	name = "The Butcher"
	icon = 'massmeta/features/miami/icons/masks.dmi'
	icon_state = "miami_butcher"
	worn_icon = 'massmeta/features/miami/icons/mask.dmi'
	worn_icon_state = "miami_butcher"
	alert_type = /atom/movable/screen/alert/butcher

/obj/item/clothing/mask/gas/miami/butcher/on_killing_start()
	. = ..()
	START_PROCESSING(SSprocessing,src)

/obj/item/clothing/mask/gas/miami/butcher/on_killing_stop()
	STOP_PROCESSING(SSprocessing,src)
	block_chance = 0
	return ..()

/obj/item/clothing/mask/gas/miami/butcher/process(delta_time)
	block_chance = 10.5 // we start with 5.5 because 7 * 7 * 0.5 is exactly 24.5, meaning that this will add up nicely to 35%
	for(var/obj/effect/decal/cleanable/blood in range(7,local_wearer))
		block_chance += 0.5

/atom/movable/screen/alert/classic
	name = "The Classic"
	desc = "You gain up to 40% brute resist based on the amount of living people around you."
	icon = 'massmeta/features/miami/icons/screen_alert.dmi'
	icon_state = "miami_classic"

/atom/movable/screen/alert/predator
	name = "The Predator"
	desc = "You gain the ability sense blood and gore, tracking people who are on low health or are bleeding."
	icon = 'massmeta/features/miami/icons/screen_alert.dmi'
	icon_state = "miami_predator"

/atom/movable/screen/alert/butcher
	name = "The Butcher"
	desc = "You gain from 10% to 35% block chance depending on the amount of blood and gore around you."
	icon = 'massmeta/features/miami/icons/screen_alert.dmi'
	icon_state = "miami_butcher"

/obj/item/storage/backpack/satchel/miami
	name = "Retro satchel"
	desc = "An oldschool satchel, made for it's job."
	icon = 'massmeta/features/miami/icons/storage.dmi'
	icon_state = "miami"
	worn_icon = 'massmeta/features/miami/icons/back.dmi'
	var/mob/living/carbon/human/local_wearer

/obj/item/storage/backpack/satchel/miami/equipped(mob/M, slot)
	. = ..()
	if(slot != ITEM_SLOT_BACK)
		return
	RegisterSignal(M, COMSIG_MIAMI_START_SPREE, PROC_REF(on_killing_start))
	RegisterSignals(M, list(COMSIG_MIAMI_END_SPREE, COMSIG_LIVING_DEATH), PROC_REF(on_killing_stop))

	if(!ishuman(M))
		return
	local_wearer = M
	if(!local_wearer.has_status_effect(/datum/status_effect/miami))
		return
	on_killing_start()

/obj/item/storage/backpack/satchel/miami/Destroy()
	on_killing_stop()
	local_wearer = null
	return ..()

/obj/item/storage/backpack/satchel/miami/dropped(mob/M)
	UnregisterSignal(M, list(COMSIG_MIAMI_START_SPREE, COMSIG_LIVING_DEATH, COMSIG_MIAMI_END_SPREE))
	on_killing_stop()
	local_wearer = null
	return ..()

/obj/item/storage/backpack/satchel/miami/proc/on_killing_start()
	local_wearer.throw_alert("miami_satchel", /atom/movable/screen/alert/miami_satchel)
	ADD_TRAIT(local_wearer, TRAIT_IGNOREDAMAGESLOWDOWN, type)

/obj/item/storage/backpack/satchel/miami/proc/on_killing_stop()
	if(local_wearer)
		local_wearer.clear_alert("miami_satchel")
		REMOVE_TRAIT(local_wearer, TRAIT_IGNOREDAMAGESLOWDOWN, type)

/atom/movable/screen/alert/miami_satchel
	name = "Satchel"
	desc = "You gain damage slowdown immunity while wearing this."
	icon = 'massmeta/features/miami/icons/screen_alert.dmi'
	icon_state = "miami_satchel"

/obj/item/storage/backpack/satchel/miami/prefilled/PopulateContents()
	. = ..()
	new /obj/item/storage/pill_bottle/psicodine(src)
	new /obj/item/miami_whoami(src)
	new /obj/item/clothing/gloves/miami(src)
	new /obj/item/clothing/suit/jacket/letterman_syndie(src)
	new /obj/item/melee/baseball_bat(src)

/obj/item/miami_whoami
	name = "Shifting Covers"
	desc = "Who am I today? Use in hand to choose mask."
	icon = 'massmeta/features/miami/icons/masks.dmi'
	icon_state = "miami_whoami"

/obj/item/miami_whoami/attack_self(mob/user, modifiers)
	. = ..()
	var/popup_input = tgui_alert(user, "Choose Your Madness", "Mask", list("The Classic", "The Predator", "The Butcher"))
	switch(popup_input)
		if("The Classic")
			new /obj/item/clothing/mask/gas/miami/classic(drop_location())
		if("The Predator")
			new /obj/item/clothing/mask/gas/miami/predator(drop_location())
		if("The Butcher")
			new /obj/item/clothing/mask/gas/miami/butcher(drop_location())
	qdel(src)

/obj/item/clothing/mask/gas/owl_mask
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH | PEPPERPROOF

/obj/item/clothing/mask/gas/miami_classic
	name = "The Classic"
	desc = "You stare into the eyes in the mask, and you can feel something staring back at you..."
	icon = 'massmeta/features/miami/icons/masks.dmi'
	icon_state = "miami_classic"
	worn_icon = 'massmeta/features/miami/icons/mask.dmi'
	worn_icon_state = "miami_classic"
	inhand_icon_state = "owl_mask"
	flags_inv = HIDEHAIR
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH | PEPPERPROOF
	resistance_flags = FLAMMABLE
	has_fov = FALSE

/obj/item/clothing/mask/gas/miami_predator
	name = "The Predator"
	desc = "You stare into the eyes in the mask, and you can feel something staring back at you..."
	icon = 'massmeta/features/miami/icons/masks.dmi'
	icon_state = "miami_predator"
	worn_icon = 'massmeta/features/miami/icons/mask.dmi'
	worn_icon_state = "miami_predator"
	inhand_icon_state = "owl_mask"
	flags_inv = HIDEHAIR
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH | PEPPERPROOF
	resistance_flags = FLAMMABLE
	has_fov = FALSE

/obj/item/clothing/mask/gas/miami_butcher
	name = "The Butcher"
	desc = "You stare into the eyes in the mask, and you can feel something staring back at you..."
	icon = 'massmeta/features/miami/icons/masks.dmi'
	icon_state = "miami_butcher"
	worn_icon = 'massmeta/features/miami/icons/mask.dmi'
	worn_icon_state = "miami_predator"
	inhand_icon_state = "owl_mask"
	flags_inv = HIDEHAIR
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH | PEPPERPROOF
	resistance_flags = FLAMMABLE
	has_fov = FALSE
