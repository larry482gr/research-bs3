function getOpenSearchResults(page, start, num, form_params) {
    $.ajax({
        url: '/open_search/helios_search?'+form_params+'&start='+start+'&num='+num,
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
                    $('.search_gs_results').append(drawResult(response.results[i]));
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

function drawResult(result) {
    description = (typeof result.description != 'undefined') ? result.description : '';
    pdf_link = (typeof result.pdf_link != 'undefined') ? getPdfLink(result.pdf_link, result.domain) : '&nbsp;';

    return '<div class="gs_r">' +
                '<div class="gs_ggs gs_fl">' +
                    '<button class="gs_btnFI gs_in_ib gs_btn_half" id="gs_ggsB0" type="button">' +
                        '<span class="gs_wr">'+
                        '<span class="gs_lbl"></span>'+
                        '<span class="gs_ico"></span>'+
                        '</span>'+
                    '</button>'+
                    '<div id="gs_ggsW0" class="gs_md_wp gs_ttss">'+
                        pdf_link+
                    '</div>'+
                '</div>'+
                '<div class="gs_ri">'+
                    '<h3 class="gs_rt">'+
                        '<a href="'+result.identifier+'">'+result.title+'</a>'+
                    '</h3>'+
                    '<div class="gs_a">'+
                        result.creator+' - '+result.publisher+', '+result.date+' - '+result.domain+
                    '</div>'+
                    '<div class="gs_rs">'+description+'</div>'+
                    '<div class="gs_fl">'+
                        '<a aria-haspopup="true" aria-controls="gs_cit" role="button" class="gs_nph" href="#" '+
                            'title="Check what to return [parse identifier citation div]" '+
                            'onclick="return helios_cite() // gs_ocit(event,\'5F6EenTzb4cJ\',\'0\')">Cite'+
                        '</a>'+
                        '<span class="gs_nph">'+
                            '<a title="Save this article to my library so that I can read or cite it later...<br/>' +
                                'parse identifier citation div" href="#"' +
                                ' onclick="return gs_sva(\'5F6EenTzb4cJ\',\'0\')" id="gs_svl0">Save' +
                            '</a>'+
                            '<span class="gs_svm" id="gs_svo0">Saving<span id="gs_svd0">...</span></span>'+
                            '<a style="display:none" id="gs_svs0">Saved</a>'+
                            '<span class="gs_svm" id="gs_sve0">Error saving. ' +
                                '<a href="#" onclick="return gs_sva(\'5F6EenTzb4cJ\',\'0\')">Try again?</a>' +
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
        url: "/open_search/helios_cite",
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
