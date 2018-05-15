/*
imw/Oculus - (05052018)
imw/Oculus - (07052018)
*/
/obj/item/implant/exile
	name = "exile implant"
	desc = "Prevents you from venturing off the asteroid"

/obj/item/implant/exile/on_add()
	..()
	var/mob/living/carbon/origin = implant_parent.owner
	to_chat(origin, "<span class='notice'>You shiver as you feel a weak bluespace void surround you.</span>")
	origin.locked_to_z = ASTEROID_Z

//===

/obj/item/implanter/exile
	implant_cur = new /obj/item/implant/exile(src)

/obj/item/implant_case/exile
	implant_type = "exile"

//---

/obj/structure/closet/secure_closet/exile
	name = "Exile Implants"
	req_access = list(access_hos)

/obj/structure/closet/secure_closet/exile/New()
	..()
	sleep(2)
	new /obj/item/implanter/exile(src)
	new /obj/item/implant_case/exile(src)
	new /obj/item/implant_case/exile(src)
	new /obj/item/implant_case/exile(src)
	new /obj/item/implant_case/exile(src)
	new /obj/item/implant_case/exile(src)
	return
