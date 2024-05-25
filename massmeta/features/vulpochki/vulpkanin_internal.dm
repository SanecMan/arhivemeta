/obj/item/organ/internal/tongue/vulpkanin
	name = "long tongue"
	desc = "длинный и более чувствительный язык, может различить больше вкусов"
	icon_state = "tongue"
	taste_sensitivity = 10
	modifies_speech = FALSE
	languages_native = list(/datum/language/canilunzt)
	liked_foodtypes = RAW | MEAT | SEAFOOD
	disliked_foodtypes = VEGETABLES | GRAIN | FRUIT | JUNKFOOD | GORE

/obj/item/organ/internal/tongue/vulpkanin/get_possible_languages()
	return ..() + /datum/language/canilunzt

/obj/item/organ/internal/stomach/vulpkanin
	hunger_modifier = 1.3

/obj/item/organ/internal/liver/vulpkanin
	name = "vulpkanin liver"
	icon = 'massmeta/icons/vulps/organs.dmi'
	icon_state = "liver"
	alcohol_tolerance = ALCOHOL_RATE * 1.5

/obj/item/organ/internal/eyes/vulpkanin
	name = "vulpkanin eyeballs"
	icon = 'massmeta/icons/vulps/organs.dmi'
	icon_state = "eyes"

/obj/item/organ/internal/heart/vulpkanin
	name = "vulpkanin heart"
	icon = 'massmeta/icons/vulps/organs.dmi'
	icon_state = "heart"

/obj/item/organ/internal/brain/vulpkanin
	icon = 'massmeta/icons/vulps/organs.dmi'
	icon_state = "brain"

/obj/item/organ/internal/lungs/vulpkanin
	name = "vulpkanin lungs"
	icon = 'massmeta/icons/vulps/organs.dmi'

/obj/item/organ/internal/kidneys/vulpkanin
	name = "vulpkanin kidneys"
	icon = 'massmeta/icons/vulps/organs.dmi'
	icon_state = "kidneys"
