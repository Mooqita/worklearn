import JSZip from 'jszip'

_formatData =
	xml: (data) ->
		return json2xml { 'content': data }, { header: true }

	json: (data) ->
		res = JSON.stringify( data, null, 2 )
		return res

  csv: (data) ->
		return Papa.unparse(data)


@exportData = (collection) ->
	data = collection.find({owner_id: Meteor.userId()}).fetch()
	formattedData = _formatData["json"]( data )

	zip = new JSZip()
	zip.file collection._name+".json", formattedData
	promise = zip.generateAsync {type : "base64"}

	return promise.await()