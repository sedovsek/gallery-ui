module.exports = (grunt) ->

    grunt.initConfig

        pkg: grunt.file.readJSON 'package.json'
        
        clean: ['app/*.js', 'app/*.css']

        browserify:
            dist:
                files : 'app/script.js' : ['lib/coffee/app.coffee']
            options:
                transform : ['coffeeify']

        uglify:
            my_target:
                files : 'app/script.js': ['app/script.js']

        sass:
            build:
                files:
                    'app/style.css' : 'lib/sass/style.scss'

        watch:
            js:
                files: ['lib/coffee/**']
                tasks: ['clean', 'browserify', 'sass']
            css:
                files: ['lib/sass/**']
                tasks: ['sass']

    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'default',    ['clean', 'browserify', 'sass', 'watch']
    grunt.registerTask 'production', ['clean', 'browserify', 'uglify', 'sass', 'watch']