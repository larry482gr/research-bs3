#
# Copyright 2015 Kazantzis Lazaros
#

class OpenSearchController < ApplicationController
  include OpenSearchHelper

  require 'open-uri'
  require 'nokogiri/xml'
  require 'nokogiri/html'
  require 'net/http'
  require 'uri'

  def list_sets
    repo = repo_uri(params[:repo])

    set = Nokogiri::XML(open("#{repo}?verb=ListSets"))

    listSet = []
    set.xpath('//xmlns:set').each do |item|
      xml_item = Nokogiri::XML(item.to_xml)

      unless xml_item.xpath('//setSpec').text.blank? or xml_item.xpath('//setName').text.blank?
        listSet << { set_key: xml_item.xpath('//setSpec').text, set_val: xml_item.xpath('//setName').text }
      end
    end

    respond_to do |format|
      format.js { render json: listSet }
    end
  end

  def list_records
    repo = repo_uri(params[:repo])
    q_words	= query_words(params[:q])
    list_set = params[:listSet].split(',')

    start		= params[:start].to_i
    num			= params[:num].to_i

    res = Nokogiri::XML(open("#{repo}?verb=ListRecords&metadataPrefix=oai_dc"))

    records = res.xpath('//xmlns:record')

    results = []
    index = 0
    total = 0

    records.each do |record|
      set_match = false

      # Go in header/metadata
      record.children.each do |record_part|
        unless list_set.blank?
          if record_part.name == 'header'
            # Go in header
            record_part.children.each do |set_spec|
              if set_spec.name == 'setSpec'
                set_match = list_set.any?{ |set| set_spec.text.include? set }
                break if set_match
              end
            end
          end

          next unless set_match
        end

        if record_part.name == 'metadata'
          # Go in metadata
          res = {}
          match_against = []
          record_part.children.children.each do |node|
            if node.name == 'description' and node.text.length > 300
              last_boundary = node.text[0..300].rindex(/\s/)
              res[node.name] = node.text[0..last_boundary]
              first_break = res[node.name][0..100].rindex(/\s/)
              second_break = res[node.name][0..200].rindex(/\s/)
              res[node.name][second_break] = '<br/>'
              res[node.name][first_break] = '<br/>'

              res[node.name] = "#{res[node.name]} ..."
              match_against << node.text unless node.text.nil?
            elsif node.name == 'identifier'
              res[node.name] = node.text if is_url?(node.text)
            else
              res[node.name] = node.text
              if node.name == 'title'
                match_against << node.text unless node.text.nil?
              end
            end
          end

          search_match = false
          match_against.select do |param|
            search_match = q_words.any?{ |word| param.downcase.match(/((^|\s)#{word.downcase}(\s|$))/i) }
            break if search_match
          end

          next unless search_match

          index += 1
          total += 1

          next unless index.between?(start+1, num+start)

          begin
            uri = URI.parse(res['identifier'])
            host = uri.host.downcase
            res['domain'] = host

            table = Nokogiri::HTML(open(uri)).xpath('//table[@class="itemDisplayTable"]/tr')

            table.each do |node|
              if node.children.first.text.downcase.include?('publisher link:')
                node.children.last.children.each do |link_node|
                  if link_node.text.downcase.include?('.pdf')
                    res['pdf_link'] = link_node.text
                  end
                end
              elsif node.children.first.text.downcase.include?('publisher:')
                res['publisher'] = node.children.last.text
              end
            end
          rescue => e
            puts "[#{Time.now}] - [ERROR] OpenSearchController: #{e}"
          end

          q_words.each do |word|
            res['title'].gsub!(/((^|\s)#{word}(\s|$))/i, '<b>\1</b>') unless res['title'].nil?
            res['description'].gsub!(/((^|\s)#{word}(\s|$))/i, '<b>\1</b>') unless res['description'].nil?
          end

          results << res if index.between?(start+1, num+start)
        end
      end
    end

    if total == 0
      results = t(:no_results)
    end

    if request.referer.to_s.end_with?('projects') or request.referer.to_s.end_with?('projects/')
      session[:search_gs] = params[:q]
      session[:source] = repo
    end

    respond_to do |format|
      format.js { render json: { results: results, total: total.to_s, search: params[:q] } }
    end
  end

=begin
  def cite_record
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
      rescue EncodingError => e
        puts "caught exception #{e}"
        tmp_resp.encode!( 'UTF-8', invalid: :replace, undef: :replace )
      end

      response << tmp_resp
    end

    response.each do |resp|
      start_index = 0
      end_index = 0
      resp.to_enum(:scan,'class="csl-entry">').map do |m,|
        start_index = $`.size+18
      end

      resp.to_enum(:scan,"</div>\n</div>\n</body></html>").map do |m,|
        end_index = $`.size-1
      end

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
=end

  private

  def is_url?(identifier)
    identifier[0..3] == 'http'
  end

end
