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