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

Hook.Patch("Barotrauma.Items.Components.Repairable", "StartRepairing", function (instance, ptable)
	local powered = instance.Item.GetComponentString("Powered")
	local powertransfer = instance.Item.GetComponentString("PowerTransfer")
	local id = instance.Item.ID

	if ptable.ReturnValue == true then
		print("Safely repairing ", id)
		if powered ~= nil then
			if SR.PoweredItemStates[id] == nil then
				SR.PoweredItemStates[id] = powered.IsActive
			end
			print("Powered state is ", powered.IsActive)
			powered.IsActive = false
		end
		if powertransfer ~= nil then
			if SR.PowerTransferItemStates[id] == nil then
				SR.PowerTransferItemStates[id] = powertransfer.IsActive
			end
			print("PowerTransfer state is ", powertransfer.IsActive)
			powertransfer.IsActive = false
		end
	end

end, Hook.HookMethodType.After)

Hook.Patch("Barotrauma.Items.Components.Repairable", "StopRepairing", function (instance, ptable)
	local powered = instance.Item.GetComponentString("Powered")
	local powertransfer = instance.Item.GetComponentString("PowerTransfer")
	local id = instance.Item.ID

	if ptable.ReturnValue == true then
		print("Done safely repairing ", id)
		if powered ~= nil then
			print("Powered state was ", SR.PoweredItemStates[id])
			powered.IsActive = SR.PoweredItemStates[id]
			SR.PoweredItemStates[id] = nil
		end
		if powertransfer ~= nil then
			print("PowerTransfer state was ", SR.PowerTransferItemStates[id])
			powertransfer.IsActive = SR.PowerTransferItemStates[id]
			SR.PowerTransferItemStates[id] = nil
		end
	end

end, Hook.HookMethodType.After)
