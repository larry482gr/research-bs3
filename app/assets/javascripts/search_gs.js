/**
 * Copyright 2015 Kazantzis Lazaros
 */

$(document).ready(function() {

    if(typeof $('#search_gs_input').val() !== 'undefined' &&  $('#search_gs_input').val().length > 0) {
        getSearchResults(1, $( "#search_gs_form").serialize());
    }

    if (!navigator.userAgent.match(/Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile/i)) {
        $('.container').on('click', '.gs_md_wp', function(e) {
            e.preventDefault();
            doc_title = $(this).parent().next().find('h3').find('a').text();
            doc_link = $(this).find('a').attr('href');
            if(doc_link.substr(doc_link.length-3).toLowerCase() === 'pdf') {
                showEmbededFile(doc_title, doc_link);
            }
            else {
                window.open($(this).attr('href'), '_blank');
            }
        });

        $('.container').on('click', '.gs_rt a', function(e) {
            e.preventDefault();
            doc_title = $(this).text();
            doc_link = $(this).attr('href');
            if(doc_link.substr(doc_link.length-3).toLowerCase() === 'pdf') {
                showEmbededFile(doc_title, doc_link);
            }
            else {
                window.open($(this).attr('href'), '_blank');
            }
        });

        function showEmbededFile(doc_title, doc_link) {
            doc_extension = doc_link.substr(doc_link.lastIndexOf('.')+1).toLowerCase();
            save_file = '<form class="save-article-form" action="/projects/'+$('#project_id').val()+'/project_files"'+
            'onsubmit="selectProject(); return false;" method="post" style="width: 900px; margin: 10px auto;">'+
            '<div class="form-group pull-right">'+
            '<input type="hidden" name="project_file[filename]" value="'+doc_title+'" />'+
            '<input type="hidden" name="project_file[filepath]" value="'+doc_link+'" />'+
            '<input type="hidden" name="project_file[extension]" value="'+doc_extension+'">' +
            '<input type="hidden" name="authenticity_token" value="'+AUTH_TOKEN+'" />'+
            '<input type="hidden" name="search_q" value="'+$('#search_gs_input').val()+'" />' +
            '<input type="submit" class="save-article-btn btn btn-primary" value="Save" />'+
            '</div>'+
            '</form>';

            bootbox.dialog({
                title: doc_title,
                message: '<object id="object-left" class="pull-left" width="100%" height="860" data="'+doc_link+'" alt="pdf" type="'+allowedFileTypes[0]+'">'+
                            '<a href="'+doc_link+'" target="_blank">'+I18n.t("no_support")+I18n.t("question_mark")+'</a>'+
                         '</object>'+
                         save_file,
                className: 'pdf_modal'
            });
        }
    }

    // Current page
    $('.paging').on('click', '.number', function() {
        var pageNumber = $(this).attr('title');
        getSearchResults(pageNumber, $( "#search_gs_form").serialize());
    });

    // paging previous
    $('.paging').on('click', '.previousPage', function() {
        var pageNumber = $(this).parent().find('.btn-primary').attr('title');
        pageNumber--;
        getSearchResults(pageNumber, $( "#search_gs_form").serialize());
    });

    // paging next
    $('.paging').on('click', '.nextPage' ,function() {
        var pageNumber = $(this).parent().find('.btn-primary').attr('title');
        pageNumber++;
        getSearchResults(pageNumber, $( "#search_gs_form").serialize());
    });

    $('.rowsPerPage').on('change', function() {
        var current_page = $('#paging_gs_results').find('button.btn-primary').attr('title');
        getSearchResults(current_page, $( "#search_gs_form").serialize());
    });

    // Search
    $('#search_gs_btn').on('click', function() {
        switch ($('#select-source').val()) {
            case 'gs':
                getSearchResults(1, $( "#search_gs_form").serialize());
                break;
            case 'helios':
                getSearchResults(1, $( "#search_gs_form").serialize());
                break;
            default:
                alert('Select a source first!');
                break;
        }
    });

    $('#search_gs_adv_btn').on('click', function() {
        if(($('#gs_asd_ylo').val().length == 0 && $('#gs_asd_yhi').val().length == 0) || (isDigit($('#gs_asd_ylo').val()) && isDigit($('#gs_asd_yhi').val()))) {
            $('#searchMoreModal').modal('hide');
            getSearchResults(1, $( "#search_more_form").serialize());
        }
        else {
            $('#search_more_form').submit();
        }
    });

    $(document).keyup(function(e) {
        if($('#search_gs_input').is(':focus') && (e.which == 13 || e.keycode == 13)) {
            getSearchResults(1, $( "#search_gs_form").serialize());
        }
    });

    $(document).keydown(function(e) {
        if($('#search_gs_input').is(':focus') && (e.which == 13 || e.keycode == 13)) {
            e.preventDefault();
        }
    });

    $('.container').on('click', '.gs_nph', function(e) {
        e.preventDefault();
    });

    function selectProject() {
        if (typeof $("#project_id").val() != "undefined")
            $(".save-article-form").submit();
        else {
            $(".bootbox").modal("hide");
            bootbox.alert(I18n.t("choose_project_article"));
        }
    }

    function getSearchResults(page, form_params) {
        var num = $('.rowsPerPage').val();
        var start = (page-1)*num;

        if($('#select-source').val() == 'gs') {
            getScholarResults(page, start, num, form_params);
        } else {
            getOpenSearchResults(page, start, num, form_params);
        }
    }

    function getScholarResults(page, start, num, form_params) {
        $.ajax({
            url: '/google_scholar/search_scholar?'+form_params+'&start='+start+'&num='+num,
            cache: false,
            type: "get",
            dataType: "json",
            beforeSend: function(){
                $('.search_gs_results').animate({opacity: 0.2});
            },
            success: function(response) {
                if (response.total == 0) {
                    $('.search_gs_results').html("<h5>" + response.results + "</h5>");
                }
                else {
                    $('.search_gs_results').html("<div><strong>Total Results:</strong> " + response.total + "</div>");
                    for(i = 0; i < response.results.length; i++) {
                        $('.search_gs_results').append(response.results[i]);
                    }
                    $('#search_gs_input').val(decodeHtml(response.search));
                }

                // checkValidSave();
                $('.search_gs_results').animate({opacity: 1});
                $('#rows_div').show();
                paging(response.total.replace(/\./g, ''), page, $('.rowsPerPage').val(), 'paging_gs_results');

                if($('html').height() < $(window).height()) {
                    $('.footer').css('position', 'absolute');
                }
                else {
                    $('.footer').css('position', 'relative');
                }
            }
        });
    }

    function checkValidSave() {
        $.each($('.container span.gs_nph'), function() {
            doc_link = $(this).parent().parent().prev().find('.gs_md_wp').find('a').attr('href');
            if(typeof doc_link === "undefined") {
                doc_link = $(this).parent().parent().find('.gs_rt').find('a').attr('href');
            }

            if(typeof doc_link !== "undefined" && doc_link.substr(doc_link.length-3).toLowerCase() !== 'pdf') {
                $(this).remove();
            }
        });
    }
});

