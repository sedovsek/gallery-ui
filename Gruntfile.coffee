module.exports = (grunt) ->

    grunt.initConfig

        pkg: grunt.file.readJSON 'package.json'
        
        clean: ['app/*.js', 'app/*.css']

        browserify:
            dist:
                files : 'app/script.js' : ['src/coffee/app.coffee']
            options:
                transform : ['coffeeify']

        uglify:
            my_target:
                files : 'app/script.js': ['app/script.js']

        sass:
            build:
                files:
                    'app/style.css' : 'src/sass/style.scss'

        watch:
            js:
                files: ['src/coffee/**']
                tasks: ['clean', 'browserify', 'sass']
            css:
                files: ['src/sass/**']
                tasks: ['sass']

        run_grunt:
            options:
                debug: true

            simple_target:
                src: ['tracker/Gruntfile.coffee']

        concurrent:
            target:
                tasks: ['run_grunt', 'watch'],

    grunt.loadNpmTasks 'grunt-concurrent'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-run-grunt'

    grunt.registerTask 'default',     ['clean', 'browserify', 'sass', 'watch']
    grunt.registerTask 'full-stack',  ['clean', 'browserify', 'sass', 'concurrent']
    grunt.registerTask 'production',  ['clean', 'browserify', 'uglify', 'sass', 'watch']