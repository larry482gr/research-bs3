class StaticPagesController < ApplicationController
  require 'net/http'
  require 'uri'

  before_action :valid_user, only: [:search, :search_scholar, :search_citation]
  before_action :set_hash, only: [:search_scholar]
  
  def index
    redirect_to projects_path unless @current_user.nil?
    @user = User.new
  end
  
  def search
    if params[:q].nil? or params[:q].empty?
      @users = []
      @projects = []
    else
      @users = User.where("id != :id AND (username LIKE :username OR email LIKE :email) AND profile_id >= :user_profile", id: @current_user.id, username: "#{params[:q]}%", email: "#{params[:q]}%", user_profile: @current_user.profile_id)
      @projects = Project.where("title LIKE :title AND is_private = :private", { title: "%#{params[:q]}%", private: 0 })
    end
    
    respond_to do |format|
      format.html { render 'static_pages/search' }
	  	format.json { render json: { :users => @users, :projects => @projects } }
		end
  end
  
  def search_scholar
    url_ext = @url_ext_hash[I18n.locale]

    start		= params[:start]
    num			= params[:num]

    if params[:q].present?
      gs_params	= "q=#{params[:q].gsub(' ', '+')}"
    else
      gs_params = "as_q=#{params[:as_q]}&"
      gs_params << "as_epq=#{params[:as_epq]}&"
      gs_params << "as_oq=#{params[:as_oq]}&"
      gs_params << "as_eq=#{params[:as_eq]}&"
      gs_params << "as_occt=#{params[:as_occt]}&"
      gs_params << "as_sauthors=#{params[:as_sauthors]}&"
      gs_params << "as_publication=#{params[:as_publication]}&"
      gs_params << "as_ylo=#{params[:as_ylo]}&"
      gs_params << "as_yhi=#{params[:as_yhi]}"
    end

    url = URI.escape("http://scholar.google.#{url_ext}/scholar?#{gs_params}&start=#{start}&num=#{num}&hl=#{@hl}")
    uri = URI.parse(url)

    #req = Net::HTTP::Get.new(uri)

    #res = Net::HTTP.start(uri.hostname, uri.port) {|http|
    #  http.request(req)
    #}

    res = Net::HTTP.get_response(uri)

    response = res.body

    begin
      cleaned = response.dup.force_encoding('ISO-8859-7').encode('UTF-8')

      unless cleaned.valid_encoding?
        cleaned = response.encode( 'UTF-8', 'ISO-8859-7' )
      end
      response = cleaned
    rescue EncodingError
      response.encode!( 'UTF-8', invalid: :replace, undef: :replace )
    end

    # For external links
		response = response.gsub("href=\"/", "target=\"blank\" href=\"http://scholar.google.#{url_ext}/")
    # For images
    response = response.gsub("src=\"/", "src=\"http://scholar.google.#{url_ext}/")
		# Remove code that causes ajax request error. (13/01/2015)
		response = response.gsub("gs_ie_ver<=7&&(new Image().src='/scholar_url?ie='+gs_ie_ver);", '')

		result_indexes = []

		response.to_enum(:scan,/<div class="gs_r">/i).map do |m,|
			result_indexes << $`.size
		end

		if result_indexes.empty?
			total_results = '0'
			@results = t(:no_results)
		else
			total_results_index = []
			@results = []
			is_numeric_regex = /^[\d]*((\.|,)?[\d]*)*$/

			response[result_indexes.last..response.size].to_enum(:scan,/<script>/i).map do |m,|
				result_indexes << $`.size + result_indexes.last
			end

			response.to_enum(:scan,/<div id="gs_ab_md">/i).map do |m,|
				total_results_index << $`.size
			end

			response.to_enum(:scan,/<div id="gs_ab_rt">/i).map do |m,|
				total_results_index << $`.size
      end

			total_results_array = response[total_results_index[0]..total_results_index[1]].split

			total_results = ''
			total_results_array.each do |item|
        total_results = item unless is_numeric_regex.match(item).nil?
      end

			result_indexes[0..result_indexes.size-2].each_with_index do |value, index|
				@results << response[value..result_indexes[index+1]-1]
			end
    end

    search_field_index = []
    response.to_enum(:scan,/id="gs_hdr_frm_in_txt"/i).map do |m,|
      search_field_index << $`.size
    end

    response.to_enum(:scan,/id="gs_hdr_arw"/i).map do |m,|
      search_field_index << $`.size
    end

    search_field = response[search_field_index[0]..search_field_index[1]].split(/(.*?)value="(.*?)"(.*?)/)[2]

    if request.referer.to_s.end_with?('projects') or request.referer.to_s.end_with?('projects/')
      session[:search_gs] = search_field
    end

		respond_to do |format|
			format.js { render json: { results: @results, total: total_results.gsub(',', '.'), search: search_field } }
		end
  end
  
  def search_citation
    doc_id = params[:doc_id]
    doc_num = params[:doc_num]
    citations = []
    error = false
    
    citation = Citation.find_by citation_id: doc_id
    
    if citation
      citations << citation.citation_mla
      citations << citation.citation_apa
      citations << citation.citation_chicago
      
    else
      url = URI.escape("http://scholar.google.com/scholar?q=info:#{doc_id}:scholar.google.com/&output=cite&scirp=#{doc_num}")
      uri = URI.parse(url)
      req = Net::HTTP::Get.new(uri)

      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }

      response = res.body
      begin
        cleaned = res.body.dup.force_encoding('UTF-8')
        unless cleaned.valid_encoding?
          cleaned = res.body.encode( 'UTF-8', 'Windows-1251' )
        end
        response = cleaned
      rescue EncodingError
        response.encode!( 'UTF-8', invalid: :replace, undef: :replace )
      end

      result_indexes = []

      response.to_enum(:scan,/class="gs_citr">/i).map do |m,|
	    result_indexes << $`.size+16
	  end
	
	  close_div_indexes = []
	
	  response.to_enum(:scan,/<\/div><\/td>/i).map do |m,|
	    close_div_indexes << $`.size-1
	  end
	
	  for n in 0..2
	    citations[n] = response[result_indexes[n]..close_div_indexes[n]]
	  end
	  
	  begin
	    project = Project.find(params[:project_id])
	    citation = project.citations.create(:citation_id => doc_id, :citation_mla => citations[0], :citation_apa => citations[1], :citation_chicago => citations[2])
	    if !citation.save
	      error = true
	    end
	  rescue
	  end
	end
	
	respond_to do |format|
	  if !error
	    format.js { render json: citations }
	  else
	    format.js { render json: error }
	  end
	end
  end
  
  def citation_save
    project_id = params[:project_id]
    doc_id = params[:doc_id]
    citation_type = params[:citation_type]
    
    project = Project.find(project_id)
    result = project.update_citation(doc_id, citation_type)
    
    if result < 1
      result = project.insert_citation(doc_id, citation_type)
    end

    respond_to do |format|
      if result < 1
        format.js { render json: "{ \"id\": \"success\" }" }
      else
        format.js { render json: "{ \"id\": \"error\" }" }
      end
    end
  end

  private

  def valid_user
    if @current_user.nil?
      flash[:alert] = (t :search_restriction)
      redirect_to :root and return
    end
  end

  def set_hash
    @url_ext_hash = { :en => 'com', :gr => 'gr' }
  end
end