function showCitationsModal(doc_id, doc_num, citations) {
    element_link = $('.container').find('#gs_svl' + doc_num);
    doc_title = element_link.parent().parent().parent().find('h3').find('a').text();
    if (typeof $('#project_id').val() != "undefined"){

        bootbox.dialog({
            title: I18n.t("citations_for") + '"' + doc_title + '"',
            message: "<div class='citation'><div class='citation-type' rel='citation_mla'>MLA</div><div class='citation-body'>" + citations[0] + "<br/>"+
            "<a href='#' class='citation-save' id='citation_mla' onclick='return saveCitation(\"citation_mla\", \""+doc_id+"\")'>" + I18n.t("save_citation") + "</a></div></div>"+
            "<div class='citation'><div class='citation-type' rel='citation_apa'>APA</div><div class='citation-body'>" + citations[1] + "<br/>"+
            "<a href='#' class='citation-save' id='citation_apa' onclick='return saveCitation(\"citation_apa\", \""+doc_id+"\")'>" + I18n.t("save_citation") + "</a></div></div>"+
            "<div class='citation'><div class='citation-type' rel='citation_chicago'>ISO 690</div><div class='citation-body'>" + citations[2] + "<br/>"+
            "<a href='#' class='citation-save' id='citation_chicago' onclick='return saveCitation(\"citation_chicago\", \""+doc_id+"\")'>" + I18n.t("save_citation") + "</a></div></div>"+
            "",
            className: "citation-modal"
        });
    }
    else{
        bootbox.dialog({
            title: I18n.t("citations_for") + '"' + doc_title + '"',
            message: "<div class='citation'><div class='citation-type'>MLA</div><div class='citation-body'>" + citations[0] + "</div></div>"+
            "<div class='citation'><div class='citation-type'>APA</div><div class='citation-body'>" + citations[1] + "</div></div>"+
            "<div class='citation'><div class='citation-type'>ISO 690</div><div class='citation-body'>" + citations[2] + "</div></div>",
            className: "citation-modal"
        });
    }
}

