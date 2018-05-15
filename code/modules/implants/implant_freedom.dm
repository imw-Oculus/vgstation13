/*
imw/Oculus - (07052018)
*/

/obj/item/implant/freedom
	name = "freedom"
	desc = "An implant designed to loose bonds, allowing easy escape."
	_color = "r"
	use_charges = TRUE
	activate_on_emote = TRUE

/obj/item/implant/freedom/New()
	..()
	implant_charges = rand(1, 5)

/obj/item/implant/freedom/implant_activate()
	..()
	var/mob/living/carbon/origin = implant_parent.owner
	if (emote_cur == activate_emote)
		to_chat(origin, "You feel a faint click.")
		if (origin.handcuffed)
			origin.drop_from_inventory(origin.handcuffed)
		if (origin.legcuffed)
			origin.drop_from_inventory(origin.legcuffed)

//===

/obj/item/implanter/freedom
	implant_cur = new /obj/item/implant/freedom(src)

/obj/item/implant_case/freedom
	implant_type = "freedom"

