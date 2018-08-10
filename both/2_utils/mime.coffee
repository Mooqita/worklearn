###############################################################################
mime = require('mime')

###############################################################################
@mime_to_extension = (type) ->
	extension = mime.getExtension(type)||type
	return extension

###############################################################################
@extension_to_mime = (ext) ->
	type = mime.getType(ext)||ext
	return type

