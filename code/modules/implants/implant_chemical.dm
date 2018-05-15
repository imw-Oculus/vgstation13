/*
imw/Oculus - (04052018)
*/

/obj/item/implant/chemical
	name = "chemical implant"
	desc = "An implant designed to pump stored reagents into the host."

	activate_on_emote = TRUE
	var/datum/reagents/implant_reagents = new /datum/reagents(50)

/obj/item/implant/chemical/New()
	..()

/obj/item/implant/chemical/implant_activate()
	var/mob/origin = implant_parent.owner
	if (!origin)
		return
	implant_reagents.trans_to(origin, 5)

/obj/item/implant/chemical/emp_act(var/severity)
	..()
	var/mob/living/carbon/origin = implant_parent
	if (!origin)
		return
	if (!origin.reagents)
		return

	switch(severity)
		if (1)
			implant_reagents.trans_to(origin, implant_reagents.total_volume)
		if (2)
			implant_reagents.trans_to(origin, 25)
		if (3)
			implant_reagents.trans_to(origin, 10)

/obj/item/implant/chemical/emote_trigger(emote, source as mob)
	..()
	if(emote == "deathgasp")
		melt_chance = 100
		emp_shield = 0
		emp_act(1)

//===

/obj/item/implanter/chemical
	implant_cur = new /obj/item/implant/chemical(src)

/obj/item/implant_case/chemical
	implant_type = "chemical"
