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
