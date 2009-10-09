require 'test_helper'

class ArticleTest < ActiveSupport::TestCase

  should "save keywords in XML structure" do
    article = Article.new(:keyword_1 => '<foo>', :keyword_2 => 'bar', :keyword_3 => 'baz')
    article.save(false)
    assert_equal "<keywords>\r\n\t<kw>&lt;foo&gt;</kw>\r\n\t<kw>bar</kw>\r\n\t<kw>baz</kw>\r\n\t<kw />\r\n\t<kw />\r\n\t<kw />\r\n\t<kw />\r\n\t<kw />\r\n</keywords>\r\n", article.keywords
  end
  
  should "build document data as XML" do
    article = Article.new
    xml = "<documents>\r\n\t<document ID=\"1\">\r\n\t\t<filename>Cellokarta</filename>\r\n\t\t<filetype>.pdf</filetype>\r\n\t</document>\r\n\t<document ID=\"2\">\r\n\t\t<filename>Cobra</filename>\r\n\t\t<filetype>.pdf</filetype>\r\n\t</document>\r\n\t<document ID=\"3\">\r\n\t\t<filename>Cellofold</filename>\r\n\t\t<filetype>.pdf</filetype>\r\n\t</document>\r\n\t<document ID=\"4\">\r\n\t\t<filename>EagleCKB</filename>\r\n\t\t<filetype>.pdf</filetype>\r\n\t</document>\r\n\t<document ID=\"5\">\r\n\t\t<filename>Pearlkote</filename>\r\n\t\t<filetype>.pdf</filetype>\r\n\t</document>\r\n\t<document ID=\"6\">\r\n\t\t<filename>SP_Uncoated</filename>\r\n\t\t<filetype>.pdf</filetype>\r\n\t</document>\r\n\t<document ID=\"7\">\r\n\t\t<filename>Invercote_G</filename>\r\n\t\t<filetype>.pdf</filetype>\r\n\t</document>\r\n</documents>\r\n"
    article.assoc_documents = xml
    assert_equal xml, article.build_document_xml
  end
  
  should "build link data as XML" do
    article = Article.new
    xml = "<links>\r\n\t<link ID=\"1\">\r\n\t\t<name>foo</name>\r\n\t\t<url>http://www.foo.com.au</url>\r\n\t\t<target>_top</target>\r\n\t</link>\r\n\t<link ID=\"2\">\r\n\t\t<name>bar</name>\r\n\t\t<url>http://www.bar.com.au</url>\r\n\t\t<target>content</target>\r\n\t</link>\r\n</links>\r\n"
    article.assoc_web_pages = xml
    assert_equal xml, article.build_link_xml
  end
  
  should "build links from attributes" do
    article = Article.new
    article.link_attributes = [
      {:label => "Foo", :url => "http://foo.com", :target => "_top"},
      {:label => "Bar", :url => "http://bar.com", :target => "_blank"}
    ]
    assert_equal [Article::Link.new(1,"Foo","http://foo.com", "_top"),Article::Link.new(2,"Bar","http://bar.com", "_blank")], article.links
  end
  
  should "build dom using images and bodys" do
    expected_result = "<document>\n\t<section number=\"1\" layout=\"2\" imageNumber=\"1\">\n\t\t<title />\n\t\t<note />\n\t\t<text>%3Cp%3Etest%201234567%3C%2Fp%3E</text>\n\t</section>\n\t<image filename=\"henry.jpg\" number=\"1\" hspace=\"3\" vspace=\"3\">\n\t\t<caption />\n\t</image>\n</document>"
    article = Article.new
    article.template = Template.find(2)
    article.body_1 = '%3Cp%3Etest%201234567%3C%2Fp%3E' # '<p>test 1234567</p>'
    article.image_1_name = 'henry'
    article.image_1 = ""
    article.image_1_extention = '.jpg'
    assert_equal expected_result, article.build_document
    
    expected_result = "<document>\n\t<section number=\"1\" layout=\"1\" imageNumber=\"\">\n\t\t<title />\n\t\t<note />\n\t\t<text>%3Cp%3E%3C%2Fp%3E</text>\n\t</section>\n</document>"
    article = Article.new
    article.template = Template.find(1)
    article.body_1 = '%3Cp%3E%3C%2Fp%3E' # '<p>test 1234567</p>'
    assert_equal expected_result, article.build_document
  end
  
  
end
