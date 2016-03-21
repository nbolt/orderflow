var gulp   = require('gulp'),
    axis   = require('axis'),
    accord = require('gulp-accord'),
    cjsx   = require('gulp-cjsx'),
    jshint = require('gulp-jshint'),
    uglify = require('gulp-uglify'),
    rename = require('gulp-rename'),
    concat = require('gulp-concat'),
    notify = require('gulp-notify'),
    cache = require('gulp-cache'),
    imagemin = require('gulp-imagemin'),
    livereload = require('gulp-livereload'),
    del    = require('del')

gulp.task('images', function() {
  return gulp.src('src/images/**/*')
    .pipe(cache(imagemin({ optimizationLevel: 3, progressive: true, interlaced: true })))
    .pipe(gulp.dest('dist/images'))
    .pipe(notify({ message: 'Images task complete' }));
});

gulp.task('components', function() {
  return gulp.src('src/scripts/components/*.cjsx')
    .pipe(cjsx({bare:true}))
    .pipe(uglify())
    .pipe(concat('components.js'))
    .pipe(rename({ suffix: '.min' }))
    .pipe(gulp.dest('dist/scripts'))
    .pipe(notify({ message: 'Components task complete' }));
});

gulp.task('scripts', function() {
  return gulp.src('src/scripts/js/**/*.js')
    .pipe(uglify())
    .pipe(concat('plugins.js'))
    .pipe(rename({ suffix: '.min' }))
    .pipe(gulp.dest('dist/scripts'))
    .pipe(notify({ message: 'Scripts task complete' }));
});

gulp.task('stylus', function() {
  return gulp.src('src/styles/**/**.styl')
    .pipe(accord('stylus', {use: axis()}))
    .pipe(concat('master.css'))
    .pipe(gulp.dest('dist/styles'))
    .pipe(notify({ message: 'Stylus task complete' }));
});

gulp.task('styles', function() {
  return gulp.src('src/styles/**/**.css')
    .pipe(concat('vendor.css'))
    .pipe(gulp.dest('dist/styles'))
    .pipe(notify({ message: 'Styles task complete' }));
});

gulp.task('default', ['clean'], function() {
  gulp.start('images', 'scripts', 'components', 'styles', 'stylus');
});

gulp.task('watch', function() {
  gulp.watch('src/scripts/components/*.cjsx', ['components'])
  gulp.watch('src/scripts/js**/*.js', ['scripts'])
  gulp.watch('src/styles/**/**.styl', ['stylus'])
  gulp.watch('src/styles/**/**.css', ['styles'])
  gulp.watch('src/images/**/*', ['images'])
  livereload.listen();
  gulp.watch(['dist/**']).on('change', livereload.changed);
});

gulp.task('clean', function() {
  return del(['dist/styles', 'dist/scripts', 'dist/images']);
});
