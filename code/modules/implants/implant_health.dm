/obj/item/implant/health
	name = "health implant"
	desc = "An implant designed to measure the total health of the host"
	implant_process = TRUE
	var/track_health = 0

/obj/item/implant/health/implant_activate()
	if (!implant_parent)
		return
	if (!implant_parent.owner)
		return
	var/mob/living/carbon/origin = implant_parent.owner
	var/oxy_dam = round(origin.getOxyLoss() )
	var/fire_dam = round(origin.getFireLoss() )
	var/brute_dam = round(origin.getBruteLoss() )
	var/tox_dam = round(origin.getToxLoss() )
	var/origin_total_health = oxy_dam - fire_dam - brute_dam - tox_dam

	track_health = origin_total_health

/obj/item/implanter/health
	implant_cur = new /obj/item/implant/health(src)

/obj/item/implant_case/health
	implant_type = "health"
