class TachesController < ApplicationController
  # GET /taches
  # GET /taches.xml
  def index
    @taches = Tache.all
    begin
      projet = Projet.new
      @google_graph = projet.google_graph
      prediction = projet.projection_date_fin
      @prediction_date_fin = "Paco prédit que le projet se finira le #{I18n.l prediction}"
    rescue Paco::CalculProjectionImpossible
      @prediction_date_fin = 'Paco ne sait pas encore prédire la date de fin du projet'
    rescue Paco::ProjetInterminable
      @prediction_date_fin = 'Paco prédit que le projet ne se terminera jamais à ce rythme'
    rescue Paco::ProjetTermine
      @prediction_date_fin = 'Paco constate que le projet est terminé'
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taches }
    end
  end
end