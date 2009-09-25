class Admin::ProjetsController < ProjetsController
  before_filter :set_admin
  
  def edit
    @projet = Projet.first
  end
  
  def update
    @projet = Projet.first    
    if @projet.update_attributes(params[:projet])
      flash[:notice] = 'Projet was successfully updated.'
      redirect_to(admin_projet_path)
    else
      render :action => "edit"
    end
  end
  
end