function saveCitation(citation_type, doc_id) {
    $.ajax({
        url: "/google_scholar/citation_save?project_id=" + $("#project_id").val() + "&doc_id=" + doc_id +
             "&citation_type=" + citation_type + "&search_q=" + $('#search_gs_input').val(),
        cache: false,
        type: "get",
        dataType: "json",
        beforeSend: function(){
            $('.citation-save').text(I18n.t("save_citation"));
            $('#'+citation_type).text(I18n.t("saving_citation"));
        },
        success: function(response) {
            $('#'+citation_type).text(I18n.t("saved_citation"));
            location.reload();
        },
        error: function(response) {
            alert("Error!!!");
        }
    });
}

// Override Google Scholar's functions
function gs_sva(doc_id, doc_num) {
    if (typeof $('#project_id').val() !== "undefined") {
        element_link = $('.container').find('#gs_svl' + doc_num);
        doc_title = element_link.parent().parent().parent().find('h3').find('a').text();
        doc_link = element_link.parent().parent().parent().prev().find('.gs_md_wp').find('a').attr('href');

        if(typeof doc_link === "undefined") {
            doc_link = element_link.parent().parent().parent().find('.gs_rt').find('a').attr('href');
        }
        doc_extension = doc_link.substr(doc_link.lastIndexOf('.')+1).toLowerCase();

        // alert(doc_link);
        save_file = '<form id="save_gs_link" action="/projects/'+$('#project_id').val()+'/project_files" method="post">' +
        '<input type="hidden" name="project_file[filename]" value="'+doc_title+'" />' +
        '<input type="hidden" name="project_file[filepath]" value="'+doc_link+'" />' +
        '<input id="project_file_extension" type="hidden" name="project_file[extension]" value="'+doc_extension+'">' +
        '<input type="hidden" name="authenticity_token" value="'+AUTH_TOKEN+'" />' +
        '<input type="hidden" name="search_q" value="'+$('#search_gs_input').val()+'" />' +
        '</form>';
        element_link.after(save_file);
        $('.container #save_gs_link').submit();
    }
    else
        bootbox.alert(I18n.t("choose_project_article"));
}

function gs_ocit(event ,doc_id, doc_num) {
    cite_link = $('#gs_svl' + doc_num).parent().prev();
    $.ajax({
        url: "/google_scholar/search_citation?doc_id="+doc_id+"&doc_num="+doc_num+"&project_id="+$('#project_id').val(),
        cache: false,
        type: "get",
        dataType: "json",
        beforeSend: function() {
            cite_link.append("<img class='loader_icon' id='cite_loader"+doc_num+"' src='/assets/loader.gif' width='14px' height='14px' />");
        },
        success: function(citations) {
            showCitationsModal(doc_id, doc_num, citations);
            $('#cite_loader'+doc_num).remove();
        },
        error: function(result) {
            alert("Error!!!");
        }
    });
}