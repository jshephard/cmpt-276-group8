// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function reset_textbox_background(form_label) {
    $('#' + form_label + 'form').find('input:text').css("background-color", "");
    $('#' + form_label + 'form').find('input:password').css("background-color", "");
}

function render_errors(form_label, error) {
    reset_textbox_background(form_label);

    var html = '<h3>' + Object.keys(error.messages).length + ' errors occurred:</h3>';
    html += '<ul>';
    $.each(error.messages, function(key, value) {
        html += '<li>' + value + '</li>';
    });

    $.each(error.errors, function(key, value) {
        $('#' + form_label + key).css("background-color", "red");
    });

    html += '</ul>';
    return html;
}