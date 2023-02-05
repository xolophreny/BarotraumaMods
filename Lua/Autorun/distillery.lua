Hook.Add("roundStart", "distillery", function()
    for _, item in pairs(Item.ItemList) do
        if (item.HasTag("distillery")) then
            print("Made ",item.ID," interactable.");
            item.NonInteractable = false;
        end
    end
end);