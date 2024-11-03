MEL.DefineRecipe("salon_seat_types", "717_714")

function RECIPE:Inject(ent, entclass)
    local is_717 = MEL.Helpers.Is717(entclass)
    MEL.DeleteClientProp(ent, "seats_new")
    MEL.DeleteClientProp(ent, "seats_new_cap")
    MEL.DeleteClientProp(ent, "seats_old")
    MEL.DeleteClientProp(ent, "seats_old_cap")
    if is_717 then
        MEL.NewClientProp(ent, "seats", {
            model = "models/metrostroi_train/81-717/couch_old.mdl",
            modelcallback = function(wagon) return MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].head.model end,
            callback = function(wagon, cent)
                local callback = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].head.callback
                if callback then callback(wagon, cent) end
            end,
            pos = vector_origin,
            ang = angle_zero,
            hide = 1.5,
        }, "SeatTypeCustom")

        MEL.NewClientProp(ent, "seats_cap", {
            model = "models/metrostroi_train/81-717/couch_cap_l.mdl",
            modelcallback = function(wagon) return MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].head.cap_model end,
            callback = function(wagon, cent)
                local config = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].head
                if config.cap_callback then config.cap_callback(wagon, cent) end
                if not config.cap_model then cent:SetNoDraw(true) end
            end,
            pos = vector_origin,
            ang = angle_zero,
            hideseat = 0.8,
        }, "SeatTypeCustom")
    else
        MEL.DeleteClientProp(ent, "seats_new_cap_o")
        MEL.DeleteClientProp(ent, "seats_old_cap_o")
        MEL.NewClientProp(ent, "seats", {
            model = "models/metrostroi_train/81-717/couch_old.mdl",
            modelcallback = function(wagon) return MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int.model end,
            callback = function(wagon, cent)
                local callback = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int.callback
                if callback then callback(wagon, cent) end
            end,
            pos = vector_origin,
            ang = angle_zero,
            hide = 1.5,
        }, "SeatTypeCustom")

        MEL.NewClientProp(ent, "seats_cap", {
            model = "models/metrostroi_train/81-717/couch_cap_l.mdl",
            modelcallback = function(wagon) return MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int.cap_model end,
            callback = function(wagon, cent)
                local callback = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int.cap_callback
                if callback then callback(wagon, cent) end
            end,
            pos = vector_origin,
            ang = angle_zero,
            hideseat = 0.8,
        }, "SeatTypeCustom")

        MEL.NewClientProp(ent, "seats_cap_o", {
            model = "models/metrostroi_train/81-717/couch_cap_l.mdl",
            modelcallback = function(wagon)
                local config = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int
                return config.cap_o_model or config.cap_model
            end,
            callback = function(wagon, cent)
                local callback = MEL.RecipeSpecific.SalonSeatList[wagon:GetNW2Int("SeatTypeCustom", 1)].int.cap_o_callback
                if callback then callback(wagon, cent) end
            end,
            pos = vector_origin,
            ang = angle_zero,
            hideseat = 0.8,
        }, "SeatTypeCustom")

        MEL.InjectIntoClientFunction(ent, "Think", function(wagon)
            local cap_opened = wagon:GetPackedBool("CouchCap")
            wagon:ShowHide("seats_cap", not cap_opened)
            wagon:ShowHide("seats_cap_o", cap_opened)
        end)
    end
end
