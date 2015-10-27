var gulp = require('gulp');
var args = require('yargs').argv;
var browserSync = require('browser-sync');
var config = require('./gulp.config')();
var del = require('del');
var $ = require('gulp-load-plugins')({lazy:true});
var port = process.env.PORT || config.defaultPort;
var fs = require('fs');

gulp.task('vet', function() {
    log('Analizing code with JsHint and JSCS');
    return gulp
      .src(config.alljs)
      .pipe($.if(args.verbose, $.print()))
      .pipe($.jscs())
      .pipe($.jshint())
      .pipe($.jshint.reporter('jshint-stylish', {verbose:true}))
      .pipe($.jshint.reporter('fail'))
    ;

});

gulp.task('compass', function() {
    log('Compling SASS --> CSS');
    return gulp.src(config.sass)
        .pipe($.plumber())
        .pipe($.compass(config.compassConfig))
        .pipe($.autoprefixer({browsers: ['last 2 version', '> 5%']}))
        .pipe(gulp.dest(config.build + 'assets/css'));
});

gulp.task('coffee', function() {
    log('Compling COFFEE --> JS');
    return gulp.src('./src/**/*.coffee')
        .pipe($.plumber())
        .pipe($.coffee())
        .pipe(gulp.dest(config.temp));
});

gulp.task('templatecache', function() {
    log('Creating AngularJS $templateCache');
    return gulp
        .src(config.htmltemplates)
        .pipe($.minifyHtml({empty:true}))
        .pipe($.angularTemplatecache(
            config.templateCache.file,
            config.templateCache.options
        ))
        .pipe(gulp.dest(config.temp))
        ;
});


gulp.task('fonts', function() {
    log('Copying fonts');
    return gulp
        .src(config.fonts)
        .pipe(gulp.dest(config.build + 'assets/fonts'))
        ;
});

gulp.task('sprites', function () {
  log('Creating spritesheets and scss mixins');
  var spriteData = gulp.src(config.sprites.src)
    .pipe($.spritesmith(config.sprites.options));
  // Deliver spritesheets to folder as they are completed
  spriteData.img.pipe(gulp.dest(config.sprites.imgDest));
  // Deliver CSS to to be imported
  return spriteData.css.pipe(gulp.dest(config.sprites.scssDest));
});

gulp.task('images', function() {
  log('Copying and compressing images');
  return gulp
    .src(config.images)
    //.pipe($.imagemin({optimizationLevel:4}))
    .pipe(gulp.dest(config.build + 'assets/images'))
    ;
});

gulp.task('wiredep', function() {
    log('Wire up the bower css and js and our app js into the html');
    var options = config.getWiredepDefaultOptions();
    var wiredep = require('wiredep').stream;
    return gulp
        .src(config.index)
        .pipe(wiredep(options))
        .pipe(gulp.dest(config.build + 'layouts/'))
        ;
});

gulp.task('clean-tmp', function(done) {
    var files = [].concat(
        config.temp + '**/*'
    );
    clean(files, done);
});

gulp.task('inject', gulp.series(
    'clean-tmp',
    'wiredep',
    gulp.parallel('coffee', 'templatecache', 'compass'),
    function() {
        log('Inject coffee, templateCache, and sass (all compiled) into the html');
        return gulp
            .src(config.index)
            .pipe($.inject(gulp.src(config.js)))
            .pipe($.inject(gulp.src(config.css)))
            .pipe(gulp.dest(config.build + 'layouts/'))
            ;
    }
));

gulp.task('clean-build', function(done) {
    var files = [].concat(
        config.build + '**/*'
    );
    clean(files, done);
});


gulp.task('pages', function() {
  log('Copying pages');
  return gulp
    .src(config.src + 'pages/**')
    .pipe(gulp.dest(config.build + 'pages/'))
    ;
});

gulp.task('partials', function() {
  log('Copying partials');
  return gulp
    .src(config.src + 'partials/**')
    .pipe(gulp.dest(config.build + 'partials/'))
    ;
});

gulp.task('meta', function() {
  log('Copying composer.json and theme.yaml');
  return gulp
    .src([config.src + 'theme.yaml'])
    .pipe(gulp.dest(config.build))
    ;
});

gulp.task('layout', function() {
  log('Copying default layout');
  return gulp
    .src(config.src + 'layouts/**')
    .pipe(gulp.dest(config.build + 'layouts/'))
    ;
});

gulp.task('build', gulp.series(
  'clean-build',
  gulp.parallel('pages', 'partials', 'meta', 'layout'),
  gulp.parallel('fonts', 'images'),
  'wiredep',
  'inject',
  function() {
    log('Building all');
    return gulp
      .src(config.index)
      .pipe($.plumber())
      .pipe(gulp.dest(config.build + 'layouts/'))
      ;
  }
));

