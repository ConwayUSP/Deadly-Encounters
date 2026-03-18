----------------------------------------
-- Utilitários de fs
----------------------------------------

function pathlizeName(s)
	local str = string.lower(string.gsub(s, " ", "_"))
	return string.gsub(str, "'", "_")
end

-- transforma uma lista de pastas e um nome de arquivo em um caminho para o arquivo
function pngPathFormat(parts)
	local path = ""
	for i, v in ipairs(parts) do
		if i ~= #parts then
			path = path .. pathlizeName(v) .. "/"
		else
			path = path .. pathlizeName(v) .. ".png"
		end
	end
	return path
end

function resolvePath(base, relative, ending)
	local path = base .. "/" .. relative .. (ending or "")
	if love.filesystem.getInfo(path) then
		return path
	else
		return nil
	end
end
