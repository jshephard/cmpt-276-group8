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
//= require jquery-ui/datepicker
//= require jquery-ui/slider
//= require bootstrap
//= require turbolinks
//= require_tree .
//= require underscore
//= require gmaps/google
function reset_textbox_background(form_label) {
    $('#' + form_label + 'form').find('input').css("background-color", "");
}

function create_alert_box (type, message) {
    return '<div class="alert alert-dismissible alert-' + type +
        '"><button type="button" class="close" data-dismiss="alert">×</button><b>' + message + '</b></div>';
}

function render_errors(form_label, error) {
    reset_textbox_background(form_label);

    var html = '<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">×</button><h4>' + Object.keys(error.messages).length + ' error(s) occured:</h4>';
    html += '<ul>';
    $.each(error.messages, function(key, value) {
        html += '<li>' + value + '</li>';
    });
    $.each(error.errors, function(key, value) {
        $('#' + form_label + key).css("background-color", "#d9534f");
    });

    html += '</ul></div>';
    return html;
}