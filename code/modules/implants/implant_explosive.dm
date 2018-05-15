/*
imw/Oculus - (04052018)
imw/Oculus - (07052018)
*/

/obj/item/implant/explosive
	name = "explosive implant"
	desc = "A military grade micro bio-explosive. Highly dangerous."
	icon_state = "implant_evil"

	activate_on_hear = TRUE
	use_charges = TRUE
	implant_charges = 1

	melt_chance = 50
	emp_shield = 50


/obj/item/implant/explosive/on_remove()
	..()
	implant_activate_phrase = null


/obj/item/implant/explosive/on_malfunction(var/severity)
	..()
	switch(severity)
		if (1)
			if (prob(melt_chance))
				do_explosion(2)
			else
				on_death()
		if (2)
			if (prob(melt_chance) )
				do_explosion(1)

/obj/item/implant/explosive/implant_activate()
	..()
	do_explosion(2)

/obj/item/implant/explosive/proc/do_explosion(var/severity)
	var/turf/target_turf = null
	var/mob/living/carbon/origin = implant_parent.owner

	if (origin)
		message_admins("Explosive implant triggered in [origin] ([origin.key]). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[origin.x];Y=[origin.y];Z=[origin.z]'>JMP</a>) ")
		log_game("Explosive implant triggered in [origin] ([origin.key]).")
		target_turf = get_turf(origin)
	else
		target_turf = get_turf(src.loc)

	switch(severity)
		if (1)
			visible_message("<span class='warning'>Something beeps inside [origin]'s [implant_parent.display_name]!</span>")
			playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
			spawn(25)
				if (implant_parent)
					implant_parent.droplimb(1)
				explosion(target_turf, -1, -1, 2, 3, 3)
				qdel(src)
		if (2)
			if (origin)
				origin.gib()
			explosion(target_turf, 1, 3, 4, 6)
			target_turf.hotspot_expose(3500, 125, surfaces = 1)
			qdel(src)

/obj/item/implant/explosive/nuclear
	emp_shield = 100
	melt_chance = 0

//===

/obj/item/implanter/explosive
	implant_cur = new /obj/item/implant/explosive(src)

/obj/item/implant_case/explosive
	implant_type = "explosive"
