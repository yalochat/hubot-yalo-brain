const gulp = require('gulp')
const mocha = require('gulp-mocha')

gulp.task('test', () => {    
    gulp.src('test/*.coffee')
    .pipe(mocha({        
        compilers: 'coffee:coffee-script/register'
    }))
})
