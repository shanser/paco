class Admin::TachesController < ApplicationController
  before_filter :set_admin

  # GET /taches/new
  # GET /taches/new.xml
  def new
    @tache = Tache.new
  end

  # GET /taches/1/edit
  def edit
    @tache = Tache.find(params[:id])
  end

  # POST /taches
  # POST /taches.xml
  def create
    @projet = Projet.first
    params[:tache][:projet_id] = @projet.id
    @tache = Tache.new(params[:tache])

    respond_to do |format|
      if @tache.save
        flash[:notice] = 'Tache was successfully created.'
        format.html { redirect_to(admin_projet_path) }
        format.xml  { render :xml => @tache, :status => :created, :location => @tache }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tache.errors, :status => :unprocessable_entity }
        format.js { render :action => "new" }
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
        format.html { redirect_to(admin_projet_path) }
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
      format.html { redirect_to(admin_projet_url) }
      format.xml  { head :ok }
    end
  end
end
