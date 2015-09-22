#
# Copyright 2015 Kazantzis Lazaros
#

class IeeeController < ApplicationController
  include OpenSearchHelper

  require 'open-uri'
  require 'nokogiri/xml'
  require 'nokogiri/html'
  require 'net/http'
  require 'uri'

  def list_records
    q_words	= query_words(params[:q])

    start		= params[:start].to_i + 1
    num			= params[:num].to_i

    url = URI.escape("http://ieeexplore.ieee.org/gateway/ipsSearch.jsp?querytext=#{params[:q]}&rs=#{start}&hc=#{num}")
    uri = URI.parse(url)

    res = Nokogiri::XML(open(uri))

    total = res.xpath('//totalfound')
    records = res.xpath('//document')

    results = []
    total = total.text.to_i

    records.each do |record|
      res = {}
      record.children.each do |node|
        if node.name == 'abstract' and node.text.length > 300
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

      unless q_words.nil?
        q_words.each do |word|
          res['title'].gsub!(/((\b)#{word}(\b))/i, '<b>\1</b>') unless res['title'].nil?
          res['description'].gsub!(/((\b)#{word}(\b))/i, '<b>\1</b>') unless res['description'].nil?
        end
      end

      res['domain'] = URI.parse("#{res['mdurl']}").host.downcase

      results << res
    end

    if total == 0
      results = t(:no_results)
    end

    if request.referer.to_s.end_with?('projects') or request.referer.to_s.end_with?('projects/')
      session[:search_gs] = params[:q]
    end

    total = total.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse

    respond_to do |format|
      format.js { render json: { results: results, total: total, search: params[:q] } }
    end
  end

end
