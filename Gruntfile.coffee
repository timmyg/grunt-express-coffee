fs = require 'fs'
jade = require 'jade'
util = require 'util'

module.exports = (grunt) ->
  
  # register external tasks
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-env'
  
  BUILD_PATH = 'server/client_build'
  APP_PATH = 'client'
  TEMPLATES_PATH = "#{APP_PATH}/coffee/templates"
  DEV_BUILD_PATH = "#{BUILD_PATH}/development"
  JS_DEV_BUILD_PATH = "#{DEV_BUILD_PATH}/js"
  PRODUCTION_BUILD_PATH = "#{BUILD_PATH}/production"
  SERVER_PATH = "server"

  reloadPort = 35729
  
  grunt.initConfig

    clean:
      development: [DEV_BUILD_PATH]
      production: [PRODUCTION_BUILD_PATH]

    coffee:
      development:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: "#{APP_PATH}/coffee"
          dest: "#{DEV_BUILD_PATH}/js"
          src: ["*.coffee", "**/*.coffee"]
          ext: ".js"
        ]

    copy:
      development:
        files: [
          { expand: true, cwd: "#{APP_PATH}/public", src:['**'], dest: DEV_BUILD_PATH }
        ]
      # production:
      #   files: [
      #     { expand: true, cwd: DEV_BUILD_PATH, src:['**'], dest: PRODUCTION_BUILD_PATH },
      #   ]
  
    # run tests with mocha test, mocha test:unit, or mocha test:controllers
    mochaTest:
      controllers:
        options:
          reporter: 'spec'
        src: ['test/controllers/*']
        
    # express server
    express:
      test:
        options:
          server: './app'
          port: 5000
      development:
        options:
          server: './app'
          port: 3000
          # livereload: true
    # livereload:
    #   options:
    #     server: "server"
    #     livereload: true
    #     serverreload: true
    #     bases: "./public"
    
    sass:
      development:
        files:
          "server/client_build/development/stylesheets/main.css": "client/scss/main.scss"
    
    watch:
      # options:
      #   nospawn: true
      #   livereload: reloadPort
      # files: ["**/*"]
      #   tasks: ["jshint"]
      coffee:
        files: "server/**/*.coffee"
        tasks: 'development'
        options:
          livereload: true

      js:
          files: [
            "app.js"
            "app/**/*.js"
            "config/*.js"
          ]
          tasks: [
            "develop"
            "delayed-livereload"
          ]
      # jade:
      #   files: "#{TEMPLATES_PATH}/**/*.jade"
      #   tasks: 'clientTemplates'
      # sass:
      #   files: ["#{APP_PATH}/scss/**/*.scss"]
      #   tasks: 'sass:development' 

  grunt.registerTask 'clientTemplates', 'Compile and concatenate Jade templates for client.', ->
    # object to map template identifiers to content (built from jade file)
    # in js, use a template with JST['index'] (assuming templates is defined as JST)
    templates =
      'index': "#{TEMPLATES_PATH}/index.jade"

    tmplFileContents = "define(['jade'], function(jade) {\n"
    tmplFileContents += 'var JST = {};\n'  

    for namespace, filename of templates
      path = "#{__dirname}/#{filename}"
      contents = jade.compile(
        fs.readFileSync(path, 'utf8'), { client: true, compileDebug: false, filename: path }
      ).toString()
      tmplFileContents += "JST['#{namespace}'] = #{contents};\n"
      
    fs.writeFileSync "#{JS_DEV_BUILD_PATH}/templates.js", tmplFileContents

  grunt.config.requires "watch.js.files"
  files = grunt.config("watch.js.files")
  files = grunt.file.expand(files)
  grunt.registerTask "delayed-livereload", "Live reload after the node server has restarted.", ->
    console.log "reload....."
    done = @async()
    setTimeout (->
      request.get "http://localhost:" + reloadPort + "/changed?files=" + files.join(","), (err, res) ->
        reloaded = not err and res.statusCode is 200
        if reloaded
          grunt.log.ok "Delayed live reload successful."
        else
          grunt.log.error "Unable to make a delayed live reload."
        done reloaded
        return

      return
    ), 500
    return
        
  grunt.registerTask 'test', [
    'development'
    'express:test'
    'mochaTest:controllers'
  ]
    
  grunt.registerTask 'development', [
    'clean:development'
    'copy:development'
    'sass:development'
    'coffee:development'
    'clientTemplates'
  ]     
        
  grunt.registerTask 'default', [
    # 'env:development'
    'development'
    'express:development'
    # 'express-keepalive'
    'watch'
  ]
