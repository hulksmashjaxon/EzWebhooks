--!nocheck
const Types = require("@self/Types")
const HttpService = game:GetService("HttpService")
local module = {}

module.__index = module

function IsEmpty(value): boolean
	return type(value) == "table" and next(value) == nil
end

function module.new(): Types.BoilerplateData
	local boilerplate = {
		username = "",
		content = "",

		embeds = {},
		components = {},
		poll = {},

		avatar_url = "",
		flags = 0, --Shift changes are handled by using this calculation: 1x2^n where n is the number of shifts (or just use library
		identifier = true,
	}
	return setmetatable(boilerplate, module)
end

function module:AddEmbed(customization: Types.Embed)
	assert(self.identifier, "Provide a correct boilerplate! Generate one using new()")
	local embed = {}
	for k, v in pairs(customization :: { [string]: any }) do
		if v ~= nil and next(v) ~= nil then
			if typeof(v) == "DateTime" then
				v:ToIsoDate()
			elseif typeof(v) == "Color3" then
				local r = v.R * 255
				local g = v.G * 255
				local b = v.B * 255

				v = math.round((r * 256 ^ 2) + (g * 256 ^ 1) + (b * 256 ^ 0))
			end
			embed[k] = v
		end
	end

	table.insert(self.embeds, embed)

	return self
end

function module:AddActionRow(customization: Types.ACTION_ROW)
	customization.type = 1
	table.insert(self.components, customization)
	return self
end

function module:AddTextDisplay(customization: Types.TEXT_DISPLAY)
	customization.type = 10
	customization.id = Random.new():NextInteger(1, 9999)
	table.insert(self.components, customization)
	return self
end

function module:AddContainer(customization: Types.CONTAINER)
	customization.type = 17
	customization.id = Random.new():NextInteger(1, 9999)
	table.insert(self.components, customization)
	return self
end

function module.AddChildActionRow(customization: Types.ACTION_ROW)
	customization.type = 1
	return customization
end

function module.AddButtonToActionRow(customization: Types.BUTTON): Types.BUTTON
	customization.type = 2
	customization.style = 5
	return customization
end

function module.AddSeparator(customization: Types.SEPARATOR)
	customization.type = 14
	return customization
end

function module.AddChildTextDisplay(customization: Types.TEXT_DISPLAY)
	customization.type = 10
	return customization
end

function module.AddThumbnail(customization: Types.THUMBNAIL)
	customization.type = 11
	customization.id = Random.new():NextInteger(1, 9999)
	return customization
end

function module:AddSection(customization: Types.SECTION)
	customization.type = 9
	customization.id = Random.new():NextInteger(1, 9999)
	table.insert(self.components, customization)
	return self
end

function module.AddEmbedField(customization: Types.EmbedField)
	return customization
end

--<strong>url:</strong> The URL of your webhook. Use a proxy, like WebhookProxy.
--<strong>boilerplate:</strong> The base created using WebhookModule.new()
--<em>Boilerplates cannot be re-used unless regenerating one.</em>
function module:Send(url: string): string
	assert(string.sub(url, 1, 8) == "https://", "Must be a valid URL")
	assert(self.identifier, "Provide a correct boilerplate! Generate one by using WebhookModule.new()")
	local final = {}

	--if string.find(url, "discord.com") then
	--	url = string.gsub(url, "discord.com", "webhook.lewisakura.moe")
	--end

	for k, v in pairs(self) do
		if v ~= nil and v ~= "" and IsEmpty(v) == false then
			final[k] = v
		end
	end

	--if final.components and (final.content or final.embeds or final.poll) then
	--	error('You cannot use the "content", "embeds", or "poll" field when using ComponentsV2!')
	--end

	final.identifier = nil
	print("Dumping entire before posting:")
	print(final)
	assert(
		script:GetAttribute("DisableInStudio") ~= true,
		"Testing is disabled in Studio to avoid unnecessary HTTP requests!\n You can disable this by going into Attributes > DisableInStudio"
	)

	local success, result = pcall(function()
		if final.components then
			final.flags = bit32.lshift(1, 15)
			print(HttpService:JSONEncode(final))
			return HttpService:RequestAsync({
				Url = url .. "?with_components=true",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode(final),
			})
		else
			return HttpService:RequestAsync({
				Url = url,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode(final),
			})
		end
	end)
	print(result)
	assert(success, `Something went wrong:\nStatus: {result} `)
	assert(result.Success, `API rejected request:\nStatus: {result.StatusCode}`)

	return result
end

return module
