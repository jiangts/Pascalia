module.exports = (grunt) ->

  grunt.initConfig
    concat:
      options:
        separator: '\n#next file\n'
      app:
        src: ['src/pascal.coffee', 'src/painter.coffee']
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
    watch:
      app:
        files: '**/*.coffee'
        tasks: ['default']

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  # Default task.
  grunt.registerTask 'default', ['concat', 'coffee', 'uglify']
