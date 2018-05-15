/*
imw/Oculus - (04052018)
*/

/obj/item/implant/tracking
	name = "tracking implant"
	desc = "An implant used to track the person implanted."

/obj/item/implant/tracking/on_add()
	if (implant_controller)
		implant_controller.implants_tracked.Add(src)
	..()

//===

/obj/item/implanter/tracking
	implant_cur = new /obj/item/implant/tracking(src)

/obj/item/implant_case/tracking
	implant_type = "tracking"
