/obj/item/implant/compressed
	name = "compressed matter implant"
	desc = "Based on compressed matter technology, this can store a single item once."
	icon_state = "implant_evil"

	use_charges = TRUE
	implant_charges = 1
	activate_on_emote = TRUE

	var/obj/item/scanned = null

/obj/item/implant/compressed/emote_trigger()
	if (!scanned)
		return
	..()
	var/mob/living/carbon/origin = implant_parent.owner
	to_chat(origin, "The air glows as \the [scanned.name] uncompresses.")

/obj/item/implant/compressed/implant_activate()
	..()
	var/mob/living/carbon/origin = implant_parent.owner
	origin.put_in_hands(scanned)
	qdel(src)

/obj/item/implanter/compressed
	implant_cur = new /obj/item/implant/compressed(src)

/obj/item/implant_case/compressed
	implant_type = /obj/item/implant/compressed
