/obj/structure/chair/one_bar
	name = "One-bar prison"
	desc = "You definitely don't want to be here alone. Seriously."
	icon = 'modular_bluemoon/icons/obj/structures/lewd_devices.dmi'
	var/icon_over = "onebar_over"
	icon_state = "onebar"
	anchored = TRUE
	flags_1 = NODECONSTRUCT_1
	var/extended = FALSE
	var/hole = CUM_TARGET_VAGINA
	custom_materials = list(/datum/material/iron = 10)

/obj/structure/chair/one_bar/New()
	..()
	add_overlay(mutable_appearance(icon, icon_over, MOB_LAYER + 1))

///obj/structure/chair/one_bar/Destroy()
//	. = ..()

/obj/structure/chair/one_bar/examine(mob/user)
	. = ..()
	. += span_notice("Похоже пружина [extended ? "расслаблена" : "сжата"].")

/obj/structure/chair/one_bar/attackby(obj/item/used_item, mob/user, params)
	add_fingerprint(user)
	if(istype(used_item, /obj/item/screwdriver))
		to_chat(user, span_notice("You unscrew the frame and begin to deconstruct it..."))
		playsound(loc, "'sound/items/screwdriver.ogg'", 30, 1)
		if(used_item.use_tool(src, user, 8 SECONDS, volume = 50))
			to_chat(user, span_notice("You disassemble it."))
			new /obj/item/one_bar_kit (src.loc)
			qdel(src)
	else if(!used_item)
		if(!extended)
			extended = TRUE
			to_chat(user, span_notice("Вы прикладываете не малые услия, что бы плавно сжать пружину механизма."))
		else
			hole = hole == CUM_TARGET_VAGINA ? CUM_TARGET_ANUS : CUM_TARGET_VAGINA
			to_chat(user, "<span class='notice'>Дилдо на поршне, нацелен в... [hole].</span>")

/obj/structure/chair/one_bar/pre_buckle_mob(mob/living/M)
	if(extended)
		to_chat(M, span_warning("Поршень с дилдо на конце кажется слишком длинным, что бы на него можно было сесть!"))
		return
	if(M.client?.prefs?.erppref != "Yes")
		to_chat(M, span_warning("[M] не согласен на такие действия!"))
		return
	. = ..()

/obj/structure/chair/one_bar/post_buckle_mob(mob/living/M)
	. = ..()

	var/obj/item/organ/genital/organ = M.getorganslot(hole)
	if(!organ && (hole != CUM_TARGET_ANUS))
		//fallback to anus
		hole = CUM_TARGET_ANUS
		organ = M.getorganslot(hole)
	if(!organ || !(organ.is_exposed() || organ.always_accessible))
		to_chat(M, span_lewd("Вы размещаетесь над устройством, нацеливая поршень себе в [hole]."))
		extended = TRUE
		to_chat(M, span_lewd("Механизм щелкает и поршень медленно заполняет тебя до упора!"))
		return
	to_chat(M, span_warning("Механизм щелкает и поршень медленно проходит мимо."))


/obj/structure/chair/one_bar/unbuckle_mob(mob/living/buckled_mob, force)
	if(extended)
		to_chat(M, span_warning("Вы пытаетесь самостоятельно выбраться, пока стержень плотно сидит внутри вас!"))
		if(!do_after(M, 120 SECONDS, target = src))
			return
	. = ..()



/obj/item/one_bar_kit
	name = "One-bar prison construction kit"
	desc = "Construction requires a screwdriver. Put it on the ground first!"
	icon = 'modular_bluemoon/icons/obj/structures/lewd_devices.dmi'
	icon_state = "kit"
	throwforce = 0
	var/unwrapped = 0
	w_class = WEIGHT_CLASS_HUGE

/obj/item/one_bar_kit/attackby(obj/item/used_item, mob/user, params)
	add_fingerprint(user)
	if(istype(used_item, /obj/item/screwdriver))
		if (!(item_flags & IN_INVENTORY) && !(item_flags & IN_STORAGE))
			to_chat(user, span_notice("You screw the frame to the floor and begin to construct it..."))
			playsound(loc, "'sound/items/screwdriver.ogg'", 30, 1)
			if(used_item.use_tool(src, user, 8 SECONDS, volume = 50))
				to_chat(user, span_notice("You assemble it."))
				new /obj/structure/chair/one_bar (src.loc)
				qdel(src)
			return
	else
		return ..()
