class StaticPagesController < ApplicationController
  require 'rubygems'
  require 'open-uri'
  require 'nokogiri'
  
  def index
     @user = User.new
  end
  
  def search
    if @current_user.nil?
      respond_to do |format|
        format.json { render json: { :illegal => "1" } }
      end
      return
    end
    
    @users = User.where("id != :id AND (username LIKE :username OR email LIKE :email) AND profile_id >= :user_profile", id: @current_user.id, username: "#{params[:question]}%", email: "#{params[:question]}%", user_profile: @current_user.profile_id)
    @projects = Project.where("title LIKE :title AND is_private = :private", { title: "%#{params[:question]}%", private: 0 })
    
    respond_to do |format|
	  	format.json { render json: { :users => @users, :projects => @projects } }
		end
  end
  
  def search_scholar
    url_extension = 'com'
    if I18n.locale != :en
      url_extension = I18n.locale
      # puts I18n.locale
    end

    if request.referer.to_s.end_with?('projects')
      session[:search_gs] = params[:question]
    end

    question	= params[:question].gsub(' ', '+')
    start		= params[:start]
    num			= params[:num]

    headers = {'User-Agent' => 'Ruby'}
    begin
      doc = open(URI.encode("http://scholar.google.#{url_extension}/scholar?q=#{question}&start=#{start}&num=#{num}"), headers).read
    rescue Exception=>e
      puts "Error: #{e}"
    end
    # url = URI.encode("http://scholar.google.#{url_extension}/scholar?q=#{question}&start=#{start}&num=#{num}")
    # user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:36.0) Gecko/20100101 Firefox/36.0'
    # doc = Nokogiri::HTML(open(url, 'User-Agent' => user_agent), nil, 'UTF-8')
    #doc = Nokogiri::HTML(open(URI.encode("http://scholar.google.#{url_extension}/scholar?q=#{question}&start=#{start}&num=#{num}"), 'User-Agent' => 'Ruby'))
    #doc.encoding = 'UTF-8'
    
		response = doc.to_s
		response = response.gsub("href=\"/", "target=\"blank\" href=\"http://scholar.google.#{url_extension}/")
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
				result_indexes << $`.size + result_indexes.last - 1
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
				@results << response[value..result_indexes[index+1]-4]
			end
    end

		respond_to do |format|
			format.js { render json: { results: @results, total: total_results.gsub(',', '.') } }
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
      doc = Nokogiri::HTML(open(URI.encode("http://scholar.google.com/scholar?q=info:#{doc_id}:scholar.google.com/&output=cite&scirp=#{doc_num}")))
	  doc.encoding = 'UTF-8'
	  response = doc.to_s

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
  
end