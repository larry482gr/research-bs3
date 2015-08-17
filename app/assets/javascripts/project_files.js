var allowedFileTypes = ['application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/msword', 'application/vnd.oasis.opendocument.text', 'text/plain', 'application/rtf'];

var fileExtensions = {
    'application/pdf' : 'pdf',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document' : 'docx',
    'application/msword' : 'doc',
    'application/vnd.oasis.opendocument.text' : 'odt',
    'text/plain' : 'txt',
    'application/rtf' : 'rtf'
};

$(document).ready(function() {
    $('.file_history_table').on('click', 'tr', function() {
        project_id = $(this).data('project');
        file_id = $(this).data('file');
        window.location = '/projects/'+project_id+'/project_files/'+file_id;
    });
});