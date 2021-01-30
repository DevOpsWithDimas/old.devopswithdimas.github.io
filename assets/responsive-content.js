$(document).ready(function () {
    $('.materialboxed').materialbox();
    $(".dropdown-button").dropdown();
    $('.scrollspy').scrollSpy();
    $(".button-collapse").sideNav({
        menuWidth: 400
    });
    $('.collapsible').collapsible();
    $('.modal').modal({
        dismissible: false
    });
    $('.tooltipped').tooltip({ delay: 50 });
    $('.post-body img').addClass('materialboxed').addClass('responsive-img');
    $('.post-body table').addClass('striped').addClass('highlight').addClass('responsive-table');

});