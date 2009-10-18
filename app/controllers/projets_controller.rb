class ProjetsController < ApplicationController
  mattr_accessor :formulation
  self.formulation = {:projet_termine => 'Paco constate que le projet est terminé',
                      :projet_interminable => 'Paco prédit que le projet ne se terminera jamais à ce rythme',
                      :projection_impossible => 'Paco ne sait pas encore prédire la date de fin du projet'}
  
  def show

    projet = Projet.first
    @date_stabilisation_backlog = projet.date_stabilisation_backlog
    @taches = projet.taches
    @google_graph = projet.google_graph

    prediction = projet.prediction_date_fin
    @prediction_date_fin = formulation_paco prediction
    @conclusion = conclusion_paco projet, prediction
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taches }
    end
  end


  private

  def formulation_paco prediction
    (cas_normal? prediction) ? 
      "Paco prédit que le projet se finira le #{I18n.l prediction}" : 
      formulation[prediction]
  end
  
  def conclusion_paco projet, prediction
    return :ok if (prediction == :projet_termine) or (cas_normal?(prediction) and dans_les_clous?(projet, prediction))
    :ko
  end
  
  def dans_les_clous? projet, prediction
    !projet.deadline.nil? and projet.deadline >= prediction
  end
  
  def cas_normal? prediction
    formulation[prediction].nil?
  end  
end