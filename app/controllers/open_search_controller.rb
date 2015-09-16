#
# Copyright 2015 Kazantzis Lazaros
#

class OpenSearchController < ApplicationController
  require 'open-uri'
  require 'nokogiri/xml'
  require 'nokogiri/html'
  require 'net/http'
  require 'uri'

  def helios_list
    #verb		= params[:verb]
    verb    = 'ListSets'

    set = Nokogiri::XML(open("http://helios-eie.ekt.gr/EIE_oai/request?verb=#{verb}"))

    puts set

    listSet = []
    set.xpath('//xmlns:set').each do |item|
      puts "====================\n\n===================="
      puts item
      puts "====================\n\n===================="

      unless item.children.first.text.blank? or item.children.last.text.blank?
        listSet << { set_key: item.children.first.text, set_val: item.children.last.text }
      end
    end

    #listSet = listSet.sort {|left, right| left[:set_key] <=> right[:set_key]}

    respond_to do |format|
      format.js { render json: listSet }
    end
  end

  def helios_search
    #verb		= params[:verb]
    verb    = 'ListRecords'

    res = Nokogiri::XML(open("http://helios-eie.ekt.gr/EIE_oai/request?verb=#{verb}&metadataPrefix=oai_dc"))

    metadata = res.xpath('//xmlns:metadata')

    @results = []

    metadata[0...10].each do |nodes|
      res = {}
      nodes.children.children.each do |node|
        if node.name == 'description' and node.text.length > 300
          last_boundary = node.text[0..300].rindex(/\s/)
          res[node.name] = node.text[0..last_boundary]
          first_break = res[node.name][0..100].rindex(/\s/)
          second_break = res[node.name][0..200].rindex(/\s/)
          res[node.name][second_break] = '<br/>'
          res[node.name][first_break] = '<br/>'

          res[node.name] = "#{res[node.name]} ..."
        else
          res[node.name] = node.text
        end
      end

      uri = URI.parse(res['identifier'])
      host = uri.host.downcase
      res['domain'] = host

      table = Nokogiri::HTML(open(uri)).xpath('//table[@class="itemDisplayTable"]/tr')

      table.each do |node|
        if node.children.first.text.downcase.include?('publisher link:') # and node.children.last.text.downcase.include?('.pdf')
          node.children.last.children.each do |link_node|
            if link_node.text.downcase.include?('.pdf')
              res['pdf_link'] = link_node.text
            end
          end
        elsif node.children.first.text.downcase.include?('publisher:')
          res['publisher'] = node.children.last.text
        end
      end

      @results << res
    end
  end

  def helios_show
    #verb		= params[:verb]
    verb    = 'GetRecord'

    res = Nokogiri::XML(open("http://helios-eie.ekt.gr/EIE_oai/request?verb=#{verb}&metadataPrefix=oai_dc&identifier=oai:http://helios-eie.ekt.gr:10442/7288"))

    nodes = res.xpath('//xmlns:metadata')

    @res = {}
    nodes.children.children.each do |node|
      if node.name == 'description' and node.text.length > 300
        last_boundary = node.text[0..300].rindex(/\s/)
        @res[node.name] = node.text[0..last_boundary]
        first_break = @res[node.name][0..100].rindex(/\s/)
        second_break = @res[node.name][0..200].rindex(/\s/)
        @res[node.name][second_break] = '<br/>'
        @res[node.name][first_break] = '<br/>'

        @res[node.name] = "#{@res[node.name]} ..."
      else
        @res[node.name] = node.text
      end
    end

    uri = URI.parse(@res['identifier'])
    host = uri.host.downcase
    @res['domain'] = host

    table = Nokogiri::HTML(open(uri)).xpath('//table[@class="itemDisplayTable"]/tr')

    table.each do |node|
      if node.children.first.text.downcase.include?('publisher link:') # and node.children.last.text.downcase.include?('.pdf')
        node.children.last.children.each do |link_node|
          if link_node.text.downcase.include?('.pdf')
            @res['pdf_link'] = link_node.text
          end
        end
      elsif node.children.first.text.downcase.include?('publisher:')
        @res['publisher'] = node.children.last.text
      end
    end
  end

  def helios_cite
    citations = []

    format = ['chicago-author-date', 'apa', 'harvard1']
    handle = '10442/8425'
    submit_button = 'html'

    url = URI.escape("http://helios-eie.ekt.gr/EIE/citation")
    uri = URI.parse(url)
    req = Net::HTTP::Post.new(uri)

    response = []

    format.each do |form|
      req.set_form_data('format' => form, 'handle' => handle, 'submit_button' => submit_button)

      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }

      tmp_resp = res.body

      begin
        cleaned = res.body.dup.force_encoding('UTF-8')
        unless cleaned.valid_encoding?
          cleaned = res.body.encode( 'UTF-8', 'Windows-1251' )
        end
        tmp_resp = cleaned
      rescue EncodingError
        tmp_resp.encode!( 'UTF-8', invalid: :replace, undef: :replace )
      end

      response << tmp_resp
    end

    puts "====================\n\ncite form\n\n===================="
    puts response.inspect
    puts "====================\n\ncite form\n\n===================="

    response.each do |resp|
      start_index = 0
      end_index = 0
      resp.to_enum(:scan,'class="csl-entry">').map do |m,|
        start_index = $`.size+18
      end

      puts "====================\n\nstart index\n\n===================="
      puts start_index
      puts "====================\n\nstart index\n\n===================="

      resp.to_enum(:scan,"</div>\n</div>\n</body></html>").map do |m,|
        end_index = $`.size-1
      end

      puts "====================\n\nend index\n\n===================="
      puts end_index
      puts "====================\n\nend index\n\n===================="

      citations << resp[start_index..end_index]
    end

    error = false

    respond_to do |format|
      if !error
        format.js { render json: citations }
      else
        format.js { render json: error }
      end
    end

  end
end
