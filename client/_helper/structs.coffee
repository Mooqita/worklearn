#######################################################
# This allows us to write inline objects in Blaze templates
# like so: {{> template param=(object key="value") }}
# => The template"s data context will look like this:
# { param: { key: "value" } }
#######################################################
Template.registerHelper "object", (param) ->
	return param.hash


#######################################################
# This allows us to write inline arrays in Blaze templates
# like so: {{> template param=(array 1 2 3) }}
# => The template"s data context will look like this:
# { param: [1, 2, 3] }
#######################################################
Template.registerHelper "array", (param...) ->
	return param.slice 0, param.length-1
