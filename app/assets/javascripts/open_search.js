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
            if (response.total == 0) {
                $('.search_gs_results').html("<h5>" + response.results + "</h5>");
            }
            else {
                $('.search_gs_results').html("<div><strong>Total Results:</strong> " + response.total + "</div>");

                for(i = 0; i < response.results.length; i++) {
                    $('.search_gs_results').append(drawResult(i, response.results[i]));
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
    identifier = (typeof result.identifier != 'undefined') ? '<a href="'+result.identifier+'">'+result.title+'</a>' : result.title;
    title = (typeof result.title != 'undefined') ? '<a href="'+result.identifier+'">'+result.title+'</a>' : '';
    description = (typeof result.description != 'undefined') ? result.description : '';
    pdf_link = (typeof result.pdf_link != 'undefined') ? getPdfLink(result.pdf_link, result.domain) : '&nbsp;';
    creator = (typeof result.creator != 'undefined') ? result.creator : '';
    publisher = (typeof result.publisher != 'undefined') ? ' - '+result.publisher : '';
    doc_date = (typeof result.date != 'undefined') ? ', '+result.date : '';
    domain = (typeof result.domain != 'undefined') ? result.domain : '';

    return '<div class="gs_r">' +
                '<div class="gs_ggs gs_fl">' +
                    '<button class="gs_btnFI gs_in_ib gs_btn_half" id="gs_ggsB'+doc_num+'" type="button">' +
                        '<span class="gs_wr">'+
                        '<span class="gs_lbl"></span>'+
                        '<span class="gs_ico"></span>'+
                        '</span>'+
                    '</button>'+
                    '<div id="gs_ggsW'+doc_num+'" class="gs_md_wp gs_ttss">'+
                        pdf_link+
                    '</div>'+
                '</div>'+
                '<div class="gs_ri">'+
                    '<h3 class="gs_rt">'+
                        title+
                    '</h3>'+
                    '<div class="gs_a">'+
                        creator+publisher+doc_date+' - '+domain+
                    '</div>'+
                    '<div class="gs_rs">'+description+'</div>'+
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
