module OpenSearchHelper
  def repo_uri(option)
    repos = { eadd: 'http://www.didaktorika.gr/eadd-oai/request',
              helios: 'http://helios-eie.ekt.gr/EIE_oai/request',
              acropolis: 'http://repository.acropolis-education.gr/acr_edu_oai/request',
              ellak: 'http://repository.ellak.gr/ellak_oai/request',
              edulll: 'http://repository.edulll.gr/edulll-oai/request',
              parthenon: 'http://repository.parthenonfrieze.gr/frieze-oai/request',
              pandektis: 'http://pandektis.ekt.gr/pandektis-ext-oai/request',
              simitis: 'http://repository.costas-simitis.gr/sf-repository-oai/request',
              levadia: 'http://ebooks.liblivadia.gr/liblivadia-oai/request',
              serres: 'http://ebooks.serrelib.gr/serrelib-oai/request',
              byzant: 'http://www.byzsym.org/index.php/index/oai',
              historical: 'http://www.historicalreview.org/index.php/index/oai',
              tekmiria: 'http://www.tekmeria.org/index.php/index/oai',
              latic: 'http://www.latic-journal.org/index.php/latic/oai',
              deltiokms: 'http://www.deltiokms.org/index.php/deltiokms/oai',
              dialogoi: 'http://www.dialogoi-journal.org/index.php/dialogoi/oai',
              grsr: 'http://www.grsr.gr/index.php/ekke/oai',
              esperia: 'http://www.eoaesperia.org/index.php/esperia/oai',
              historein: 'http://historeinonline.org/index.php/historein/oai',
              makedonika: 'http://www.makedonikajournal.org/index.php/makedonika/oai',
              mnimon: 'http://mnimon.gr/index.php/mnimon/oai',
              eranistis: 'http://ejournals.epublishing.ekt.gr/index.php/eranistis/oai',
              benaki: 'http://www.benakijournal.org/index.php/benaki/oai',
              childeducation: 'http://childeducation-journal.org/index.php/education/oai',
              sygkrisi: 'http://www.comparison-gcla.org/index.php/sygkrisi/oai'
            }

    return repos[option.to_sym]
  end

  def query_words(phrase)
    words	= phrase.split
    real_words = []

    words.each do |word|
      real_words << word unless word.length < 4
    end

    return real_words
  end
end