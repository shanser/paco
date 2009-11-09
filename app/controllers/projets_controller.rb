class ProjetsController < ApplicationController
  mattr_accessor :formulation
  self.formulation = {:projet_termine => 'Paco constate que le projet est terminé',
                      :projet_interminable => 'Paco prédit que le projet ne se terminera jamais à ce rythme',
                      :projection_impossible => 'Paco ne sait pas encore prédire la date de fin du projet'}
  
  def show

    projet = Projet.first
    @date_stabilisation_backlog = projet.date_stabilisation_backlog
    @google_graph = projet.google_graph
    @graphe_historique = projet.graphe_historique
    @prediction_date_fin = projet.formulation_paco
    @tout_va_bien = projet.va_t_il_bien?
    
    
    etiquetages = Etiquetage.all(:include => :tag, :order => 'tags.description')
    tags = etiquetages.collect(&:tag).uniq
    @etiquetages = {}
    tags.each {|tag| @etiquetages[tag.description] = etiquetages.select{|e| e.tag == tag}}
    
    taches_etiquetees = @etiquetages.values.flatten.collect(&:tache)
    @taches = projet.taches
    @taches = @taches - taches_etiquetees
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taches }
    end
  end
end