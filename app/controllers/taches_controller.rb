class TachesController < ApplicationController
  # GET /taches
  # GET /taches.xml
  def index
    @taches = Tache.all
    begin
      @google_graph = Projet.google_graph
      prediction = Projet.projection_date_fin
      @prediction_date_fin = "Paco prédit que le projet se finira le #{I18n.l prediction}"
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
end