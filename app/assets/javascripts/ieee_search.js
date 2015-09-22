/**
 * Copyright 2015 Kazantzis Lazaros
 */

function getIeeeResults(page, start, num, form_params) {
    $.ajax({
        url: '/ieee/list_records?'+form_params+'&start='+start+'&num='+num,
        cache: false,
        type: "get",
        dataType: "json",
        beforeSend: function() {
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
                    identifier = (typeof response.results[i].mdurl != 'undefined') ? response.results[i].mdurl : '#';
                    title = (typeof response.results[i].title != 'undefined') ? '<a href="'+identifier+'">'+response.results[i].title+'</a>' : '';
                    description = (typeof response.results[i].abstract != 'undefined') ? response.results[i].abstract : '';
                    pdf_link = (typeof response.results[i].pdf != 'undefined') ? getPdfLink(response.results[i].pdf, response.results[i].domain) : '&nbsp;';
                    creator = (typeof response.results[i].authors != 'undefined') ? response.results[i].authors+' - ' : '';
                    publisher = (typeof response.results[i].pubtitle != 'undefined') ? response.results[i].pubtitle+', ' : '';
                    doc_date = (typeof response.results[i].py != 'undefined') ? response.results[i].py+' - ' : '';
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