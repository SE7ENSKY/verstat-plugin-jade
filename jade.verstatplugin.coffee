jade = require 'jade'

module.exports = (next) ->

	@preprocessor "jadePrecompiler",
		srcExtname: '.jade'
		priority: 100
		preprocess: (file, done) =>
			try
				if file.processor is 'jade'
					source = file.source.replace ///\t///g, '  '
					file.fn = jade.compile source,
						filename: file.srcFilePath
						pretty: off
						readFileSync: (filename) =>
							winfix = (s) -> s.split('\\').join('/')
							filename = winfix filename
							found = @queryFile srcFilePath: filename
							if found
								@depends file, found
								return found.source
							else
								err = new Error "file #{filename} not found"
								err.code = 'ENOENT'
								throw err
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
