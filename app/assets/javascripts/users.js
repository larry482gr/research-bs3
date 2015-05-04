$(document).ready(function() {
    $('.users_table').on('click', '.delete-user', function() {
        var formAction = $(this).attr('rel');
        var message_text = '<form id="delete-user-form" action"'+formAction+'" method="delete" onsubmit="return false;">'+
            '<div class="form-group">'+
                '<label class="control-label" for="reason">'+I18n.t("reason")+'</label>'+
                '<select id="reason" name="reason" class="form-control">'+
                    $('#delete-user-options').val()+
                '</select>'+
                '<input type="hidden" name="authenticity_token" value="'+AUTH_TOKEN+'" />'+
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

    $('.navbar-right').on('click', '.invitation-btn', function() {
        user_id = $(this).parent().attr('rel');
        invitation_id = $(this).attr('rel');

        if($(this).hasClass('btn-success')) {
            updateInvitation(user_id, invitation_id, 'accepted', null);
        }
        else if($(this).hasClass('btn-danger')) {
            invitationModal(user_id, invitation_id, 'discard');
        }
        else if($(this).hasClass('btn-default')) {
            invitationModal(user_id, invitation_id, 'report');
        }
    });
});

function validateEmail(elementValue) {
    var emailPattern = /^[a-zA-Z0-9\._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    return emailPattern.test(elementValue);
}

function checkInvitations() {
    $.ajax({
        url: "/invitations",
        cache: false,
        type: "get",
        dataType: "json",
        success: function(invitations) {
            if (invitations.length > 0) {
                content = '';
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


                    text = I18n.t("invited") + ' <i>' + user + '</i> '+I18n.t("participate")+' <b>"' + invitations[i].project.project_title + '"</b>';
                    date = invitations[i].date;

                    content += getInvitationRow(invitations[i].user.id, invitations[i].id, text, date);
                }

                invitation_template = '<div class="popover invitation-popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>';

                $('#invitations-link').popover({
                    template: invitation_template,
                    content: content,
                    html: true,
                    placement: 'bottom',
                    trigger: 'focus'
                });
            }
        }
    });
}

function getInvitationRow(user_id, id, text, date) {
    accept_btn  = '<button type="button" class="invitation-btn btn btn-xs btn-success" rel="'+id+'">'+I18n.t("accept")+'</button>';
    discard_btn = '<button type="button" class="invitation-btn btn btn-xs btn-danger" rel="'+id+'">'+I18n.t("discard")+'</button>';
    report_btn  = '<button type="button" class="invitation-btn btn btn-xs btn-default pull-right" rel="'+id+'">'+I18n.t("report")+'</button>';

    // invitation  = '<span class="help-block">'+date+'</span>';
    invitation = '<div class="invitation-popover-text">'+text+'</div>';
    invitation += '<div class="invitation-popover-buttons" rel="'+user_id+'">'+accept_btn+' '+discard_btn+' '+report_btn+'</div>';

    return invitation;
}

function invitationModal(user_id, invitation_id, status) {
    other_position = status == "discard" ? 2 : 3;
    var message_text = '<form id="abort-invitation" onsubmit="return false;">' +
        '<div class="form-group">' +
        '<label class="control-label" for="reason">'+I18n.t("reason")+'</label>' +
        '<select id="reason" name="reason" class="form-control">' +
        $('#'+status+'-options').val() +
        '</select>' +
        '</div>' +
        '<div class="form-group">' +
            '<textarea class="form-control" rows="2"></textarea>' +
        '</div>' +
        '<input type="hidden" name="authenticity_token" value="'+AUTH_TOKEN+'" />'+
        '</form>' +
        '<script type="text/javascript">' +
            '$("#abort-invitation").on("change", "#reason", function(){' +
                'if($(this).val() == I18n.t("'+status+'_comment.'+other_position+'")) {' +
                    '$("#abort-invitation textarea").show();' +
                    '$("#abort-invitation textarea").before("<div>' +
                                    '<div><span class=\'help-block\'>'+I18n.t("write_comment")+'</span></div>' +
                                    '<div><span class=\'help-block error-block\'></span></div>' +
                                '</div>")' +
                '}' +
                'else {' +
                    '$("#abort-invitation textarea").prev().remove();' +
                    '$("#abort-invitation textarea").hide();' +
                '}' +
            '});' +
            '$("#abort-invitation textarea").on("focus", function(){' +
                '$(".modal").find("#abort-invitation .error-block").html("");' +
            '});'
        '</script>';

    bootbox.dialog({
        title: I18n.t(status+"_invitation"),
        message: message_text,
        buttons: {
            cancel: {
                label: I18n.t("cancel"),
                className: "btn btn-default"
            },
            del: {
                label: I18n.t("ok"),
                className: "btn btn-success",
                callback: function () {
                    if($('.modal').find('#reason').val() == I18n.t(status+"_comment."+other_position) &&
                        $('.modal').find("#abort-invitation textarea").val().trim().length == 0) {
                            $('.modal').find("#abort-invitation .error-block").html(I18n.t("provide_comment"));
                            return false;
                    }
                    else if($('.modal').find('#reason').val() == I18n.t(status+"_comment."+other_position) &&
                        $('.modal').find("#abort-invitation textarea").val().trim().length > 200) {
                            $('.modal').find("#abort-invitation .error-block").html(I18n.t("large_comment"));
                            return false;
                    }
                    else {
                        reason = $('.modal').find('#reason').val();
                        if(reason == I18n.t(status+"_comment."+other_position)) {
                            reason += ' (' + $('.modal').find("#abort-invitation textarea").val().trim() + ')';
                        }
                        updateInvitation(user_id, invitation_id, status+'ed', reason);
                    }
                }
            }
        }
    });
}

function updateInvitation(user_id, invitation_id, status, reason) {
    $.ajax({
        url: '/users/'+user_id+'/invitations/'+invitation_id,
        type: 'patch',
        data: {
            'invitation[status]': status,
            'invitation[reason]': reason
        },
        dataType: 'json',
        success: function(result) {
            if(result.error_code == 0) {
                if(result.status == 'accepted') {
                    location.href = '/projects';
                }
                else {
                    location.reload();
                }
            }
            else {
                bootbox.alert("Message was: " + result.error_code);
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
                $("#main").prepend("<div id='alert' class='message'>"+I18n.t("activation_reminder")+"</div>");
            }
            else if (user.id == -1){
                $(".modal").modal("hide");
                $("#main").prepend("<div id='alert' class='message'>"+I18n.t("account_blacklisted")+"</div>");
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
            bootbox.alert(response);
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