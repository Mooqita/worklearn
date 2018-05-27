##########################################################
# import
##########################################################

##########################################################
FlowRouter = require('meteor/ostrio:flow-router-extra').FlowRouter


#########################################################
# response_code
#########################################################

#########################################################
@calculate_response_hash = (index, salt, template) ->
	ha = CryptoJS.SHA256(index+salt+template)
	return ha.toString().substring(0,9)


##############################################
Template.response_code.helpers
	done: ->
		for k in this.required
			op =
				collection_name: this.collection_name
				item_id: this.item_id
				field: k
			val = get_field_value(op)
			if not val
				return false

		return true

	get_response: ->
		salt = this.salt
		index = FlowRouter.getParam("index")
		template = FlowRouter.getParam("template")

		return calculate_response_hash(index, salt, template)
