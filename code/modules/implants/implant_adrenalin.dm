
/obj/item/implant/adrenalin
	name = "adrenalin implant"
	desc = "An implant carrying chemical charges which remove all stuns and knockdowns."
	use_charges = TRUE
	activate_on_emote = TRUE


/obj/item/implant/adrenalin/New()
	..()
	implant_charges = rand(2,5)

/obj/item/implant/adrenalin/implant_activate()
	..()
	var/mob/living/carbon/origin = implant_parent.owner
	to_chat(origin, "<span class = 'notice'>You feel a sudden surge of energy!</span>")
	origin.SetStunned(0)
	origin.SetKnockdown(0)
	origin.SetParalysis(0)


//===

/obj/item/implanter/adrenalin
	implant_cur = new /obj/item/implant/adrenalin(src)

/obj/item/implant_case/adrenalin
	implant_type = "adrenalin"