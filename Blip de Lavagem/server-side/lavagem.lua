local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

local vRP = Proxy.getInterface("vRP")
local vRPclient = Tunnel.getInterface("vRP")

local taxaMaquina = 0.90  -- Definindo taxa de 90%

function lavarDinheiro(quantidade)
    local source = source
    local user_id = vRP.getUserId(source)

    if user_id and quantidade and quantidade > 0 then
        -- Obtém todo o inventário do jogador
        local inventario = vRP.getUserInventory(user_id) or {}
        local dinheiroSujo = 0

        print("Inventário completo do jogador:")
        for _, item in pairs(inventario) do
            print("Item:", item.name, "Quantidade:", item.amount)
            if item.name == "dollars2" then
                dinheiroSujo = item.amount or 0
            end
        end

        print("Valor de dinheiroSujo encontrado:", dinheiroSujo)
        print("Quantidade solicitada:", quantidade)

        if type(dinheiroSujo) == "number" and dinheiroSujo >= quantidade then
            vRP.tryGetInventoryItem(user_id, "dollars2", quantidade)
            local valorLimpo = quantidade * taxaMaquina
            vRP.giveInventoryItem(user_id, "dollars", valorLimpo, true)

            TriggerClientEvent("Notify", source, "sucesso", "Você lavou <b>$"..quantidade.."</b> de dinheiro sujo e recebeu <b>$"..valorLimpo.."</b> de dinheiro limpo.")
        else
            TriggerClientEvent("Notify", source, "negado", "Você não tem dinheiro sujo suficiente.")
        end
    else
        TriggerClientEvent("Notify", source, "negado", "Quantidade inválida.")
    end
end


-- Função para verificar o item no inventário e retornar quantidade
function verificarInventarioItem(user_id, item_nome)
    local itemData = vRP.getInventoryItemAmount(user_id, item_nome)
    
    -- Verifica se o retorno é uma tabela (sugestão de que temos mais de um dado dentro dela)
    if type(itemData) == "table" then
        -- Tenta pegar o valor real, assumindo que o valor do item está na tabela
        local quantidade = itemData[1] or 0  -- Assumindo que o valor está no primeiro índice da tabela
        print("Quantidade encontrada:", quantidade)
        return quantidade
    else
        -- Caso o valor retornado seja um número simples
        print("Quantidade encontrada:", itemData)
        return itemData or 0
    end
end

-- Evento de lavagem de dinheiro
RegisterNetEvent("lavagem:lavarDinheiro")
AddEventHandler("lavagem:lavarDinheiro", function(quantidade)
    local source = source
    local user_id = vRP.getUserId(source)

    if user_id then
        print("ID do jogador:", user_id)

        -- Verifica o item diretamente
        local dinheiroSujo = verificarInventarioItem(user_id, "dollars2")
        
        if dinheiroSujo >= quantidade then
            vRP.tryGetInventoryItem(user_id, "dollars2", quantidade)
            local valorLimpo = quantidade * taxaMaquina
            vRP.giveInventoryItem(user_id, "dollars", valorLimpo, true) 

            TriggerClientEvent("Notify", source, "sucesso", "Você lavou <b>$"..quantidade.."</b> e recebeu <b>$"..valorLimpo.."</b> de dinheiro limpo.")
        else
            TriggerClientEvent("Notify", source, "negado", "Você não tem dinheiro sujo suficiente.")
        end
    else
        print("Erro: user_id não encontrado.")
        TriggerClientEvent("Notify", source, "negado", "Erro ao obter o ID do jogador.")
    end
end)
