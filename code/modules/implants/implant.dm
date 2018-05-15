/*
imw/Oculus - (04052018)
imw/Oculus - (07052018)
*/
/*
Required by:
- code/_HELPERS/globalaccess.dm
X- code/modules/implants/implant_*.dm
X- code/game/jobs/security.dm
X- code/game/gamemodes/nuclear/nuclear.dm
O- code/game/gamemodes/vampire/vampire_powers.dm
X- code/game/gamemodes/cult.dm
X- code/game/machinery/adv_med.dm
X- code/game/data_huds.dm
X- code/modules/mob/mob_helpers.dm
O- code/game/objects/items/weapons/storage/boxes.dm (Still requires locator + pad)
- code/game/objects/items/weapons/storage/uplink_kits.dm
- code/game/objects/items/weapons/storage/lockbox.dm
- code/modules/reagents/reagent_containers/dropper.dm
- code/modules/reagents/reagent_containers/syringes.dm
- code/game/objects/items/robot/robot_items.dm
- code/game/objects/items/weapons/teleportation.dm
- code/modules/medical/cloning.dm
- code/game/machinery/teleporter.dm
- code/game/machinery/computer/prisoner.dm
- code/game/modules/awaymissions/gateway.dm
- code/modules/mob/mob.dm
- code/game/modules/striketeams/emergency_response_team.dm
*/

//===

/datum/implant_master
	var/implant_count = 0
	var/list/implants_tracked = list()

var/global/datum/implant_master/implant_controller = new /datum/implant_master

//===

/obj/item/implant
	name = "implant default name"
	desc = "implant default desc"

	var/implant_id = 0
	var/datum/organ/external/implant_parent = null
	var/implant_state = 1 //0 = functioning, 1 = malfunctioning, 2 = Dead

	var/implant_health = 100
	var/implant_health_max = 100

	var/melt_chance = 100
	var/emp_shield = 0

	var/use_charges = FALSE
	var/implant_charges = 0

	var/implant_stealth = 100 //Lower stealth = less chance of finding during surgery

	var/activate_on_hear = FALSE
	var/implant_activate_phrase = null

	var/activate_on_emote = FALSE
	var/emote_cur = null
	var/activate_emote = null

	var/death_on_remove = FALSE
	var/activate_on_remove = FALSE

	var/implant_process = FALSE

	var/list/implant_data = list()

/obj/item/implant/New()
	if (src.type == /obj/item/implant)
		log_game("[src] INVALID. MASTER CLASS. DELETED.")
		qdel(src)
		return

	if (implant_controller)
		implant_controller.implant_count++
		implant_id = implant_controller.implant_count

		if (implant_process)
			implant_controller.implants_tracked.Add(src)

	implant_data["name"] = name
	implant_data["id"] = implant_id
	implant_data["manufacturer"] = "unknown"
	implant_data["lifespan"] = "unknown"
	implant_data["summary"] = "No summary detected."

	if (activate_on_hear)
		addHear()

/obj/item/implant/Destroy()
	if (implant_controller)
		implant_controller.implants_tracked.Remove(src)
	if (src in processing_objects)
		processing_objects.Remove(src)
	..()

/obj/item/implant/emp_act(severity)
	if (prob(emp_shield) )
		if (severity < 3)
			severity = severity + 1
			emp_act(severity)
		return

	switch(severity)
		if (1)
			if (prob(melt_chance) )
				on_death()
				return
			implant_health_modify(-50)
		if (2)
			implant_health_modify(-25)
		if (3)
			implant_health_modify(-10)
	on_malfunction(severity)


/obj/item/implant/process()
	if (!implant_process || !(src in implant_controller.implants_tracked) )
		processing_objects.Remove(src)
	implant_activate()



/obj/item/implant/proc/on_add(var/datum/organ/external/tar_limb)
	if (!tar_limb)
		return
	implant_parent = tar_limb
	if (!istype(implant_parent.owner, /mob/living/carbon) )
		return

	if (implant_controller)
		if (src in implant_controller.implants_tracked && implant_process)
			processing_objects.Add(src)

	var/mob/living/carbon/origin = tar_limb.owner

	if (activate_on_emote && !activate_emote)
		activate_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "pale", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
		origin.mind.store_memory("\The [src] can be activated by using the [activate_emote] emote, <B>say *[activate_emote]</B> to attempt to activate.", 0, 0)
		to_chat(origin, "The implanted [src] can be activated by using the [activate_emote] emote, <B>say *[activate_emote]</B> to attempt to activate.")

	if (activate_on_hear && !implant_activate_phrase)
		implant_activate_phrase = input("Choose activation phrase:") as text
		var/list/replacechars = list("'" = "", "\"" = "", ">" = "", "<" = "", "(" = "", ")" = "")
		implant_activate_phrase = sanitize_simple(implant_activate_phrase, replacechars)
		origin.mind.store_memory("\The [src] in [tar_limb.display_name] can be activated by saying something containing the phrase ''[implant_activate_phrase]'', <B>say [implant_activate_phrase]</B> to attempt to activate.", 0, 0)
		to_chat(origin, "The [src] in [tar_limb.display_name] can be activated by saying something containing the phrase ''[implant_activate_phrase]'', <B>say [implant_activate_phrase]</B> to attempt to activate.")