gulp.task('cssfix', function() {
  log('Fixing assets sources to work with octobercms');
  return gulp
    .src(config.index)
    .pipe($.plumber())
    .pipe($.regexReplace({
      regex:'(/build/assets/.*/.*)\"',
      replace: function (match) {
        return '{{ \'' + match.replace('/build/', '') + '\' | theme }}';
      }}))
    .pipe(gulp.dest(config.build + 'layouts/'))
    ;
});


gulp.task('optimize', gulp.series('build', 'cssfix', function() {
    log('Optimizing the js, css and html');
    var assets = $.useref.assets({searchPath: './'});
    var cssFilter = $.filter('**/*.css');
    var jsLibFilter = $.filter('**/lib.js');
    var jsAppFilter = $.filter('**/app.js');

    return gulp
        .src(config.index)
        .pipe($.plumber())
        .pipe(assets)
        .pipe(cssFilter)
        .pipe($.csso())
        .pipe(cssFilter.restore())
        .pipe(jsLibFilter)
        .pipe($.uglify())
        .pipe(jsLibFilter.restore())
        .pipe(jsAppFilter)
        .pipe(jsAppFilter.restore())
        .pipe($.rev())
        .pipe(assets.restore())
        .pipe($.useref())
        .pipe($.revReplace({replaceInExtensions: ['.htm']}))
        .pipe($.regexReplace({
            regex:'(\.{2}/assets/.*/.*)\"',
            replace: function (match) {
                return '{{ \'' + match.replace('../', '') + '\' | theme }}';
            }}))
        .pipe(gulp.dest(config.build + 'layouts/'))
        .pipe($.rev.manifest())
        .pipe(gulp.dest(config.build))
        ;
}));

gulp.task('rsync', gulp.series('optimize', function() {
    return gulp.src(config.build)
        .pipe($.rsync(config.rsyncOptions));
}));


gulp.task('serve-dev', gulp.series('build', 'cssfix', function() {
  startBrowserSync(true, false);
}));


gulp.task('serve-dev2', gulp.series('build', 'cssfix', function() {
  startBrowserSync(true, true);
}));

gulp.task('bump', function() {
    var type = args.type;
    var version = args.version;
    var options = {};
    if (version) {
        options.version = version;
    } else {
        options.type = type;
    }

    return gulp
        .src(config.packages)
        .pipe($.bump(options))
        .pipe(gulp.dest(config.root))
        ;

});


////////////////

function changeEvent(event) {
  //var srcPattern = new RegExp('/.*(?=/' + config.source + ')/');
  //log('File ' + event.path.replace(srcPattern, '') + ' ' + event.type);
}


function startBrowserSync(isDev, server) {
    if (args.nosync || browserSync.active) {
        return;
    }

    log('Start browser-sync on port ' + port);

    if (isDev) {
        gulp.watch(
                [config.html],
                gulp.series('build', 'cssfix', browserSync.reload)
            )
            .on('change', function(event) { changeEvent(event);});
        gulp.watch([config.htmltemplates], gulp.series('templatecache'))
            .on('change', function(event) { changeEvent(event);});
        gulp.watch([config.allSass], gulp.series('compass'))
            .on('change', function(event) { changeEvent(event);});
        gulp.watch([config.coffee], gulp.series('coffee'))
            .on('change', function(event) { changeEvent(event);});
    } else {
        gulp.watch(
                [config.sass, config.coffee, config.htmltemplates, config.js, config.html],
                gulp.series('optimize', browserSync.reload)
            )
            .on('change', function(event) { changeEvent(event);});
    }

    var options = {
        port: 3000,
        files: isDev ? [
            config.temp + '**/*.js',
            config.build + '**/*.css'
        ] : [],
        ghostMode: {
            clicks: true,
            location: false,
            forms: true,
            scroll: true
        },
        injectChanges: true,
        logFileChanges: true,
        notify: true,
        reloadDelay: 1000
    };

    if(server){
      options['server'] = {
        baseDir: './',
        middleware: function (req, res, next) {
          if (!fs.existsSync('./'+req._parsedUrl.pathname)) {
            console.log('not exists');
            req.url = "/index.html";
          }
          next();
        }
      };
    }else{
      options['proxy'] = 'agroapex.dev';
    }


    browserSync(options);
}

function clean(path, done) {
    log('Cleaning : ' + $.util.colors.blue(path));
    del(path, done);
}

function log(msg) {
    if (typeof(msg) === 'object') {
        for (var item in msg) {
            if (msg.hasOwnProperty(item)) {
                $.util.log($.util.colors.blue(msg[item]));
            }
        }

    }else {
        $.util.log($.util.colors.blue(msg));
    }
}
