import JSZip from 'jszip'

_format_data =
	xml: (data) ->
		return json2xml { 'content': data }, { header: true }

	json: (data) ->
		res = JSON.stringify( data, null, 2 )
		return res

  csv: (data) ->
		return Papa.unparse(data)


@export_data = (collection) ->
	data = collection.find({owner_id: Meteor.userId()}).fetch()
	formattedData = _format_data["json"]( data )

	zip = new JSZip()
	zip.file collection._name+".json", formattedData
	promise = zip.generateAsync {type : "base64"}

	return promise.await()

@import_data = (data) ->
	return "nope"