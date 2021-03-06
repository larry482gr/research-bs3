/**
 * Copyright 2015 Kazantzis Lazaros
 */

$(document).ready(function() {
  $('#invite-user-btn').on('click', function() {
      if($('#invite-user-div').is(':hidden')) {
          $('.left-div').removeClass('col-md-10').addClass('col-md-9');
          $('.right-div').removeClass('col-md-2').addClass('col-md-3');
          $('#invite-user-div').delay(400).slideDown('fast');

          $('#invitation_email').val('');
          $('#invitation_profile').find('option[value="2"]').attr("selected",true);
          $('#invitation_profile option').each(function() {
             $(this).html(I18n.t($(this).html()));
          });
      }
      else {
          $('#invite-user-div').slideUp('fast', function() {
              $('.left-div').removeClass('col-md-9').addClass('col-md-10');
              $('.right-div').removeClass('col-md-3').addClass('col-md-2');
          });
      }
  });

  $('.container').on('click', '.pr_file', function() {
      row_element = $(this).parent();
      project_id = row_element.attr('rel');
      file_id   = row_element.find('td:first-child').attr('rel');
      doc_title = row_element.find('td:nth-child(2)').text();
      doc_ext   = row_element.find('td:nth-child(2)').attr('rel');
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
                          openFile(project_id, file_id, doc_ext);
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
                    className: "btn-default"
                },
                view_file: {
                    label: I18n.t("ok"),
                    className: "btn-primary",
                    callback: function() {
                        $(".bootbox").on('hidden.bs.modal', function () {
                            openFile(project_id, file_id, '');
                        });
                    }
                }
            }
        });
    }
  });

  function openFile(project_id, file_id, ext) {
      var target;
      if(ext == 'lnk') {
          target = '_blank';
      }
      else {
          target = '_self';
      }

      window.open('/projects/'+project_id+'/project_files/'+file_id, target);
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
            $('#clear-file').html(I18n.t('uploading_file') + ' ' + $('#upload_form #project_file_filename').val() + "<img class='loader_icon' id='file_loader' src='/assets/loader.gif' width='14px' height='14px' />");
            $('#clear-file').attr('id', 'uploading-file');
        }
    }
  });

  $('#link_btn').on('click', function() {
      if($('#add-link-fields').is(':visible')) {
          alert('Should submit form...');
      }
      else {
          $(this).removeClass('btn-link').addClass('btn-success');
          $(this).text($(this).text().substring(0, $(this).text().length-3));
          $('#add-link-fields').animate({width: 'toggle'}, 200);
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
            document.getElementById('upload_form').reset;
            bootbox.alert(I18n.t('not_allowed_file'));
        }
        else {
            $('#file_btn').text(I18n.t('upload') + ' ' + $(this).val());
            $('#file_btn').removeClass('btn-primary').addClass('btn-danger');
            $('#clear-file').show();
        }
    }
	else {
        $('#file_btn').text(I18n.t('upload_file'));
        $('#file_btn').removeClass('btn-danger').addClass('btn-primary');
    }
  });

  $('#clear-file').on('click', function(e){
      e.preventDefault();
      $('#upload_form #project_file_filename').value = '';
      $('#project_file_extension').val('');
      document.getElementById('upload_form').reset;
      $('#file_btn').text(I18n.t('upload_file'));
      $('#file_btn').removeClass('btn-danger').addClass('btn-primary');
      $('#clear-file').hide();
  });

  if(typeof $('#select-source').val() != 'undefined' && $('#select-source').val() != 'gs') {
      if($('#select-source').val() != 'ieee') {
          getListSet($('#select-source').val());
          $('#search_gs_form p.help-block').show();
      }

      $('#search_gs_more').hide();
  }

  $('#select-source').on('change', function() {
     $('.search_gs_results div').html('');
     $('.paging div').hide();
     $('#search_gs_more').hide();
     if($(this).val() == 'gs') {
         removeOpenSearchList();
         $('#search_gs_more').show();
     } else if ($(this).val() == 'ieee') {
         removeOpenSearchList();

         // alert('Get IEEE results...');
     } else {
         $('#search_gs_form p.help-block').show();
         getListSet($(this).val());
     }
  });

  function removeOpenSearchList() {
      $('.search_div').find('#opensearch-listset').slideUp('fast', function() {
          $('#search_gs_form p.help-block').hide();
          $(this).remove();
      });
  }

  function getListSet(repo) {
      $.ajax({
          url: "/open_search/list_sets/"+repo,
          cache: true,
          type: 'get',
          dataType: "json",
          beforeSend: function() {
              $('.search_div').find('#opensearch-listset').remove();
          },
          success: function(listSet) {
              listContent = '<form class="form-inline">';

              for(i = 0; i < listSet.length; i++) {
                  listContent += getListCheckbox(listSet[i].set_key, listSet[i].set_val);
              }

              listContent += '</form>';

              $('#select-source-div').after('<div id="opensearch-listset" class="col-md-12 jumbotron">' +
                                                '<h4>'+I18n.t('search_sources.pick_list')+'</h4>' + listContent +
                                            '</div>');

              $('#opensearch-listset').slideDown('fast', function(){
                  if($('html').height() < $(window).height()) {
                      $('.footer').css('position', 'absolute');
                  }
                  else {
                      $('.footer').css('position', 'relative');
                  }
              });
          }
      });
  }

  function getListCheckbox(set_key, set_val) {
        return  '<div class="form-group col-md-12">' +
                    '<div class="checkbox">' +
                        '<label>' +
                            '<input type="checkbox" rel="' + set_key + '">&nbsp;&nbsp;'+ set_val +
                        '</label>' +
                    '</div>' +
                '</div>';
  }

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