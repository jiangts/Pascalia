module.exports = (grunt) ->

  grunt.initConfig
    concat:
      options:
        separator: '\n#next file\n'
      app:
        src: ['src/sizing.coffee', 'src/pascal.coffee', 'src/painter.coffee']
        dest: 'src/pascalia.coffee'
    coffee:
      app:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'lib'
        ext: '.js'
    uglify:
      app:
        files:
          'lib/pascalia.min.js': ['lib/pascalia.js']
    cssmin:
      app:
        expand: true
        cwd: 'css'
        src: ['*.css', '!*.min.css']
        dest: 'css'
        ext: '.min.css'
    watch:
      app:
        files: '**/*.coffee'
        tasks: ['default']

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'

  # Default task.
  grunt.registerTask 'default', ['concat', 'coffee', 'uglify']
