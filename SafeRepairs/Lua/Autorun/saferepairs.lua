SR = {}
SR.PoweredItemStates = {}
SR.PowerTransferItemStates = {}

-- if (Game.IsMultiplayer and SERVER) or not Game.IsMultiplayer then end
--
--[[ Hook.Patch("Barotrauma.Items.Components.Repairable", "CheckCharacterSuccess", function (instance, ptable)
	local powered = instance.Item.GetComponentString("Powered")
	local character = ptable["character"]

	if character.IsPlayer and powered.Voltage > 0.1 then
		instance.Item.CreateServerEvent(instance, instance)
		ptable.PreventExecution = true
		ptable.ReturnValue = false
	end
end) --]]

Hook.Patch("Barotrauma.Items.Components.Repairable", "StartRepair", function (instance, ptable)
	local powered = instance.Item.GetComponentString("Powered")
	local powertransfer = instance.Item.GetComponentString("PowerTransfer")
	local id = instance.Item.ID

	if ptable.ReturnValue == true then
		print("Safely repairing ", id)
		if powered then
			table.insert(SR.PoweredItemStates, id, powered.IsActive())
			powered.IsActive = false
		end
		if powertransfer then
			table.insert(SR.PowerTransferItemStates, id, powertransfer.IsActive())
			powertransfer.IsActive = false
		end
	end

end, Hook.HookMethodType.After)

Hook.Patch("Barotrauma.Items.Components.Repairable", "StopRepair", function (instance, ptable)
	local powered = instance.Item.GetComponentString("Powered")
	local powertransfer = instance.Item.GetComponentString("PowerTransfer")
	local id = instance.Item.ID

	if ptable.ReturnValue == true then
		print("Done safely repairing ", id)
		if powered then
			powered.IsActive = SR.PoweredItemStates[id]
		end
		if powertransfer then
			powertransfer.IsActive = SR.PowerTransferItemStates[id]
		end
	end

end, Hook.HookMethodType.After)
