/datum/preference/color/mutant_color_secondary
	savefile_key = "feature_mcolor_secondary"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_inherent_trait = TRAIT_MUTANT_COLORS_SECONDARY

/datum/preference/color/mutant_color_secondary/is_accessible(datum/preferences/preferences)
	// color box in prefs TGUI will be appear only if user choose Colored Belly
	if (!..(preferences) || preferences.read_preference(/datum/preference/choiced/lizard_body_markings) != "Color Belly")
		return FALSE

	return TRUE

/datum/preference/color/mutant_color_secondary/create_default_value()
	return sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]")

/datum/preference/color/mutant_color_secondary/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mcolor_secondary"] = value

/datum/preference/color/mutant_color_secondary/is_valid(value)
	if (!..(value))
		return FALSE

	if (is_color_dark(value, 15))
		return FALSE

	return TRUE