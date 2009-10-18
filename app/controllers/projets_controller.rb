class ProjetsController < ApplicationController
  mattr_accessor :correspondances
  self.correspondances = {:projet_termine => 'Paco constate que le projet est terminé',
                          :projet_interminable => 'Paco prédit que le projet ne se terminera jamais à ce rythme',
                          :projection_impossible => 'Paco ne sait pas encore prédire la date de fin du projet'}
  
  def show

    projet = Projet.first
    @date_stabilisation_backlog = projet.date_stabilisation_backlog
    @taches = projet.taches
    @google_graph = projet.google_graph

    prediction = projet.prediction_date_fin
    correspondance = correspondances[prediction]
    @prediction_date_fin = correspondance.nil? ? "Paco prédit que le projet se finira le #{I18n.l prediction}" : correspondance

    @conclusion = :ko
    @conclusion = :ok if (prediction == :projet_termine) or (!projet.deadline.nil? and correspondance.nil? and projet.deadline >= prediction)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taches }
    end
  end
end