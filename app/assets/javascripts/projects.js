$(document).ready(function() {
  $('#invite-user-btn').on('click', function() {
      if($('#invite-user-div').is(':hidden')) {
          $('.left-div').removeClass('col-md-10').addClass('col-md-7');
          $('.right-div').removeClass('col-md-2').addClass('col-md-5');
          $('#invite-user-div').delay(400).slideDown('fast');

          $('#invitation_email').val('');
          $('#invitation_profile').find('option[value="2"]').attr("selected",true);
          $('#invitation_profile option').each(function() {
             $(this).html(I18n.t($(this).html()));
          });
      }
      else {
          $('#invite-user-div').slideUp('fast', function() {
              $('.left-div').removeClass('col-md-7').addClass('col-md-10');
              $('.right-div').removeClass('col-md-5').addClass('col-md-2');
          });
      }
  });
  
  $('.projects_table .table tr td.proj').on('click', function() {
	 link = $(this).parent().attr('id');
	 location.href = link;
  });

  $('.container').on('click', '.pr_file', function() {
      row_element = $(this).parent();
      project_id = row_element.attr('rel');
      file_id = row_element.find('td:first-child').attr('rel');
      doc_title = row_element.find('td:nth-child(2)').text();
      main_btn_txt = row_element.find('td:first-child').text().trim().length == 0 ? I18n.t("set_main_file") : I18n.t("unset_main_file");
      bootbox.dialog({
          title: I18n.t("file_actions_title"),
          message: I18n.t("file_actions_message") + '"' + doc_title + '"' + I18n.t("question_mark"),
          buttons: {
              set_main: {
                  label: main_btn_txt,
                  className: "btn-danger",
                  callback: function() {
                      btn_text = $(this).find('.btn-danger').text().trim().toLowerCase();
                      should_set = btn_text.substring(0, btn_text.indexOf(' ')) == 'set' ? true : false;
                      is_basic = 0;
                      if(should_set) {
                          text_prefix = I18n.t("set_main_file_prefix");
                          text_suffix = I18n.t("set_main_file_suffix");
                          is_basic = 1;
                      }
                      else {
                          text_prefix = I18n.t("unset_main_file_prefix");
                          text_suffix = I18n.t("unset_main_file_suffix");
                      }

                      $(".bootbox").on('hidden.bs.modal', function () {
                          bootbox.confirm(text_prefix + '"' + doc_title + '"' + text_suffix +
                                          I18n.t("question_mark"), function(result) {
                              if(result) {
                                  $(".bootbox").on('hidden.bs.modal', function () {
                                      setMainFile(project_id, file_id, is_basic);
                                  });
                              }
                          });
                      });
                  }
              },
              view_file: {
                  label: I18n.t("view_file"),
                  className: "btn-success",
                  callback: function() {
                      $(".bootbox").on('hidden.bs.modal', function () {
                          openFile(project_id, file_id);
                      });
                  }
              }
          }
      });
  });

  $('.container').on('click', '.vis_file', function() {
    if($(this).hasClass('s_file')) {
        row_element = $(this).parent();
        project_id = row_element.attr('rel');
        file_id = row_element.find('td:first-child').attr('rel');
        doc_title = row_element.find('td:nth-child(2)').text();
        bootbox.dialog({
            title: I18n.t("search_file_title"),
            message: I18n.t("search_file_message") + " \"" + doc_title + "\"" + I18n.t("question_mark"),
            buttons: {
                cancel: {
                    label: I18n.t("cancel"),
                    className: "btn-default",
                },
                view_file: {
                    label: I18n.t("ok"),
                    className: "btn-primary",
                    callback: function() {
                        $(".bootbox").on('hidden.bs.modal', function () {
                            openFile(project_id, file_id);
                        });
                    }
                }
            }
        });
    }
  });

  function openFile(project_id, file_id) {
      window.open('/projects/'+project_id+'/project_files/'+file_id, '_self');
  }
  
  $('#file_btn').on('click', function() {
  	if($(this).text() == I18n.t('upload_file')) {
        $('#upload_form #project_file_filename').click();
    }
  	else {
        uploadFile = document.getElementById("project_file_filename").files[0];
        uploadFileType = uploadFile.type;
        validFile = false;
        for(i = 0; i < allowedFileTypes.length; i++) {
            if(uploadFileType === allowedFileTypes[i]) {
                $('#project_file_extension').val(fileExtensions[uploadFileType]);
                validFile = true;
                break;
            }
        }

        if(!validFile) {
            $('#upload_form #project_file_filename').value = '';
            $('#project_file_extension').val('');
            this.form.reset();
            bootbox.alert(I18n.t('not_allowed_file'));
        }
        else {
            $('#upload_form').submit();
        }
    }
  });
  
  $('#upload_form #project_file_filename').on('change', function(){
  	if($(this).val() != '') {
        uploadFile = this.files[0];
        uploadFileType = uploadFile.type;
        validFile = false;
        for(i = 0; i < allowedFileTypes.length; i++) {
            if(uploadFileType === allowedFileTypes[i]) {
                validFile = true;
                break;
            }
        }

        if(!validFile) {
            this.value = '';
            // $('#upload_form').reset();
            bootbox.alert(I18n.t('not_allowed_file'));
        }
        else {
            $('#file_btn').text(I18n.t('upload') + ' ' + $(this).val());
            $('#file_btn').removeClass('btn-success').addClass('btn-danger');
        }
    }
	else {
        $('#file_btn').text(I18n.t('upload_file'));
        $('#file_btn').removeClass('btn-danger').addClass('btn-success');
    }
  });

  function setMainFile(project_id, file_id, is_basic) {
      $.ajax({
          url: "/projects/"+project_id+"/project_files/"+file_id+"/set_main",
          cache: false,
          type: "post",
          data: { is_basic: is_basic },
          dataType: "text",
          beforeSend: function() {

          },
          success: function(response) {
              if(response == 1) {
                  if(is_basic == 1) {
                      $(".pr_file[rel="+file_id+"]").text('[' + I18n.t("main_file") + ']');
                  }
                  else if(is_basic == 0) {
                      $(".pr_file[rel="+file_id+"]").text('');
                      $(".pr_file[rel="+file_id+"]").parent().find('.show-history').html('');
                  }
              }
              else if(response == 0) {
                  bootbox.alert()("Error!!!" + response);
              }
              else {
                  bootbox.alert(response);
              }
          },
          error: function(response) {
              bootbox.alert("Error!!!" + response);
          }
      });
  }
    // checkInvitations();
});