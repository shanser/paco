class TachesController < ApplicationController
  # GET /taches
  # GET /taches.xml
  def index
    @taches = Tache.all
    begin
      @google_graph_data = Projet.to_google_graph_data
      prediction = Projet.projection_date_fin
      @prediction_date_fin = "Paco prédit que le projet se finira le #{I18n.l prediction, :format => :date}"
    rescue Paco::CalculProjectionImpossible
      @prediction_date_fin = 'Paco ne sait pas encore prédire la date de fin du projet'
    rescue Paco::ProjetInterminable
      @prediction_date_fin = 'Paco prédit que le projet ne se terminera jamais à ce rythme'
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taches }
    end
  end

  # GET /taches/1
  # GET /taches/1.xml
  def show
    @tache = Tache.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tache }
    end
  end

  # GET /taches/new
  # GET /taches/new.xml
  def new
    @tache = Tache.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tache }
    end
  end

  # GET /taches/1/edit
  def edit
    @tache = Tache.find(params[:id])
  end

  # POST /taches
  # POST /taches.xml
  def create
    @tache = Tache.new(params[:tache])

    respond_to do |format|
      if @tache.save
        flash[:notice] = 'Tache was successfully created.'
        format.html { redirect_to(@tache) }
        format.xml  { render :xml => @tache, :status => :created, :location => @tache }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tache.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /taches/1
  # PUT /taches/1.xml
  def update
    @tache = Tache.find(params[:id])

    respond_to do |format|
      if @tache.update_attributes(params[:tache])
        flash[:notice] = 'Tache was successfully updated.'
        format.html { redirect_to(@tache) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tache.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /taches/1
  # DELETE /taches/1.xml
  def destroy
    @tache = Tache.find(params[:id])
    @tache.destroy

    respond_to do |format|
      format.html { redirect_to(taches_url) }
      format.xml  { head :ok }
    end
  end
end
