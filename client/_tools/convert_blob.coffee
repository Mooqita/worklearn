@unpack_item = (item) ->
	regex = /data:([a-zA-Z0-9\/]*);([a-zA-Z0-9\/]*),/g
	res = regex.exec(item.data)

	encoding = res[2]
	type = res[1]

	f = res[0].length
	t = item.data.length
	data = item.data.substring(f, t)

	return data


@base64_to_blob = (base64String) ->
  decodedString       = _decodeBase64 base64String
  decodedStringLength = _getLength decodedString
  byteArray           = _buildByteArray decodedString, decodedStringLength

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