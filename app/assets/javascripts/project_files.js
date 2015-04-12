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

$(document).ready(function() {
    $('.file_history_table').on('click', 'tr', function() {
        project_id = $(this).data('project');
        file_id = $(this).data('file');
        window.location = '/projects/'+project_id+'/project_files/'+file_id;
    });

    $('#object-left').contents().find('pre').scroll(function() {
        console.log('object-left scrolling...');
        // $('#object-right').find(body).scroll();
    });

    $('#object-right').contents().find('pre').scroll(function() {
        console.log('object-right scrolling...');
        // $('#object-left').find(body).scroll();
    });

    window.onload=function() {
        // Get the Left Object by ID
        objectLeftBody = window.frames[0].document.body;
        objectRightBody = window.frames[1].document.body;
        /*
        var objectLeft = document.getElementById("object-left");
        // Get Left Object body
        var objectLeftBody;
        if (objectLeft.contentDocument) // FF Chrome
            objectLeftBody = objectLeft.contentDocument.body;
        else if (objectLeft.contentWindow) // IE
            objectLeftBody = objectLeft.contentWindow.document.body;
        else if (objectLeft.document) // IE
            objectLeftBody = objectLeft.document.body;
        else if (objectLeft.window)
            objectLeftBody = objectLeft.window.document.body;

        // Get the Right Object by ID
        var objectRight = document.getElementById("object-right");
        // Get Right Object body
        var objectRightBody;
        if (objectRight.contentDocument) // FF Chrome
            objectRightBody = objectRight.contentDocument.body;
        else if (objectRight.contentWindow) // IE
            objectRightBody = objectRight.contentWindow.document.body;
        else if (objectRight.document) // IE
            objectRightBody = objectRight.document.body;
        else if (objectRight.window)
            objectRightBody = objectRight.window.document.body;
*/
        objectLeftBody.onmouseover=function() {
            objectRightBody.onscroll=null;

            objectLeftBody.onscroll=function() {
                objectRightBody.scrollTo(0, objectLeftBody.scrollTop);
            };
        };

        objectRightBody.onmouseover=function() {
            objectLeftBody.onscroll=null;

            objectRightBody.onscroll=function() {
                objectLeftBody.scrollTo(0, objectRightBody.scrollTop);
            };
        };
    }
});