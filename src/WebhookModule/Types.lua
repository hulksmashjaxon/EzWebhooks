local Types = {}

--Embeds
export type EmbedField = { name: string, value: string, inline: boolean? }
export type Embed = {
	title: string?,
	description: string?,
	color: Color3,
	url: string?,
	timestamp: DateTime?,
	footer: {}?,
	author: {}?,
	fields: { EmbedField }?,
}
export type BoilerplateData = {
	username: string?,
	content: string?,
	embeds: { Embed }?,
	components: { UnionCmp }?,
	poll: {}?,
	avatar_url: string?,
	flags: number?,
	identifier: boolean,
}
export type Methods = {
	AddEmbed: (self: Boilerplate, customization: Embed) -> Boilerplate,
	Send: (self: Boilerplate, url: string) -> string,

	AddActionRow: (self: Boilerplate, customization: ACTION_ROW) -> Boilerplate,
	AddTextDisplay: (self: Boilerplate, customization: TEXT_DISPLAY) -> Boilerplate,
	AddContainer: (self: Boilerplate, customization: CONTAINER) -> Boilerplate,
	AddSection: (self: Boilerplate, customization: SECTION) -> Boilerplate,
}

export type Boilerplate = BoilerplateData & Methods
--Components v2 no req modal usage
Types.IntToName = {
	[1] = "ACTION_ROW",
	[2] = "BUTTON",
	[3] = "STRING_SELECT",
	[5] = "USER_SELECT",
	[6] = "ROLE_SELECT",
	[7] = "MENTIONABLE_SELECT",
	[8] = "CHANNEL_SELECT",
	[9] = "SECTION",
	[10] = "TEXT_DISPLAY",
	[11] = "THUMBNAIL",
	[12] = "MEDIA_GALLERY",
	[13] = "FILE",
	[14] = "SEPARATOR",
	[17] = "CONTAINER",
}

export type UnionCmp = ACTION_ROW | BUTTON | TEXT_DISPLAY
export type ACTION_ROW = {
	type: "ACTION_ROW"?,
	components: { ACRChildren },
}
export type ACRChildren = BUTTON
export type ButtonStyles = "1" | "2" | "3" | "4" | "5"
--ACR child components--
export type BUTTON = { --Able to be used as an accessory and child under ActionRow
	type: "BUTTON",
	label: string?,
	url: string,
}
--Section child components--
export type TEXT_DISPLAY = { --No children, able to be used with no parent
	content: string,
	type: number?,
}
export type THUMBNAIL = {
	type: number?,
	media: { url: string },
	description: string?,
	spoiler: boolean?,
}
--Others--
export type MEDIA_GALLERY = { --No children, able to be used with no parent
	items: { { media: { url: string }, description: string?, spoiler: boolean? } },
}

export type SECTION = {
	type: number,
	components: { TEXT_DISPLAY },
	accessory: { BUTTON | THUMBNAIL },
}

export type SEPARATOR = {
	type: number?,
	divider: boolean?,
	spacing: number?,
}

export type ContainerChildren = ACTION_ROW | TEXT_DISPLAY | MEDIA_GALLERY | SECTION | SEPARATOR

export type CONTAINER = {
	type: number?,
	id: number?,
	components: { ContainerChildren },
	accent_color: Color3?,
	spoiler: boolean?,
}

return Types
