/**
 * Created by Larry on 3/25/15.
 */

$(document).ready(function() {

    if(typeof $('#search_gs_input').val() !== 'undefined' &&  $('#search_gs_input').val().length > 0) {
        getSearchResults(1, $('#search_gs_input').val());
    }

    if (!navigator.userAgent.match(/Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile/i)) {
        $('.container').on('click', '.gs_md_wp', function(e){
            doc_title = $(this).parent().next().find('h3').find('a').text();
            doc_link = $(this).find('a').attr('href');
            if(doc_link.substr(doc_link.length-3).toLowerCase() === 'pdf') {
                e.preventDefault();
                save_file = '<form class="save-article-form" action="/projects/'+$('#project_id').val()+'/project_files"'+
                    'onsubmit="selectProject(); return false;" method="post" style="width: 900px; margin: 10px auto;">'+
                    '<input type="hidden" name="project_file[filename]" value="'+doc_title+'" />'+
                    '<input type="hidden" name="project_file[filepath]" value="'+doc_link+'" />'+
                    '<input type="hidden" name="authenticity_token" value="'+AUTH_TOKEN+'" />'+
                    '<input type="submit" class="save-article-btn btn btn-primary" value="Save" />'+
                    '</form>';

                bootbox.dialog({
                    title: doc_title,
                    message: '<embed width="900" height="860" style="border:1px solid #ccc" src="'+doc_link+'" alt="pdf" pluginspage="http://get.adobe.com/reader/">'+
                    save_file,
                    className: 'pdf_modal'
                });
            }
        });
    }

    // Current page
    $('.paging').on('click', '.number', function() {
        var pageNumber = $(this).attr('title');
        getSearchResults(pageNumber, $('#search_gs_input').val());
    });

    // paging previous
    $('.paging').on('click', '.previousPage', function() {
        var pageNumber = $(this).parent().find('.btn-primary').attr('title');
        pageNumber--;
        getSearchResults(pageNumber, $('#search_gs_input').val());
    });

    // paging next
    $('.paging').on('click', '.nextPage' ,function() {
        var pageNumber = $(this).parent().find('.btn-primary').attr('title');
        pageNumber++;
        getSearchResults(pageNumber, $('#search_gs_input').val());
    });

    $('.rowsPerPage').on('change', function() {
        getSearchResults(1, $('#search_gs_input').val());
    });

    // Search Google Scholar
    $('#search_gs_btn').on('click', function() {
        getSearchResults(1, $('#search_gs_input').val());
    });

    $('#exact_match').on('click', function() {
        $('#search_gs_input').focus();
    });

    $(document).keypress(function(e) {
        if($('#search_gs_input').is(':focus') && (e.which == 13 || e.keycode == 13))
            getSearchResults(1, $('#search_gs_input').val());
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

    function getSearchResults(page, question) {
        num = $('.rowsPerPage').val();
        start = (page-1)*num;

        if ($('#exact_match').is(':checked'))
            question = '"' + question + '"';

        $.ajax({
            url: '/static_pages/search_scholar?question='+question+'&start='+start+'&num='+num,
            cache: false,
            type: "get",
            dataType: "json",
            beforeSend: function(){
                $('.search_gs_results').animate({opacity: 0.2});
                if($('.projects_table').hasClass("col-md-7")){
                    $('.projects_table').removeClass("col-md-7").addClass("col-md-4");
                    $('.search_div').removeClass("col-md-5").addClass("col-md-8");
                    $("#search_gs_input").css('width', '100%');
                }
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
                }

                $('.search_gs_results').animate({opacity: 1});
                $('#rows_div').show();
                paging(response.total.replace(/\./g, ''), page, $('.rowsPerPage').val(), 'paging_gs_results');
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
            "<div class='citation'><div class='citation-type' rel='citation_chicago'>Chicago</div><div class='citation-body'>" + citations[2] + "<br/>"+
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
            "<div class='citation'><div class='citation-type'>Chicago</div><div class='citation-body'>" + citations[2] + "</div></div>",
            className: "citation-modal"
        });
    }
}

function saveCitation(citation_type, doc_id) {
    $.ajax({
        url: "/static_pages/citation_save?project_id=" + $("#project_id").val() + "&doc_id=" + doc_id + "&citation_type=" + citation_type,
        cache: false,
        type: "get",
        dataType: "json",
        beforeSend: function(){
            $('.citation-save').text(I18n.t("save_citation"));
            $('#'+citation_type).text(I18n.t("saving_citation"));
        },
        success: function(response) {
            $('#'+citation_type).text(I18n.t("saved_citation"));
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
        // alert(doc_link);
        save_file = '<form id="save_gs_link" action="/projects/'+$('#project_id').val()+'/project_files" method="post">'+
        '<input type="hidden" name="project_file[filename]" value="'+doc_title+'" />'+
        '<input type="hidden" name="project_file[filepath]" value="'+doc_link+'" />'+
        '<input type="hidden" name="authenticity_token" value="'+AUTH_TOKEN+'" />'+
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
        url: "/static_pages/search_citation?doc_id="+doc_id+"&doc_num="+doc_num+"&project_id="+$('#project_id').val(),
        cache: false,
        type: "get",
        dataType: "json",
        beforeSend: function() {
            cite_link.append("<img class='loader_icon' id='cite_loader"+doc_num+"' src='/assets/loader.gif' width='14px' height='14px' />");
        },
        success: function(citations){
            showCitationsModal(doc_id, doc_num, citations);
            $('#cite_loader'+doc_num).remove();
        },
        error: function(result){
            alert("Error!!!");
        }
    });
}