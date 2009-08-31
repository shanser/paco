class EtiquetagesController < ApplicationController
  
  before_filter :setup_taches_and_tags, :only => [:new, :edit]
  
  # GET /etiquetages
  # GET /etiquetages.xml
  def index
    @etiquetages = Etiquetage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @etiquetages }
    end
  end

  # GET /etiquetages/1
  # GET /etiquetages/1.xml
  def show
    @etiquetage = Etiquetage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @etiquetage }
    end
  end

  # GET /etiquetages/new
  # GET /etiquetages/new.xml
  def new
    @etiquetage = Etiquetage.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @etiquetage }
    end
  end

  # GET /etiquetages/1/edit
  def edit
    @etiquetage = Etiquetage.find(params[:id])
  end

  # POST /etiquetages
  # POST /etiquetages.xml
  def create
    @etiquetage = Etiquetage.new(params[:etiquetage])

    respond_to do |format|
      if @etiquetage.save
        flash[:notice] = 'Etiquetage was successfully created.'
        format.html { redirect_to(@etiquetage) }
        format.xml  { render :xml => @etiquetage, :status => :created, :location => @etiquetage }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @etiquetage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /etiquetages/1
  # PUT /etiquetages/1.xml
  def update
    @etiquetage = Etiquetage.find(params[:id])

    respond_to do |format|
      if @etiquetage.update_attributes(params[:etiquetage])
        flash[:notice] = 'Etiquetage was successfully updated.'
        format.html { redirect_to(@etiquetage) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @etiquetage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /etiquetages/1
  # DELETE /etiquetages/1.xml
  def destroy
    @etiquetage = Etiquetage.find(params[:id])
    @etiquetage.destroy

    respond_to do |format|
      format.html { redirect_to(etiquetages_url) }
      format.xml  { head :ok }
    end
  end
  
  def setup_taches_and_tags
    @taches = Tache.all
    @tags = Tag.all
  end
end
