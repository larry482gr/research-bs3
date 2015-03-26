$(document).ready(function() {
  var allowedFileTypes = ['application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                          'application/msword', 'application/vnd.oasis.opendocument.text', 'text/plain', 'text/rtf'];

  var fileExtensions = {
      'application/pdf' : 'pdf',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document' : 'docx',
      'application/msword' : 'doc',
      'application/vnd.oasis.opendocument.text' : 'odt',
      'text/plain' : 'txt',
      'text/rtf' : 'rtf'
  };
  
  $('.projects_table .table tr').on('click', function(){
	 link = $(this).attr('id');
	 //alert(link);
	 location.href = link;
  });

  $('.container').on('click', '.pr_file', function() {
      row_element = $(this).parent();
      project_id = row_element.attr('rel');
      file_id = row_element.find('td:first-child').attr('rel');
      doc_title = row_element.find('td:nth-child(2)').text();
      bootbox.dialog({
          title: I18n.t("file_actions_title"),
          message: I18n.t("file_actions_message") + "\"" + doc_title + "\"" + I18n.t("question_mark"),
          buttons: {
              set_main: {
                  label: I18n.t("set_main_file"),
                  className: "btn-danger",
                  callback: function() {
                      $(".bootbox").on('hidden.bs.modal', function () {
                          bootbox.confirm(I18n.t("set_main_file_prefix") + '"' + doc_title + '"' + I18n.t("set_main_file_suffix") +
                                          I18n.t("question_mark"), function(result) {
                              if(result) {
                                  $(".bootbox").on('hidden.bs.modal', function () {
                                      setMainFile(project_id, file_id);
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
                          window.open('/projects/'+project_id+'/project_files/'+file_id, '_self');
                      });
                  }
              }
          }
      });
  });
  
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
            bootbox.alert('Write message for NOT allowed file type.');
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
            $('#upload_form').reset();
            bootbox.alert('Write message for NOT allowed file type.');
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

  function setMainFile(project_id, file_id) {
      $.ajax({
          url: "/projects/"+project_id+"/project_files/"+file_id+"/set_main",
          cache: false,
          type: "post",
          data: { is_basic: 1 },
          dataType: "text",
          beforeSend: function() {

          },
          success: function(response) {
              if(response == 1) {
                  $(".pr_file").text("");
                  $(".pr_file[rel="+file_id+"]").text('[' + I18n.t("main_file") + ']');
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
});