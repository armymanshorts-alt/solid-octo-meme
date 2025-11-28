-- Bloodlines Life Up Fruit Finder & Tree Teleporter
-- Stops when it finds a Life Up Fruit

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local workspace = game:GetService("Workspace")

-- Find all trees in Workspace whose name starts with "Tree"
local function getAllTrees()
    local trees = {}
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and tostring(obj.Name):match("^Tree%d+") then
            table.insert(trees, obj)
        end
    end
    return trees
end

-- Get a BasePart to teleport near inside the tree (first BasePart child)
local function getTeleportPart(tree)
    for _, child in pairs(tree:GetChildren()) do
        if child:IsA("BasePart") then
            return child
        end
    end
    return nil
end

local TELEPORT_DISTANCE = 5
local TELEPORT_HEIGHT = 5
local TELEPORT_DELAY = 3 -- seconds to wait near each tree

local trees = getAllTrees()
if #trees == 0 then
    warn("No trees found in Workspace!")
    return
end

print("[LifeFruitFinder] Found "..#trees.." trees.")

-- Function to scan for Life Up Fruits anywhere in Workspace
local function findLifeUpFruit()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Life Up Fruit" then
            return obj
        end
    end
    return nil
end

-- Main loop to teleport near each tree and check for fruit
for i, tree in ipairs(trees) do
    local part = getTeleportPart(tree)
    if part then
        -- Teleport player near the tree part
        hrp.CFrame = part.CFrame * CFrame.new(TELEPORT_DISTANCE, TELEPORT_HEIGHT, 0)
        print("[LifeFruitFinder] Teleported near tree: "..tree.Name)
    else
        print("[LifeFruitFinder] Tree "..tree.Name.." has no BasePart, skipping")
    end

    wait(TELEPORT_DELAY)

    local fruit = findLifeUpFruit()
    if fruit then
        print("[LifeFruitFinder] Life Up Fruit found at: "..fruit:GetFullName())
        -- Optionally teleport to the fruit itself
        hrp.CFrame = fruit.CFrame + Vector3.new(0, TELEPORT_HEIGHT, 0)
        print("[LifeFruitFinder] Teleported to Life Up Fruit!")
        break -- stop searching after fruit found
    else
        print("[LifeFruitFinder] No Life Up Fruit found at this tree, moving on...")
    end
end

print("[LifeFruitFinder] Search completed.")
