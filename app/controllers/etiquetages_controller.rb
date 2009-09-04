class EtiquetagesController < ApplicationController
  
  # GET /etiquetages
  # GET /etiquetages.xml
  def index
    @etiquetages = Etiquetage.all(:include => :tag, :order => 'tags.description')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @etiquetages }
    end
  end

end
