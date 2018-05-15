/*

*/

/obj/item/implant/death_alarm
	name = "death alarm implant"
	desc = "An alarm which monitors host vital signs and transmits a radio message upon death."

/obj/item/implanter/death_alarm
	implant_cur = new /obj/item/implant/death_alarm(src)

/obj/item/implant_case/death_alarm
	implant_type = "death_alarm"



