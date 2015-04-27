	function paging(numrows, currentPage, rowsPerPage, paging_div, limit) {
		limit = typeof limit !== 'undefined' ? limit : 3;
		var flag = 0;
		var startPage = 1;
		var previous = '';
		var next = '';
		var current = '';
		var totalPages = Math.ceil(numrows/rowsPerPage);
		currentPage = Number(currentPage);
		
		if(totalPages > currentPage+limit)
			flag = currentPage+limit+1;
		else
			flag = totalPages+1;
		
		if(currentPage > limit+1)
			startPage = currentPage-limit+1;
		else
			startPage = 1;
		
		if(totalPages > 1) {
			if(currentPage != 1)
				prev_disabled = '';
			else
				prev_disabled = 'disabled';
				
			previous = '<button title="PreviousPage" class="btn btn-sm previousPage" '+prev_disabled+'>&laquo; '+I18n.t("previous")+'</button>';
				
			if(currentPage != totalPages)
				next_disabled = '';
			else
				next_disabled = 'disabled';
				
			next = '<button title="NextPage" class="btn btn-sm nextPage"'+next_disabled+'>'+I18n.t("next")+' &raquo;</button>';
		}
		
		var paging = previous;
		for(page = startPage; page < flag; page++) {
			if(currentPage == page)
				current = 'btn-primary';
			else
				current = '';
			paging = paging + '<button class="btn btn-sm number ' + current + '" title="' + page + '">' + page + '</button>';
		}
		paging = paging + next;
		
		// Extends to support multiple div for the same paging
		if (paging_div instanceof Array) {
			for (var i = 0; i < paging_div.length; i++) {
				$('#'+paging_div[i]).html(paging);
			}
		} else {
			$('#'+paging_div).html(paging);
		}
	}
	
	function ucfirst(string){
		return string.charAt(0).toUpperCase() + string.slice(1);
	}