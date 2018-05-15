/*
imw/Oculus - (07052018)
*/

/obj/item/implant/nanomachine
	name = "default nanomachine implant name"
	desc = "default nanomachine implant desc"
	death_on_remove = TRUE
	var/datum/reagent/target_reagent = null
	var/datum/reagents/implant_reagents = new /datum/reagents(10)

/obj/item/implant/nanomachine/New()
	..()
	if (type == /obj/item/implant/nanomachine)
		log_game("[src] INVALID. MASTER CLASS. DELETED.")
		qdel(src)

	if (target_reagent)
		implant_reagents.add_reagent(target_reagent, 10)

/obj/item/implant/nanomachine/process()
	var/mob/living/carbon/origin = implant_parent.owner

	if (!origin.reagents.has_reagent(target_reagent, 2))
		implant_reagents.trans_to(origin, 1)

/obj/item/implant/nanomachine/on_add()
	if (implant_controller)
		implant_controller.implants_tracked.Add(src)
	..()
	var/mob/living/carbon/origin = implant_parent.owner
	to_chat(origin, "<span class = 'warning'>You feel an electric surge as nanomachines swarm into your veins</span>")

//===

/obj/item/implant/nanomachine/medical
	name = "medical nanobot implant"
	desc = "An implant containing a number of medical nanobots, which are slowly dispensed into the blood."
	target_reagent = MEDNANOBOTS

//===

/obj/item/implant/nanomachine/combat
	name = "combat nanobot implant"
	desc = "An implant containing a number of combat nanobots, which are slowly dispensed into the blood."
	target_reagent = COMNANOBOTS

//===

/obj/item/implanter/nanomachine/medical
	implant_cur = new /obj/item/implant/nanomachine/medical(src)

/obj/item/implant_case/nanomachine/medical
	implant_type = "nanomachine/medical"

//--

/obj/item/implanter/nanomachine/combat
	implant_cur = new /obj/item/implant/nanomachine/combat(src)

/obj/item/implant_case/nanomachine/combat
	implant_type = "nanomachine/combat"