/obj/item/implant/proc/on_remove()
	if (!implant_parent)
		return
	var/mob/living/carbon/origin = implant_parent.owner

	if (origin)
		src.loc = origin.loc
	if (activate_on_emote)
		emote_cur = null
	if (activate_on_hear)
		implant_activate_phrase = null

	if (implant_controller)
		if (src in implant_controller.implants_tracked)
			processing_objects.Remove(src)

	if (death_on_remove)
		on_death()

	implant_parent = null


/obj/item/implant/proc/on_death()
	implant_state = 2
	if (src in processing_objects)
		processing_objects.Remove(src)
	if (implant_controller)
		implant_controller.implants_tracked.Remove(src)

	var/mob/living/carbon/origin = implant_parent.owner
	if (implant_parent && origin)
		to_chat(origin, "<span class = 'warning'>You feel something melting inside your [implant_parent]!</span>")
		implant_parent.take_damage(burn = 15, used_weapon = "Electronics meltdown")
	name = "melted implant"
	desc = "A charred circuit in melted plastic case."
	icon_state = "implant_melted"


/obj/item/implant/proc/on_malfunction(var/severity)
	if (!implant_state)
		return
	implant_state = 1
	var/malf_time = 0
	switch(severity)
		if (1)
			malf_time = rand(10, 15)
		if (2)
			malf_time = rand(5, 10)
		if (3)
			malf_time = rand(1, 5)
	if (implant_controller)
		if (src in implant_controller.implants_tracked && src in processing_objects)
			processing_objects.Remove(src)

	spawn(malf_time MINUTES)
		implant_state = 0
		if (src in implant_controller.implants_tracked && !(src in processing_objects) )
			processing_objects.Add(src)


/obj/item/implant/proc/implant_health_modify(var/mod_amnt)
	if (!mod_amnt)
		return
	if (mod_amnt > 0)
		if (implant_health + mod_amnt > implant_health_max)
			implant_health = implant_health_max
			return
	if (mod_amnt < 0)
		if (implant_health + mod_amnt < 0)
			implant_health = 0
			on_death()
			return
	implant_health = implant_health + mod_amnt


/obj/item/implant/proc/implant_activate()
	if (implant_state)
		return
	if (use_charges)
		if(!implant_charges)
			return
		implant_charges--

//---

/obj/item/implant/Hear(var/datum/speech/msg, var/rendered_speech = "")
	if (!implant_activate_phrase || !activate_on_hear || !implant_state)
		return
	var/list/replacechars = list("'" = "", "\"" = "", ">" = "", "<" = "", "(" = "", ")" = "")
	msg = sanitize_simple(msg, replacechars)
	if(findtext(msg, implant_activate_phrase))
		implant_activate()

//---

/obj/item/implant/proc/emote_trigger(emote)
	if (!activate_on_emote)
		return
	emote_cur = emote
	if (emote == activate_emote)
		implant_activate()

//---

/obj/item/implant/proc/get_data()
	return


//===

/obj/item/implant_case
	name = "implant case"
	desc = "a sterile case containing a number of implants"

	var/obj/item/implant/implant_type = null
	var/list/implants = list()
	var/implants_max = 1

/obj/item/implant_case/New()
	..()
	if (!implant_type)
		qdel(src)
		return

	for (var/count = 0, count < implants_max, count++)
		var/obj/item/implant/new_implant_type = text2path("obj/item/implant/[implant_type]")
		var/obj/item/implant/sel_implant = new new_implant_type
		implants.Add(sel_implant)

/obj/item/implant_case/proc/add_implant(var/obj/item/implant/tar_implant)
	if (!istype(tar_implant, implant_type) )
		return
	implants.Add(tar_implant)
	tar_implant.loc = src

/obj/item/implant_case/attackby(var/obj/tar_obj)
	if (!istype(tar_obj, /obj/item/implanter) )
		return
	var/obj/item/implanter/tar_implanter = tar_obj

	if (!tar_implanter.implant_cur)
		if (implants)
			tar_implanter.implant_cur = implants[0]
			implants[0].loc = tar_implanter
			implants.Remove(0)
	else
		if (implants.len < implants_max)
			if (tar_implanter.implant_cur.type == implant_type)
				tar_implanter.implant_cur.loc = src
				implants.Add(tar_implanter.implant_cur)
				tar_implanter.implant_cur = null

//===

/obj/item/implanter
	name = "implanter"
	desc = "A syringe-like device for easily transferring implants"

	var/obj/item/implant/implant_cur = null

/obj/item/implanter/New()
	..()
	src.implanter_update()

/obj/item/implanter/attack(var/mob/living/carbon/tar_mob)
	if (!istype(tar_mob, /mob/living/carbon) )
		return
	if (!implant_cur)
		return

	var/datum/organ/external/tar_limb = tar_mob.get_organ(tar_mob.zone_sel.selecting)
	tar_limb.implants.Add(implant_cur)
	implant_cur.loc = tar_mob
	implant_cur.on_add(tar_limb)
	implant_cur = null

/obj/item/implanter/proc/implanter_update()
	if (implant_cur)
		name = "[implant_cur.name]"
		icon_state = ""
	else
		name = "implanter"
		icon_state = ""

//===

/obj/item/implant_pad
	name = "implant pad"
	desc = "A small electronic device, used to glean more information about an inserted implant"

	var/obj/item/implant/implant_cur = null

/obj/item/implant_pad/attackby(var/obj/item/implant)
	return

/obj/item/implant_pad/attack_hand()
	return
