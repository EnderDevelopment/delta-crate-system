local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('delta:registerCrate')
AddEventHandler('delta:registerCrate', function(model, x, y, z)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.execute('INSERT INTO delta_crates (model, x, y, z) VALUES (@model, @x, @y, @z)', {
        ['@model'] = model,
        ['@x'] = x,
        ['@y'] = y,
        ['@z'] = z
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print('Crate registered in database')
        else
            print('Failed to register crate in database')
        end
    end)
end)

RegisterServerEvent('delta:registerAI')
AddEventHandler('delta:registerAI', function(model, x, y, z, crate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.execute('INSERT INTO delta_ai (model, x, y, z, crate_id) VALUES (@model, @x, @y, @z, @crate_id)', {
        ['@model'] = model,
        ['@x'] = x,
        ['@y'] = y,
        ['@z'] = z,
        ['@crate_id'] = crate
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print('AI registered in database')
        else
            print('Failed to register AI in database')
        end
    end)
end)

RegisterServerEvent('delta:giveReward')
AddEventHandler('delta:giveReward', function(reward)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if reward.name == 'money' then
        xPlayer.addMoney(reward.amount)
    elseif reward.name == 'weapon' then
        xPlayer.addWeapon(reward.weapon, 100)
    end
end)

ESX.RegisterServerCallback('delta:getRewards', function(source, cb)
    cb(Config.Rewards)
end)