class OpenSearchController < ApplicationController
  require 'open-uri'
  require 'nokogiri/xml'

  def helios_list
    #verb		= params[:verb]
    verb    = 'ListSets'

    res = Nokogiri::XML(open("http://helios-eie.ekt.gr/EIE_oai/request?verb=#{verb}"))

    @res = []
    res.xpath('//xmlns:setName').each do |set_name|
      @res << set_name.text
    end
  end

  def helios_show
    #verb		= params[:verb]
    verb    = 'GetRecord'

    res = Nokogiri::XML(open("http://helios-eie.ekt.gr/EIE_oai/request?verb=#{verb}&metadataPrefix=oai_dc&identifier=oai:http://helios-eie.ekt.gr:10442/8425"))

    nodes = res.xpath("//xmlns:metadata")

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

    puts "\n\nRes inspect: #{@res.inspect}\n\n"
  end
end
