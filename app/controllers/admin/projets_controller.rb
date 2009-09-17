class Admin::ProjetsController < ProjetsController
  layout 'admin'
  before_filter :set_admin
  
end
