// Modules.
var
  gulp = require('gulp'),
  sass = require('gulp-sass'),
  jshint = require('gulp-jshint'),
  stylish = require('jshint-stylish'),
  autoprefixer = require('gulp-autoprefixer'),
  sourcemaps = require('gulp-sourcemaps'),
  uglify = require('gulp-uglify'),
  pump = require('pump'),
  sequence = require('gulp4-run-sequence');

// -- Init -------------------------------------------------------------------*/

var SRC_ASSETS = 'src_assets/';
var ASSETS = 'assets/';

var CMD = {
  JS_DEV: 'js:dev',
  JS_WATCH: 'js:watch',
  JS_LINT: 'js:lint',
  JS_PROD: 'js:prod',
  SASS_DEV: 'sass:dev',
  SASS_WATCH: 'sass:watch',
  SASS_PROD: 'sass:prod',
  IMAGES: 'images',
  IMAGES_WATCH: 'images:watch',
  FONTS: 'fonts',
  FONTS_WATCH: 'fonts:watch'
};


/* -- Util -------------------------------------------------------------------*/

function copyTask (task, input, output) {
  gulp.task(task, function (handler) {
    pump([gulp.src(SRC_ASSETS + input), gulp.dest(ASSETS + output)], handler);
  });
}

function sequenceTask (task, tasks) {
  gulp.task(task, function (handler) { sequence(tasks, handler); });
}

/* -- Sass -------------------------------------------------------------------*/

gulp.task(CMD.SASS_DEV, function (handler) {
  pump([
    gulp.src(SRC_ASSETS + 'scss/*.scss'),
    sourcemaps.init(),
    sass({ outputStyle: 'expanded' }),
    autoprefixer({ browsers: ['last 4 versions'], cascade: false }),
    sourcemaps.write('sourcemaps'),
    gulp.dest(ASSETS + 'css')
  ], handler);
});

gulp.task(CMD.SASS_PROD, function (handler) {
  pump([
    gulp.src(SRC_ASSETS + 'scss/*.scss'),
    sass.sync({ outputStyle: 'compressed' }),
    autoprefixer({ browsers: ['last 4 versions'], cascade: false }),
    gulp.dest(ASSETS + 'css')
  ], handler);
});

gulp.task(CMD.SASS_WATCH, function () {
  gulp.watch(
    [SRC_ASSETS + 'scss/**/*.scss'],
    { usePolling: true, interval: 1000 },
    gulp.series(CMD.SASS_DEV));
});

/* -- JavaScript -------------------------------------------------------------*/

gulp.task(CMD.JS_LINT, function (handler) {
  pump([
    gulp.src(['gulpfile.js', SRC_ASSETS + 'js/*.js']),
    jshint(),
    jshint.reporter(stylish),
    jshint.reporter('fail'),
  ], function () { handler(); });
});

copyTask(CMD.JS_DEV, 'js/*.js', 'js/');

gulp.task(CMD.JS_PROD, function (handler) {
  pump([
    gulp.src(SRC_ASSETS + 'js/*.js'),
    uglify(),
    gulp.dest(ASSETS + 'js/')
  ], handler);
});

gulp.task(CMD.JS_WATCH, function () {
  gulp.watch(
    ['gulpfile.js', SRC_ASSETS + 'js/*.js'],
    { usePolling: true, interval: 1000 },
    gulp.series(CMD.JS_LINT, CMD.JS_DEV)
  );
});


/* -- Static -----------------------------------------------------------------*/

copyTask(CMD.FONTS, 'fonts/**/*', 'fonts/');

gulp.task(CMD.FONTS_WATCH, function () {
  gulp.watch(
    [SRC_ASSETS + 'fonts/*'],
    { usePolling: true, interval: 1000 },
    gulp.series(CMD.FONTS)
  );
});

copyTask(CMD.IMAGES, 'images/**/*', 'images/');

gulp.task(CMD.IMAGES_WATCH, function () {
  gulp.watch(
    [SRC_ASSETS + 'images/**/*'],
    { usePolling: true, interval: 1000 },
    gulp.series(CMD.IMAGES)
  );
});

/* -- Sequences --------------------------------------------------------------*/

sequenceTask('build:dev', [
  CMD.SASS_DEV,
  CMD.FONTS,
  CMD.IMAGES
]);

sequenceTask('build:prod', [
  CMD.JS_PROD,
  CMD.SASS_PROD,
  CMD.FONTS,
  CMD.IMAGES
]);

sequenceTask('default', [
  CMD.JS_LINT,
  CMD.JS_DEV,
  CMD.SASS_DEV,
  CMD.FONTS,
  CMD.IMAGES,
  CMD.JS_WATCH,
  CMD.SASS_WATCH,
  CMD.FONTS_WATCH,
  CMD.IMAGES_WATCH
]);
