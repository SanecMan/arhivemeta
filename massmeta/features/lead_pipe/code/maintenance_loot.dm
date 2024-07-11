/obj/item/lead_pipe/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('massmeta/features/lead_pipe/sound/metalpipefallingsound.ogg'=1), 100, 5, falloff_exponent = 20)

/obj/item/lead_pipe/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is crushed under the weight of a thousand pipes!"))
	for(var/i in 1 to 8)
		playsound(user, 'massmeta/features/lead_pipe/sound/metalpipefallingsound.ogg', (20 + i * 10), FALSE)
		user.AddElement(/datum/element/squish, 1.5 SECONDS)
		sleep(1.5/8 SECONDS)
	user.gib()
	return MANUAL_SUICIDE
