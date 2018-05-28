###############################################################################
JSZip = require('jszip').JSZip

###############################################################################
_format_data =
	csv: (data) ->
		str_csv = require('csv-string')
		promise = str_csv.stringify data
		return promise

	xml: (data) ->
		return json2xml { 'content': data }, { header: true }

	json: (data) ->
		res = JSON.stringify data, null, 2
		return res


###############################################################################
@export_pandas_zip = (data, name) ->
	formattedData = _format_data["csv"](data)

	zip = new JSZip()
	zip.file name+".csv", formattedData
	promise = zip.generateAsync {type : "base64"}

	return promise.await()


###############################################################################
@export_collection_zip = (collection) ->
	data = get_my_documents collection
	data = data.fetch()
	formattedData = _format_data["json"]( data )

	zip = new JSZip()
	zip.file get_collection_name collection + ".json", formattedData
	promise = zip.generateAsync {type : "base64"}

	return promise.await()


###############################################################################
@import_data = (data) ->
	return "nope"