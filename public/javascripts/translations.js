var I18n = I18n || {};
I18n.translations = {"en":{"date":{"formats":{"default":"%Y-%m-%d","short":"%b %d","long":"%B %d, %Y"},"day_names":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"abbr_day_names":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"month_names":[null,"January","February","March","April","May","June","July","August","September","October","November","December"],"abbr_month_names":[null,"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"order":["year","month","day"]},"time":{"formats":{"default":"%a, %d %b %Y %H:%M:%S %z","short":"%m-%d-%Y","long":"%m-%d-%Y (%H:%m:%S)"},"am":"am","pm":"pm"},"support":{"array":{"words_connector":", ","two_words_connector":" and ","last_word_connector":", and "}},"number":{"format":{"separator":".","delimiter":",","precision":3,"significant":false,"strip_insignificant_zeros":false},"currency":{"format":{"format":"%u%n","unit":"$","separator":".","delimiter":",","precision":2,"significant":false,"strip_insignificant_zeros":false}},"percentage":{"format":{"delimiter":"","format":"%n%"}},"precision":{"format":{"delimiter":""}},"human":{"format":{"delimiter":"","precision":3,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"Byte","other":"Bytes"},"kb":"KB","mb":"MB","gb":"GB","tb":"TB"}},"decimal_units":{"format":"%n %u","units":{"unit":"","thousand":"Thousand","million":"Million","billion":"Billion","trillion":"Trillion","quadrillion":"Quadrillion"}}}},"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"is not included in the list","exclusion":"is reserved","invalid":"is invalid","confirmation":"doesn't match %{attribute}","accepted":"must be accepted","empty":"can't be empty","blank":"can't be blank","present":"must be blank","too_long":{"one":"is too long (maximum is 1 character)","other":"is too long (maximum is %{count} characters)"},"too_short":{"one":"is too short (minimum is 1 character)","other":"is too short (minimum is %{count} characters)"},"wrong_length":{"one":"is the wrong length (should be 1 character)","other":"is the wrong length (should be %{count} characters)"},"not_a_number":"is not a number","not_an_integer":"must be an integer","greater_than":"must be greater than %{count}","greater_than_or_equal_to":"must be greater than or equal to %{count}","equal_to":"must be equal to %{count}","less_than":"must be less than %{count}","less_than_or_equal_to":"must be less than or equal to %{count}","other_than":"must be other than %{count}","odd":"must be odd","even":"must be even","taken":"has already been taken"},"dynamic_format":"%{message}"},"activerecord":{"errors":{"messages":{"record_invalid":"Validation failed: %{errors}","restrict_dependent_destroy":{"one":"Cannot delete record because a dependent %{record} exists","many":"Cannot delete record because dependent %{record} exist"}},"template":{"header":{"one":"1 error prohibited this %{model} from being saved","other":"%{count} errors prohibited this %{model} from being saved"},"body":"There were problems with the following fields:"}}},"datetime":{"distance_in_words":{"half_a_minute":"half a minute","less_than_x_seconds":{"one":"less than 1 second","other":"less than %{count} seconds"},"x_seconds":{"one":"1 second","other":"%{count} seconds"},"less_than_x_minutes":{"one":"less than a minute","other":"less than %{count} minutes"},"x_minutes":{"one":"1 minute","other":"%{count} minutes"},"about_x_hours":{"one":"about 1 hour","other":"about %{count} hours"},"x_days":{"one":"1 day","other":"%{count} days"},"about_x_months":{"one":"about 1 month","other":"about %{count} months"},"x_months":{"one":"1 month","other":"%{count} months"},"about_x_years":{"one":"about 1 year","other":"about %{count} years"},"over_x_years":{"one":"over 1 year","other":"over %{count} years"},"almost_x_years":{"one":"almost 1 year","other":"almost %{count} years"}},"prompts":{"year":"Year","month":"Month","day":"Day","hour":"Hour","minute":"Minute","second":"Seconds"}},"helpers":{"select":{"prompt":"Please select"},"submit":{"create":"Create %{model}","update":"Update %{model}","submit":"Save %{model}"}},"homepage":"Home","no_access":"You don 't have access to view this page. You were redirected to the home page.","search":"Search for a user or project","no_results":"No results found.","save":"Save","cancel":"Cancel","ok":"Ok","word_yes":"Yes","word_no":"No","are_you_sure":"Are you sure","question_mark":"?","show":"Show","edit":"Edit","delete":"Delete","reason":"Reason","back":"Back","english":"English","greek":"Greek","my_projects":"My Projects","owner":"Member","collaborator":"Collaborator","send":"Send","try_again":"Please try again.","error_persists":"If this error persists contact our support department at... (support_mail)","write_comment":"Write a comment","provide_comment":"In this case you \u003cb\u003emust\u003c/b\u003e provide a comment","large_comment":"Your comment should not exceed 200 characters","more_than":"more than","ago":"ago","few_seconds":"a few seconds ago","year":{"one":"1 year","other":"%{count} years"},"month":{"one":"1 month","other":"%{count} months"},"day":{"one":"1 day","other":"%{count} days"},"hour":{"one":"1 hour","other":"%{count} hours"},"minute":{"one":"1 minute","other":"%{count} minutes"},"invitations":"Invitations","no_invitation_access":"Sorry! You don't have the appropriate rights to invite people to this project.","invitation_sent":"Invitation successfully sent to","invitation_fail":"Invitation failed to be sent.","invitation_user_restriction":"At the moment you can only invite registered users.","invitation_duplicate":"You have already sent an invitation to _@user@_ for project \"_@project@_\"","accept":"Accept","discard":"Discard","discard_invitation":"Discard invitation","discard_comment":["I don't want to participate at this project","I don't have time","Other"],"report":"Report user","report_invitation":"Report user","report_comment":["I don't know the user who sent the invitation","This is a spam invitation","This project is a total fraud","Other"],"filename":"Filename","main_file":"Main File","file_actions_title":"File Actions","file_actions_message":"What would you like to do with ","set_main_file":"Set as Main File","unset_main_file":"Unset Main File","set_main_file_prefix":"Are you sure you would like to set ","set_main_file_suffix":" as this project's main file","unset_main_file_prefix":"Are you sure you would like to unset ","unset_main_file_suffix":" from this project's main files","invalid_main_file":"You can only set an uploaded file as the project's main file.","view_file":"View File","search_file_title":"Search File","search_file_message":"Would you like to search for","choose_project_article":"You must choose a Project in order to save a particular article.","choose_project_cite":"You must choose a Project in order to cite a particular article.","citations_for":"Citations for: ","save_citation":"Save citation","saving_citation":"Saving citation...","saved_citation":"Citation saved","file_edit_no_access":"As a collaborator of this project you can only edit files uploaded by you.","file_delete_no_access":"Only project owner(s) can delete files.","pre_file_delete_success":"File","post_file_delete_success":"successfully deleted","file_delete_error":"An error occurred while deleting your file. Please try again and if this error persists contact our support department.","created_by":"Created by","projects":"Projects","your_projects":"Your Projects","title":"Title","description":"Description","created_at":"Created at","last_modified":"Last modified","show_history":"Show History","private":"Private","max_private":"Maximum private projects:","users_private":"Currently owned private projects:","invite_user":"Invite User","create_project":"Create New Project","search_gs":"Search for a book, article or paper","upload":"Upload","upload_file":"Upload file...","no_project_files":"Oops! This project has no files yet.","project_files":"Project Files","project_citations":"Project Citations","citation_deleted":"Citation successfully deleted.","cite_delete_error":"There was an error deleting the citation.","error":{"one":"error","other":"errors"},"user_prohibit":"prohibited your registation:","username":"Username","first_name":"First Name","last_name":"Last Name","email":"Email","activated":"Activated","blacklisted":"Blacklisted","deleted":"Deleted","preferred_language":"Preferred language","password":"Password","sign_in":"Sign In","invalid_credentials":"The username or password you entered is invalid.","activation_error_html":"Oops, we had some problems activating your account! Either it is already activated or an error occured.\u003cbr/\u003eTry following the activation link again or directly Sign In. If you see this message again contact our support team at: support@researchgr.com","sign_out":"Sign Out","sign_in_modal":"Sign in to my account","register":"Register","profile":"Profile","list_users":"List Users","new_user":"New User","create_user":"Create User","user_updated":"User was successfully updated.","user_delete_error":"An error occured while trying to delete your account","delete_user":"Delete User","delete_comment":["User request","Harmful usage","Don't like his/her face","Other"]},"gr":{"homepage":"Αρχική","no_access":"Δεν έχετε πρόσβαση στη σελίδα που ζητήσατε. Έγινε ανακατεύθυνση στην αρχική σελίδα.","search":"Αναζήτηση χρήστη ή έργου","no_results":"Δε βρέθηκαν αποτελέσματα για την αναζήτησή σας.","save":"Αποθήκευση","cancel":"Ακύρωση","ok":"Ok","word_yes":"Ναι","word_no":"Όχι","are_you_sure":"Είστε σίγουρος/η","question_mark":";","show":"Προβολή","edit":"Επεξεργασία","delete":"Διαγραφή","reason":"Αιτία","back":"Επιστροφή","english":"Aγγλικά","greek":"Ελληνικά","my_projects":"Τα έργα μου","owner":"Μέλος","collaborator":"Συνεργάτης","send":"Αποστολή","try_again":"Παρακαλώ δοκιμάστε ξανά.","error_persists":"Εαν το συγκεκριμένο σφάλμα παραμείνει επικοινωνήστε με το τμήμα εξυπηρέτησης στο... (support_mail)","write_comment":"Γράψτε ένα σχόλιο","provide_comment":"Σε αυτή την περίπτωση \u003cb\u003eπρέπει\u003c/b\u003e να γράψετε ένα σχόλιο","large_comment":"Το σχόλιο σας δεν πρέπει να υπερβαίνει τους 200 χαρακτήρες","time":{"formats":{"short":"%d/%m/%Y","long":"%d/%m/%Y (%H:%m:%S)"}},"more_than":"περισσότερο από","ago":"πριν","few_seconds":"πριν από λίγα δευτερόλεπτα","year":{"one":"1 έτος","other":"%{count} έτη"},"month":{"one":"1 μήνα","other":"%{count} μήνες"},"day":{"one":"1 μέρα","other":"%{count} μέρες"},"hour":{"one":"1 ώρα","other":"%{count} ώρες"},"minute":{"one":"1 λεπτό","other":"%{count} λεπτά"},"invitations":"Προσκλήσεις","no_invitation_access":"Λυπάμαι! Δεν έχετε τα απαραίτητα δικαιώματα, ώστε να προσκαλέσετε άλλα άτομα σε αυτό το έργο.","invitation_sent":"Η πρόσκληση απεστάλη επιτυχώς στον/ην","invitation_fail":"Η αποστολή της πρόσκλησης απέτυχε.","invitation_user_restriction":"Προς το παρόν μπορείτε να προσκαλέσετε μόνο εγγεγραμένους χρήστες.","invitation_duplicate":"Έχετε ήδη στείλει πρόσκληση στον/ην _@user@_ για το έργο \"_@project@_\"","accept":"Αποδοχή","discard":"Απόρριψη","discard_invitation":"Απόρριψη πρόσκλησης","discard_comment":["Δεν επιθυμώ να συμμετάσχω στο συγκεκριμένο έργο","Δεν έχω χρόνο","Άλλο"],"report":"Αναφορά χρήστη","report_invitation":"Αναφορά χρήστη","report_comment":["Δε γνωρίζω τον χρήστη που έστειλε την πρόσκληση","Η συγκεκριμένη πρόσκληση είναι spam","Το έργο είναι μία απάτη","Άλλο"],"filename":"Όνομα Αρχείου","main_file":"Κυρίως Έγγραφο","file_actions_title":"Ενέργειες Εγγράφου","file_actions_message":"Τι θα θέλατε να κάνετε με το ","set_main_file":"Ορισμός ως Κυρίως Έγγραφο","unset_main_file":"Κατάργηση Κυρίως Εγγράφου","set_main_file_prefix":"Είστε σίγουρος/η ότι θέλετε να ορίσετε το ","set_main_file_suffix":" ως κύριο έγγραφο αυτού του έργου","unset_main_file_prefix":"Είστε σίγουρος/η ότι θέλετε να καταργήσετε το ","unset_main_file_suffix":" από τα κυρίως έγγραφα αυτού του έργου","invalid_main_file":"Μπορείτε να ορίσετε ως κύριο έγγραφο μόνο κάποιο αρχείο που έχετε μεταφορτώσει.","view_file":"Προβολή Εγγράφου","search_file_title":"Αναζήτηση Εγγράφου","search_file_message":"Επιθυμείτε να αναζητήσετε το έγγραφο","choose_project_article":"Πρέπει να επιλέξετε ένα Έργο προκειμένου να αποθηκεύσετε ένα συγκεκριμένο άρθρο.","choose_project_cite":"Πρέπει να επιλέξετε ένα Έργο προκειμένου να αποθηκεύσετε μία παράθεση.","citations_for":"Παραθέσεις για: ","save_citation":"Αποθήκευση παράθεσης","saving_citation":"Αποθήκευση παράθεσης...","saved_citation":"Η παράθεση αποθηκεύτηκε","file_edit_no_access":"Ως συνεργάτης του συγκεκριμένου έργου μπορείτε να επεξεργαστείτε μόνο αρχεία που έχουν μεταφορτωθεί από εσάς.","file_delete_no_access":"Μόνο ο/οι κάτοχος(οι) του έργου μπορούν να διαγράψουν αρχεία.","pre_file_delete_success":"Το αρχείο","post_file_delete_success":"διαγράφηκε επιτυχώς.","file_delete_error":"Παρουσιάστηκε σφάλμα κατά τη διαγραφή του αρχείου σας. Παρακαλώ δοκιμάστε ξανά και αν το σφάλμα παραμένει επικοινωνήστε με το τμήμα εξυπηρέτησης.","created_by":"Δημιουργήθηκε από","projects":"Έργα","your_projects":"Τα Έργα σας","title":"Τίτλος","description":"Περιγραφή","created_at":"Δημιουργήθηκε στις","last_modified":"Τελευταία τροποποίηση","show_history":"Προβολή Ιστορικού","private":"Απόρρητο","max_private":"Μέγιστος αριθμός απόρρητων έργων:","users_private":"Απόρρητα έργα που κατέχετε:","invite_user":"Πρόσκληση Χρήστη","create_project":"Δημιουργία Νέου Έργου","search_gs":"Αναζήτηση βιβλίου, άρθρου ή εργασίας","upload":"Μεταφόρτωση","upload_file":"Μεταφόρτωση αρχείου...","no_project_files":"Ωχ! Αυτό το έργο δεν έχει ακόμα κανένα αρχείο.","project_files":"Αρχεία Έργου","project_citations":"Βιβλιογραφικές Αναφορές Έργου","citation_deleted":"Η βιβλιογραφική αναφορά διαγράφηκε επιτυχώς.","cite_delete_error":"Παρουσιάστηκε πρόβλημα κατά τη διαγραφή της βιβλιογραφική αναφοράς.","error":{"one":"σφάλμα","other":"σφάλματα"},"user_prohibit":"δεν επέτρεψαν την ολοκλήρωση της εγγραφής σας:","username":"Όνομα χρήστη","first_name":"Όνομα","last_name":"Επώνυμο","email":"Email","activated":"Ενεργοποιημένος","blacklisted":"Blacklisted","deleted":"Διεγραμένος","preferred_language":"Γλώσσα Προτίμησης","password":"Κωδικός Πρόσβασης","sign_in":"Είσοδος","invalid_credentials":"Το όνομα χρήστη ή ο κωδικός πρόσβασης που καταχωρίσατε δεν είναι έγγυρα.","activation_error_html":"Oops, we had some problems activating your account! Either it is already activated or an error occured.\u003cbr/\u003eTry following the activation link again or directly Sign In. If you see this message again contact our support team at: support@researchgr.com","sign_out":"Έξοδος","sign_in_modal":"Είσοδος στο λογαριασμό μου","register":"Εγγραφή","profile":"Προφίλ","list_users":"Προβολή Χρηστών","new_user":"Νέος Χρήστης","create_user":"Δημιουργία Χρήστη","user_updated":"Οι πληροφορίες του χρήστη τροποποιήθηκαν επιτυχώς.","user_delete_error":"Προέκυψε σφάλμα κατά τη διαγραφή του λογαριασμού σας.","delete_user":"Διαγραφή Χρήστη","delete_comment":["Αίτημα Χρήστη","Κακόβουλη χρήση","Δε μου αρέσει η φάτσα του","Άλλο"]}};