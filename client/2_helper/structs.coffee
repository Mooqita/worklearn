#######################################################
# This allows us to write inline objects in Blaze templates
# like so: {{> template param=(g_object key="value") }}
# => The template"s data context will look like this:
# { param: { key: "value" } }
#######################################################
Template.registerHelper "g_object", (param) ->
	return param.hash


#######################################################
# This allows us to write inline arrays in Blaze templates
# like so: {{> template param=(g_array 1 2 3) }}
# => The template"s data context will look like this:
# { param: [1, 2, 3] }
#######################################################
Template.registerHelper "g_array", (param...) ->
	return param.slice 0, param.length-1
