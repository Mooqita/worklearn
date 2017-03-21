########################################
@get_compiled_template = (template_id)->
	template = Template[template_id]

	if template
		return template

########################################
@get_template_local = (template_id)->
	template = Templates.findOne(template_id)
	return template

########################################
@get_template = (template_id)->
	tmpl = get_template_local(template_id)
	if tmpl
		return tmpl

	tmpl = get_compiled_template(template_id)
	if tmpl
		return tmpl

	return null


#######################################################
@registered_templates = [
		{value:"", label:"Select template"}
		{value:"empty", label:"Empty"}
		{value:"post", label:"Post"}
		{value:"headline", label:"Headline"}
		{value:"publication", label:"Publication"}
		{value:"team", label:"Team"}
		{value:"member", label:"Member"}
		{value:"partner", label:"Partner"}
		{value:"partner_list", label:"Partner List"}
		{value:"slide_deck", label:"Slide Deck"}
		{value:"slide_title", label:"Slide with Title"}
		{value:"slide_voting", label:"Slide with Voting"}
		{value:"slide_content", label:"Slide with content"}
		{value:"student_view", label:"View for Students"}
		{value:"hire_view", label:"View for Recruiters"}]

@find_template_names = () ->
	d_tmpls = Templates.find().fetch()
	d_tmpls = ({label:t.name, value:t._id} for t in d_tmpls)

	d_tmpls.push registered_templates...

	return d_tmpls

#######################################################
@find_response_names = () ->
	tmpls = [{value:"", label:"Select response"}]

	d_tmpls = Responses.find().fetch()
	d_tmpls = ({label:t.title, value:t._id} for t in d_tmpls)

	tmpls.push d_tmpls...

	return tmpls

#######################################################
@compile_template = (name, html_text) ->
	try
		compiled = SpacebarsCompiler.compile html_text, { isTemplate:true }
		renderer = eval compiled

		#Template[name] = new Template(name, renderer)
		UI.Template.__define__ name, renderer
		console.log "Template compiled"

	catch err
		console.log "Error compiling template:" + html_text
		console.log err.message

#######################################################
@get_field_value = (self, field, item_id, collection_name) ->
	collection_name = collection_name || self.collection_name
	item_id = item_id || self.item_id
	field = field || self.field

	collection = global[collection_name]
	if not collection
		console.log "collection not found: " + collection_name
		return undefined

	item = collection.findOne(item_id)
	if not item
		console.log "item: (" + item_id + ") not found in: " + collection_name
		return undefined

	return item[field]
