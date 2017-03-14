@convertBase64ToBlob = (base64String) ->
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