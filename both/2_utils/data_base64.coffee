################################################################
@unpack_item = (item) ->
	regex = /data:([-a-zA-Z0-9\/]*);([-a-zA-Z0-9\/]*),/g
	res = regex.exec(item)

	encoding = res[2]
	type = res[1]
	extension = mime_to_extension(type)||type

	f = res[0].length
	t = item.length
	data = item.substring(f, t)

	res =
		data: data
		type: type
		encoding: encoding
		extension: extension

	return res

################################################################
@build_byte_array = (string, stringLength) ->
	buffer = new ArrayBuffer stringLength
	array  = new Uint8Array buffer

	for i in [0..stringLength]
		array[ i ] = string.charCodeAt i

	return array

################################################################
@base64_to_byte = (base64String) ->
	Base64 = require('js-base64').Base64
	decoded = Base64.atob base64String
	length	 = decoded.length
	byteArray = build_byte_array decoded, length

	return byteArray

################################################################
@base64_to_blob = (base64String, mime_type) ->
	byteArray = base64_to_byte base64String

	if not byteArray
		return null

	res = new Blob [byteArray], {type: mime_type}
	return res

################################################################
@binary_string_to_base64 = (binary_string) ->
	Base64 = require('js-base64').Base64
	base = Base64.btoa(binary_string)
	return base
