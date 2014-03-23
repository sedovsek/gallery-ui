module.exports = (grunt) ->

    grunt.initConfig

        pkg: grunt.file.readJSON 'package.json'
        
        clean: ['lib/*.js']

        coffee:
            main:
                expand  : true
                join    : true
                cwd     : 'src/'
                src     : ['*.coffee']
                dest    : 'lib/'
                ext     : '.js'

        watch:
            js:
                files: ['src/**']
                tasks: ['clean', 'coffee']

    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'

    grunt.registerTask 'default', ['clean', 'coffee', 'watch']