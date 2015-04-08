module.exports = (grunt) ->

    require('load-grunt-tasks') grunt, scope: 'devDependencies'

    grunt.initConfig

        pkg: grunt.file.readJSON 'package.json'
        
        clean: ['app/*.js', 'app/*.css']

        browserify:
            dist:
                files: 'app/script.js' : ['src/coffee/app.coffee']
            options:
                transform: ['coffeeify']

        uglify:
            my_target:
                files: 'app/script.js': ['app/script.js']

        concat:
            options:
                separator: ";\n"

            dist:
                src: ["app/script.js", "src/js/hammer.js", "src/js/zepto.min.js"]
                dest: "app/script.js"

        sass:
            dist:
                files:
                    'app/style.css' : 'src/sass/style.scss'
                options:
                    sourcemap: 'none'

        watch:
            js:
                files: ['src/coffee/**', 'config.js']
                tasks: ['clean', 'browserify', 'concat', 'sass']
            css:
                files: ['src/sass/**']
                tasks: ['sass']

        run_grunt_for_tracker:
            options:
                debug: true

            simple_target:
                src: ['tracker/Gruntfile.coffee']

        concurrent:
            target:
                tasks: ['run_grunt_for_tracker', 'watch'],

    grunt.registerTask 'default', ['clean', 'browserify', 'concat', 'sass', 'watch']

    # Running one grunt task for Gallery-UI and concurrently for tracker
    grunt.registerTask 'full-stack', ['clean', 'browserify', 'concat', 'sass', 'concurrent']

    # Just like default, but with uglification
    grunt.registerTask 'production', ['clean', 'browserify', 'concat', 'uglify', 'sass', 'watch']