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
//= require bootstrap-sprockets
//= require turbolinks
//= require bootbox.min
//= require pnotify.custom.min
//= require i18n
//= require i18n/translations
//= require_tree .

$(document).ready(function(){
    // PNotify.prototype.options.styling = "fontawesome";
    $('.container').on('click', '#sign-in', function(){
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
            '<div class="form-group">'+
            '<div class="controls col-md-offset-2 col-md-6">'+
            '<button type="button" class="btn btn-success" id="sign-in-btn">'+I18n.t("sign_in")+'</button>'+
            '</div>'+
            '</div>'+
            '</form>'+
            '<script type="text/javascript">'+
            '$(".modal").on("shown", function(){'+
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

    $('#search').on('focus', function(){
        if($( document ).width() > 630)
            $(this).parent().addClass('has-success');
            $(this).css('width', '380px').css('background-color', '#FFF').css('border', '1px solid #67b168');
    });

    $('#search').on('blur', function(){
        $(this).parent().removeClass('has-success');
        $(this).css('width', '200px').css('background-color', '#EEE').css('border', '1px solid #ccc');
    });

    $(document).keypress(function(e){
        if($('#search').is(':focus') && (e.which == 13 || e.keycode == 13)){
            var question = $("#search").val();
            $("#warning").remove();
            $.ajax({
                url: "/static_pages/search?question="+question,
                cache: false,
                type: "get",
                dataType: "json",
                success: function(result) {
                    if (result.illegal) {
                        $("#main").prepend("<div id='alert' class='message'>Only registered users can search for other users and/or projects.</div>");
                    }
                    else {
                        header = "<h4>Search Results</h4>";
                        projects_header = "<h5>Projects</h5>";
                        users_header = "<h5>Users</h5>";
                        // Parse Users
                        users = "";
                        if (result.users.length == 0)
                            users = "No results found";
                        else {
                            users = "<ol>";
                            for (i = 0; i < result.users.length; i++)
                                users += "<li><a href='/users/" + result.users[i].id + "'>" + result.users[i].username + "</a></li>";
                            users += "</ol>";
                        }

                        // Parse Projects
                        projects = "";
                        if (result.projects.length == 0)
                            projects = "No results found";
                        else{
                            projects = "<ol>";
                            for (i = 0; i < result.projects.length; i++)
                                projects += "<li><a href='/projects/" + result.projects[i].id + "'>" + result.projects[i].title + "</a></li>";
                            projects += "</ol>";
                        }

                        $('#main').html(
                            header+
                            projects_header+
                            projects+
                            users_header+
                            users
                        );
                    }
                }
            });
        }
    });

    /*
    $(function(){
        new PNotify({
            title: 'Regular Notice',
            text: 'Check me out! I\'m a notice.'
        });
    });
    */
});

function signIn() {
    $("#warning").remove();
    $.ajax({
        url: "check_login",
        cache: false,
        type: "post",
        data: "user[username]=" + $('#inputUsername').val() + "&user[password]=" + $('#inputPassword').val(),
        dataType: "json",
        success: function(user) {
            if (user.id > 0){
                location.href = "projects"; // "http://localhost:3000";
            }
            else if (user.id == 0){
                $(".modal").modal("hide");
                $("#main").prepend("<div id='alert' class='message'>Please activate your account by following the link you will find at your email.</div>");
            }
            else{
                $('#sign-in-error').text(I18n.t("invalid_credentials")).animate({ opacity: 1}, 400);
            }
        }
    });
}