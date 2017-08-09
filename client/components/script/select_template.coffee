#######################################################
registered_templates = [
		{value:"", label:"Select template"}
		{value:"empty", label:"Empty"}
		{value:"post", label:"Post"}
		{value:"headline", label:"Headline"}
		{value:"publication", label:"Publication"}
		{value:"team", label:"Team"}
		{value:"member", label:"Member"}
		{value:"partner", label:"Partner"}
		{value:"partner_list", label:"Partner List"}]

#######################################################
find_template_names = () ->
	d_tmpls = Templates.find().fetch()
	d_tmpls = ({label:t.name, value:t._id} for t in d_tmpls)

	d_tmpls.push registered_templates...

	return d_tmpls

#######################################################
@find_response_names = (collection_name) ->
	collection = get_collection collection_name

	tmpls = [{value:"", label:"Select response"}]

	d_tmpls = collection.find().fetch()
	d_tmpls = ({label:t.title, value:t._id} for t in d_tmpls)

	tmpls.push d_tmpls...

	return tmpls

#######################################################
#
#######################################################

#######################################################
Template.select_template.helpers
	templates: () ->
		return find_template_names()

#######################################################
Template.select_response.helpers
	responses: () ->
		return find_response_names(this.collection_name)
