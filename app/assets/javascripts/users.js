$(document).ready(function() {
    $('.users_table').on('click', '.delete-user', function() {
        var formAction = $(this).attr('rel');
        var message_text = '<form id="delete-user-form" action"'+formAction+'" method="delete" onsubmit="return false;">'+
            '<div class="form-group">'+
                '<label class="control-label" for="reason">'+I18n.t("reason")+'</label>'+
                '<select id="reason" name="reason" class="form-control">'+
                    $('#delete-user-options').val()+
                '</select>'+
            '</div>'+
            '</form>';

        bootbox.dialog({
            title: I18n.t("delete_user"),
            message: message_text,
            buttons: {
                cancel: {
                    label: I18n.t("cancel"),
                    className: "btn btn-default"
                },
                del: {
                    label: I18n.t("delete"),
                    className: "btn btn-danger",
                    callback: function () {
                        deleteUser(formAction, $('.modal').find('#reason').val());
                    }
                }
            }
        });
    });
});

function checkInvitations() {
    $.ajax({
        url: "/invitations",
        cache: false,
        type: "get",
        dataType: "json",
        success: function(invitations) {
            if (invitations.length > 0) {
                for(i = 0; i < invitations.length; i++) {
                    user = '';
                    if(invitations[i].user.first_name != null && invitations[i].user.first_name.trim().length > 0) {
                        user += invitations[i].user.first_name.trim();
                    }
                    if(invitations[i].user.last_name != null && invitations[i].user.last_name.trim().length > 0) {
                        user += ' ' + invitations[i].user.last_name.trim();
                    }

                    email = invitations[i].user.email.trim();
                    user = user.trim().length == 0 ? email : user + ' (' + email + ')';


                    text = 'You have been invited by ' + user + ' to participate in ' + invitations[i].project.project_title;
                    date = invitations[i].date;
                    $(function() {
                        new PNotify({
                            title: 'Invitation (sent at ' + date + ')',
                            text: text
                        });
                    });
                }
            }
        }
    });
}

function signIn() {
    $("#warning").remove();
    $.ajax({
        url: "check_login",
        cache: false,
        type: "post",
        data: "user[username]=" + $('#inputUsername').val() + "&user[password]=" + $('#inputPassword').val(),
        dataType: "json",
        success: function(user) {
            if (user.id > 0) {
                location.href = "projects"; // "http://localhost:3000";
            }
            else if (user.id == 0){
                $(".modal").modal("hide");
                $("#main").prepend("<div id='alert' class='message'>Please activate your account by following the link you will find at your email.</div>");
            }
            else if (user.id == -1){
                $(".modal").modal("hide");
                $("#main").prepend("<div id='alert' class='message'>Your account has been blacklisted. Please contact us at <a href='mailto:info@research.org.gr'>info@research.org.gr</a> if you need more information.</div>");
            }
            else{
                $('#sign-in-error').text(I18n.t("invalid_credentials")).animate({ opacity: 1}, 400);
            }
        }
    });
}

function deleteUser(url, comment) {
    $.ajax({
        url: url,
        cache: false,
        type: "delete",
        data: "user[id]="+url.substring(url.lastIndexOf('/'))+"&comment=" + comment,
        dataType: "json",
        success: function(response) {
            if(response.deleted == 1) {
                location.href = url.substring(0, url.lastIndexOf('/'));
            }
            else {
                location.href = url.substring(0, url.indexOf('/'));
            }
        },
        error: function(response) {
            bootbox.alert('Error!!!');
        }
    });
}

function populateAutocompleteUsers(element) {
    $.ajax({
        url: '/users_autocomplete',
        type: "get",
        cache: false,
        dataType: "json",
        success: function(users) {
            element.autocomplete({
                minLength: 1,
                source: function(request, response) {
                    var matches = $.map(users, function(userItem) {
                        if (userItem.email.toLowerCase().indexOf(request.term.toLowerCase()) === 0) {
                            return userItem;
                        }
                    });
                    response(matches);
                },
                // focus: function(event, ui) {
                    // element.val(ui.item.email); //  + ' (' + ui.item.username + ')');
                    // return false;
                //},
                select: function(event, ui) {
                    element.val(ui.item.email); // + ' (' + ui.item.username + ')');
                    element.attr('rel', ui.item.email);
                    return false;
                }
            })
                .data("ui-autocomplete")._renderItem = function(ul, item) {
                return $("<li></li>")
                    .append("<a style='font-size: 12px !important; font-weight: normal; cursor: pointer;'>" +
                    "<span style='color: #01ade4'>" + item.email.substring(0, element.val().length) + "</span>" +
                    item.email.substring(element.val().length) /* + " (" + item.username + ')' */ + "</a>")
                    .appendTo(ul);
            };
        }
    });
}