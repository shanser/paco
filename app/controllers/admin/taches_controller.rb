class Admin::TachesController < TachesController
  layout 'admin'
  before_filter :set_admin
  
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
        format.html { redirect_to([:admin, @tache]) }
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
        format.html { redirect_to([:admin, @tache]) }
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
      format.html { redirect_to(admin_taches_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def set_admin
    @mode_admin = true
    
  end
end
