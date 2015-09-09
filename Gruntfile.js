'use strict';
module.exports = function(grunt) {
  grunt.initConfig({
    i18nextract: {
      default_options: {
        prefix:   '',
        suffix:   '.json',
        src:      ['src/app/**/*.html', 'src/app/**/*.js'],
        lang:     ['es', 'en'],
        dest:     'src/lang',
        customRegex: [
          '\\|\\|\\s*\'((?:\\\\.|[^\'\\\\])*)\'\\s*\\|\\s*translate\\s*',
          '\\|\\|\\s*\\(\\s*\'((?:\\\\.|[^\'\\\\])*)\'\\s*\\|\\s*translate\\s*'
        ],

      }
    }
  });

  grunt.loadNpmTasks('grunt-angular-translate');
  grunt.registerTask('default', ['i18nextract']);

};
