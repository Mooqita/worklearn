@unpack_item = (item) ->
	mime = require('mime');

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

@base64_to_byte = (base64String) ->
	decodedString       = _decodeBase64 base64String
	decodedStringLength = _getLength decodedString
	byteArray           = _buildByteArray decodedString, decodedStringLength
	return byteArray

@base64_to_blob = (base64String) ->
	byteArray = base64_to_byte base64String

	if byteArray
		return _createBlob byteArray

_decodeBase64 = (string) ->
	return atob string

_getLength = (value) ->
  return value.length

_buildByteArray = (string, stringLength) ->
	buffer = new ArrayBuffer stringLength
	array  = new Uint8Array buffer

	for i in [0..stringLength]
		array[ i ] = string.charCodeAt i

	return array

_createBlob = (byteArray) ->
	return new Blob [byteArray], {type: 'application/zip'}