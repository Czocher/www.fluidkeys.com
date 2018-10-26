weeknotes = blog('weeknotes').articles
blog_posts = blog('blog').articles

combined = [weeknotes,blog_posts].flatten.compact.sort_by(&:date).reverse

xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = "https://www.fluidkeys.com/"
  xml.title "Fluidkeys Blog"
  xml.updated(combined.first.date.to_time.iso8601) unless combined.empty?
  xml.author { xml.name "Fluidkeys" }

  combined.each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => URI.join(site_url, article.url)
      xml.id URI.join(site_url, article.url)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      xml.author { xml.name article.data.author }
      # xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end
