@unpack_item = (item) ->
	mime = require('mime');

	console.log("hell")

	regex = /data:([a-zA-Z0-9\/]*);([a-zA-Z0-9\/]*),/g
	res = regex.exec(item)

	encoding = res[2]
	type = res[1]
	extension = mime.extension(type)

	f = res[0].length
	t = item.length
	data = item.substring(f, t)

	res =
		data: data
		type: type
		encoding: encoding
		extension: extension

	return res

@buildByteArray = (string, stringLength) ->
	buffer = new ArrayBuffer stringLength
	array  = new Uint8Array buffer

	for i in [0..stringLength]
		array[ i ] = string.charCodeAt i

	return array

@base64_to_byte = (base64String) ->
	decoded		= atob base64String
	length		= decoded.length
	byteArray = buildByteArray decoded, length

	return byteArray

@base64_to_blob = (base64String, mime_type) ->
	byteArray = base64_to_byte base64String

	if not byteArray
		return null

	res = new Blob [byteArray], {type: mime_type}
	return res

