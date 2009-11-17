class DocumentsController < ApplicationController
  def show
    @article = Article.find(params[:article_id])
    @document = @article.find_document(params[:id])
    send_file @article.document_path(@document), :filename => @document.name_with_extention
  end
  
  protected
  
  def module_name
    action_name == "displayarticle"
  end
  
  def function_name
     action_name == "display"
  end
end
