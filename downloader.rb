require '../../multiple_downloader.rb'
require 'nokogiri'
require 'optparse'
require 'open-uri'
require 'cgi'
require 'benchmark'

base = 'https://pdd.auto-cargo.com/'

puts Benchmark.measure{
  doc = Nokogiri::HTML(URI.open(base + 'plan-konspekt.html'))

  `md "./page"`

  urls = doc.search("//section[@id='content']//div[@class='box']//center/p").map{
    img = _1.children[0]
    base + ( img['src'] ? img['src'] : img['href'] )
  }.uniq

  download_multiple_files(urls, threads_count: 20, max_fails: nil) do
    path = "./page/" + ( urls.index(_1) + 1 ).to_s + "." + _1.split(".")[-1]
    [_1, path]
  end
}