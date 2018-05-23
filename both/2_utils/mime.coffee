########################################
mime = require('mime').mime

################################################################
@mime_to_extension = (type) ->
	mime = require("mime")
	extension = mime.extension(type)||type
	return extension

################################################################
@extension_to_mime = (ext) ->
	mime = require("mime")
	mime = mime.lookup(ext)||ext
	return mime

