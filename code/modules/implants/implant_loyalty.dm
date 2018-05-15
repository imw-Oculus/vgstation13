/*
imw/Oculus - (07052018)
*/
/obj/item/implant/loyalty
	name = "loyalty implant"
	desc = "Forces the implantee to be loyal to glorious NanoTrasen."

/obj/item/implant/loyalty/on_add()
	..()
	var/mob/living/carbon/origin = implant_parent.owner
	if (!origin)
		return
	if(origin.mind in ticker.mode.head_revolutionaries)
		origin.visible_message("<span class='big danger'>[origin] seems to resist the implant!</span>", "<span class='danger'>You feel the corporate tendrils of Nanotrasen try to invade your mind!</span>")
		return
	else if(origin.mind in ticker.mode:revolutionaries)
		ticker.mode:remove_revolutionary(origin.mind)
	to_chat(origin, "<span class = 'notice'>You feel a surge of loyalty towards Nanotrasen.</span>")

//===

/obj/item/implanter/loyalty
	implant_cur = new /obj/item/implant/loyalty(src)

/obj/item/implant_case/loyalty
	implants_max = 3
	implant_type = "loyalty"
