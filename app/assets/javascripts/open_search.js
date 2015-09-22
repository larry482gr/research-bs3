/**
 * Copyright 2015 Kazantzis Lazaros
 */

function getOpenSearchResults(repo, page, start, num, form_params) {
    listSet = [];

    var selected = [];
    $('#opensearch-listset form input:checked').each(function() {
        listSet.push($(this).attr('rel'));
    });

    $.ajax({
        url: '/open_search/list_records?'+form_params+'&repo='+repo+'&start='+start+'&num='+num+'&listSet='+listSet,
        cache: false,
        type: "get",
        dataType: "json",
        beforeSend: function(){
            $('.search_gs_results').animate({opacity: 0.2});
        },
        success: function(response) {
            $('.search_gs_results').prev().remove();
            if (response.total == 0) {
                $('.search_gs_results').html("<h5>" + response.results + "</h5>");
            }
            else {
                $('.search_gs_results').html("<div><strong>"+I18n.t('total_results')+":</strong> " + response.total + "</div>");

                for(i = 0; i < response.results.length; i++) {
                    identifier = (typeof response.results[i].identifier != 'undefined') ? response.results[i].identifier : '#';
                    title = (typeof response.results[i].title != 'undefined') ? '<a href="'+identifier+'">'+response.results[i].title+'</a>' : '';
                    description = (typeof response.results[i].description != 'undefined') ? response.results[i].description : '';
                    pdf_link = (typeof response.results[i].pdf_link != 'undefined') ? getPdfLink(response.results[i].pdf_link, response.results[i].domain) : '&nbsp;';
                    creator = (typeof response.results[i].creator != 'undefined') ? response.results[i].creator+' - ' : '';
                    publisher = (typeof response.results[i].publisher != 'undefined') ? response.results[i].publisher+', ' : '';
                    doc_date = (typeof response.results[i].date != 'undefined') ? new Date(response.results[i].date).getFullYear()+' - ' : '';
                    domain = (typeof response.results[i].domain != 'undefined') ? response.results[i].domain : '';

                    result = {
                        title: title,
                        abstract: description,
                        pdf_link: pdf_link,
                        authors: creator,
                        publisher: publisher,
                        doc_date: doc_date,
                        domain: domain
                    };

                    $('.search_gs_results').append(drawResult(i, result));
                }

                // checkValidSave();
                $('.search_gs_results').animate({opacity: 1});
                $('#rows_div').show();
                paging(response.total.replace(/\./g, ''), page, $('.rowsPerPage').val(), 'paging_gs_results');
            }

            $('#search_gs_input').val(decodeHtml(response.search));

            if($('html').height() < $(window).height()) {
                $('.footer').css('position', 'absolute');
            }
            else {
                $('.footer').css('position', 'relative');
            }
        }
    });
}

function drawResult(doc_num, result) {
    return '<div class="gs_r">' +
                '<div class="gs_ggs gs_fl">' +
                    '<button class="gs_btnFI gs_in_ib gs_btn_half" id="gs_ggsB'+doc_num+'" type="button">' +
                        '<span class="gs_wr">'+
                        '<span class="gs_lbl"></span>'+
                        '<span class="gs_ico"></span>'+
                        '</span>'+
                    '</button>'+
                    '<div id="gs_ggsW'+doc_num+'" class="gs_md_wp gs_ttss">'+
                    result.pdf_link+
                    '</div>'+
                '</div>'+
                '<div class="gs_ri">'+
                    '<h3 class="gs_rt">'+
                    result.title+
                    '</h3>'+
                    '<div class="gs_a">'+
                    result.authors+result.publisher+result.doc_date+result.domain+
                    '</div>'+
                    '<div class="gs_rs">'+result.abstract+'</div>'+
                    '<div class="gs_fl">'+
                        '<!-- TODO Implement citation from Open Search -->'+
                        '<span class="gs_nph">'+
                            '<a title="Save this article to my library so that I can read or cite it later..." href="#"' +
                                ' onclick="return gs_sva(\'\','+doc_num+')" id="gs_svl'+doc_num+'">Save' +
                            '</a>'+
                            '<span class="gs_svm" id="gs_svo'+doc_num+'">Saving<span id="gs_svd'+doc_num+'">...</span></span>'+
                            '<a style="display:none" id="gs_svs'+doc_num+'">Saved</a>'+
                            '<span class="gs_svm" id="gs_sve'+doc_num+'">Error saving. ' +
                                '<a href="#" onclick="return gs_sva(\'\','+doc_num+')">Try again?</a>' +
                            '</span>'+
                        '</span>'+
                        '<a onclick="return gs_more(this,1)" role="button" class="gs_mor gs_oph" href="#">More</a>'+
                        '<a onclick="return gs_more(this,0)" role="button" class="gs_nvi" href="#">Fewer</a>'+
                    '</div>'+
                '</div>'+
            '</div>';
}

function getPdfLink(link, domain) {
    return  '<a href="'+link+'">'+
                '<span class="gs_ggsL">'+
                '<span class="gs_ctg2">[PDF]</span> from '+domain+'</span>'+
                '<span class="gs_ggsS">'+domain+' <span class="gs_ctg2">[PDF]</span></span>'+
            '</a>';
}

/*
function helios_cite() {
    // cite_link = $('#gs_svl' + doc_num).parent().prev();
    $.ajax({
        url: "/open_search/cite_record",
        cache: false,
        type: "get",
        dataType: "json",
        beforeSend: function() {
            // cite_link.append("<img class='loader_icon' id='cite_loader"+doc_num+"' src='/assets/loader.gif' width='14px' height='14px' />");
        },
        success: function(citations) {
            showCitationsModal(0, 0, citations);
            // $('#cite_loader'+doc_num).remove();
        },
        error: function(result) {
            alert("Error!!!");
        }
    });
}
*/