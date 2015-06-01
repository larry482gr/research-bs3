// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.turbolinks
//= require bootstrap-sprockets
//= require bootbox.min
//= require turbolinks
//= require pnotify.custom.min
//= require i18n
//= require i18n/translations
//= require_tree .

$(document).ready(function() {
    // PNotify.prototype.options.styling = "fontawesome";

    $('.container').on('click', '#sign-in', function() {
        var message_text = '<form class="form-horizontal">'+
            '<div class="form-group">'+
            '<label class="control-label col-md-2" for="inputUsername">'+I18n.t("username")+'</label>'+
            '<div class="controls col-md-6">'+
            '<input type="text" id="inputUsername" class="form-control" placeholder="'+I18n.t("username")+'">'+
            '</div>'+
            '</div>'+
            '<div class="form-group">'+
            '<label class="control-label col-md-2" for="inputPassword">'+I18n.t("password")+'</label>'+
            '<div class="controls col-md-6">'+
            '<input type="password" id="inputPassword" class="form-control" placeholder="'+I18n.t("password")+'">'+
            '</div>'+
            '<div id="sign-in-error" class="col-md-offset-2 col-md-9"></div>'+
            '</div>'+
            '<input type="hidden" name="authenticity_token" value="'+AUTH_TOKEN+'" />'+
            '<div class="form-group">'+
            '<div class="controls col-md-offset-2 col-md-6">'+
            '<button type="button" class="btn btn-success" id="sign-in-btn">'+I18n.t("sign_in")+'</button>'+
            '</div>'+
            '</div>'+
            '</form>'+
            '<a href="/forgot_pass">'+I18n.t("forgot_pass")+I18n.t("question_mark")+'</a>'+
            '<script type="text/javascript">'+
            '$(".modal").on("shown.bs.modal", function(){'+
            '$("#inputUsername").focus();'+
            '});'+
            '$("#sign-in-btn").on("click", function(){'+
            'signIn();'+
            '});'+
            '$(".modal").keypress(function(e) {'+
            'if(e.which == 13 || e.keycode == 13)'+
            '$("#sign-in-btn").click();'+
            '});'+
            '</script>';

        bootbox.dialog({
            title: I18n.t("sign_in_modal"),
            message: message_text
        });
    });

    $('.container').on('click', '#sign-out', function() {
        location.href = "/logout";
    });

    $('#search').on('focus', function() {
        if($( document ).width() > 630)
            $(this).parent().addClass('has-success');
            $(this).css('width', '380px').css('background-color', '#FFF').css('border', '1px solid #67b168');
    });

    $('#search').on('blur', function() {
        $(this).parent().removeClass('has-success');
        $(this).css('width', '200px').css('background-color', '#EEE').css('border', '1px solid #ccc');
    });

    window.onload=function() {
        if($('html').height() < $(window).height()) {
            $('.footer').css('position', 'absolute');
        }
    }
});

function decodeHtml(html) {
    var txt = document.createElement("textarea");
    txt.innerHTML = html;
    return txt.value;
}