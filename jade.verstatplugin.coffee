jade = require 'jade'

module.exports = (next) ->

	@preprocessor "jadePrecompiler",
		srcExtname: '.jade'
		priority: 100
		preprocess: (file, done) =>
			try
				if file.processor is 'jade'
					file.fn = jade.compile file.source,
						filename: file.srcFilePath
						pretty: off
					@modified file
					done()
			catch err
				@log "ERROR", "error compiling jade", err
				done err

	@processor 'jade',
		srcExtname: '.jade'
		extname: '.html'
		compile: (file, options = {}, done) =>
			try
				templateData = {}
				@emit 'templateData', file, templateData
				done null, file.fn templateData
			catch e
				done e

	next()