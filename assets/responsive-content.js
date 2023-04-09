$(document).ready(function () {
    $('#article-body img').addClass('materialboxed').addClass('responsive-img');
    $('#archive-body img').addClass('responsive-img');
    $('#article-body svg').addClass('materialboxed').addClass('responsive-img');
    $('.post-body table')
        // not for highlight
        .not('pre > code > table')
        // not for gist
        .not('table.highlight.tab-size.js-file-line-container')
            .addClass('striped')
            .addClass('highlight')
            .addClass('responsive-table');
});