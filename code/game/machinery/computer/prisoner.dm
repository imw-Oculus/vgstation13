//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/prisoner
	name = "Prisoner Management"
	icon = 'icons/obj/computer.dmi'
	icon_state = "explosive"
	req_access = list(access_armory)
	circuit = "/obj/item/weapon/circuitboard/prisoner"
	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed

	light_color = LIGHT_COLOR_RED

	attack_ai(var/mob/user as mob)
		src.add_hiddenprint(user)
		return src.attack_hand(user)


	attack_paw(var/mob/user as mob)
		return


	attack_hand(var/mob/user as mob)
		if(..())
			return
		user.set_machine(src)
		var/dat = list()
		if(screen == 0)
			dat += "<A href='?src=\ref[src];lock=1'>Unlock Console</A>"
		else if(screen == 1)
			dat += "Chemical Implants<BR>"
			var/turf/Tr = null
			for(var/obj/item/implant/C in implant_controller.implants_tracked)
				if (!istype(C, /obj/item/implant/chemical) )
					continue

				Tr = get_turf(C)
				if((Tr) && (Tr.z != src.z))
					continue//Out of range
				if(!C.implant_parent)
					continue

				var/obj/item/implant/chemical/tar_implant = C
				dat += {"[tar_implant.loc.name] | Remaining Units: [tar_implant.implant_reagents.total_volume] | Inject:
					<A href='?src=\ref[src];inject1=\ref[C]'>(<font color=red>(1)</font>)</A>
					<A href='?src=\ref[src];inject5=\ref[C]'>(<font color=red>(5)</font>)</A>
					<A href='?src=\ref[src];inject10=\ref[C]'>(<font color=red>(10)</font>)</A><BR>
					********************************<BR>"}

			dat += "<HR>Tracking Implants<BR>"
			for(var/obj/item/implant/T in implant_controller.implants_tracked)
				if (!istype(T, /obj/item/implant/tracking) )
					continue

				Tr = get_turf(T)
				if((Tr) && (Tr.z != src.z))
					continue//Out of range
				if(!T.implant_parent)
					continue
				var/loc_display = "Unknown"
				var/mob/living/carbon/M = T.implant_parent.owner
				if(!M)
					continue //Changeling monkeys break the console, bad monkeys.
				if(M.z == map.zMainStation && !istype(M.loc, /turf/space))
					var/turf/mob_loc = get_turf(M)
					loc_display = mob_loc.loc
				if(T.implant_state)
					loc_display = pick(teleportlocs)

				dat += {"ID: [T.implant_id] | Location: [loc_display]<BR>
					<A href='?src=\ref[src];warn=\ref[T]'>(<font color=red><i>Message Holder</i></font>)</A> |<BR>
					********************************<BR>"}
			dat += "<HR><A href='?src=\ref[src];lock=1'>Lock Console</A>"
		dat = jointext(dat,"")
		var/datum/browser/popup = new(user, "prisoner_implants", "Prisoner Implant Manager System", 400, 500, src)
		popup.set_content(dat)
		popup.open()
		onclose(user, "prisoner_implants")

	process()
		if(!..())
			src.updateDialog()
		return


	Topic(href, href_list)
		if(..())
			return 1
		else
			usr.set_machine(src)

			if(href_list["inject"])
				var/obj/item/implant/I = locate(href_list["inject1"])
				if(I)
					I.implant_activate()

			else if(href_list["lock"])
				if(src.allowed(usr))
					screen = !screen
				else
					to_chat(usr, "Unauthorized Access.")

			else if(href_list["warn"])
				var/warning = copytext(sanitize(input(usr,"Message:","Enter your message here!","")),1,MAX_MESSAGE_LEN)
				if(!warning)
					return
				var/obj/item/implant/I = locate(href_list["warn"])
				if((I)&&(I.implant_parent.owner))
					var/mob/living/carbon/R = I.loc
					to_chat(R, "<span class='good'>You hear a voice in your head saying: '[warning]'</span>")

			src.add_fingerprint(usr)
		src.updateUsrDialog()
		return
