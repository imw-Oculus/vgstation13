obj/item/implant/peace
	name = "pax implant"
	desc = "A bean-shaped implant, embossed with the word 'PAX'. It promises to halt agression in the host."
	death_on_remove = TRUE
	implant_process = TRUE
	var/implant_msg_debounce = 0


/obj/item/implant/peace/implant_activate()
	var/mob/living/carbon/origin = implant_parent.owner

	if (origin.nutrition <= 0 || origin.reagents.has_reagent(METHYLIN, 15))
		implant_state = 1
	else
		implant_state = 0

	if (!implant_msg_debounce && implant_state == 1)
		implant_msg_debounce = 1
		to_chat(origin, "<span class = 'warning'>Your rage bubbles, \the [src] inside you is being suppressed!</span>")

	if (implant_msg_debounce && !implant_state)
		implant_msg_debounce = 0
		to_chat(origin, "<span class = 'warning'>Your rage cools, \the [src] inside you is active!</span>")

	if (!implant_state)
		origin.nutrition = max(origin.nutrition - 0.15,0)


/obj/item/implant/peace/on_add()
	if (implant_controller)
		implant_controller.implants_tracked.Add(src)
	..()
	var/mob/living/carbon/origin = implant_parent.owner
	to_chat(origin, "<span class = 'warning'>You feel your desire to harm anyone slowly drift away...</span>")

//===

/obj/item/implanter/peace
	implant_cur = new /obj/item/implant/peace(src)

/obj/item/implant_case/peace
	implants_max = 3
	implant_type = "peace"
