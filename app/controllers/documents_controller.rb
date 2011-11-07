class DocumentsController < InheritedResources::Base
	respond_to :html, :js
	
	def index
		@filter = params[:filter]
		scope = paginate(scope_for(@filter).order('created_at desc'))
		@documents = if params[:search].present?
		  scope.search(params[:search])
	  else
	    scope
    end
	end
	
	def show
	  @users = resource.users
	  @groups = resource.groups
		@user_document = current_user.user_documents.find_by_document_id(params[:id]) if current_user
	  super
  end
	
	def download
		file = resource.file_url
		send_data(file, :disposition => 'attachment', :filename => File.basename(file))
	end
	
	private
	
	def scope_for(filter)
    case filter
    when 'my'
      current_user.documents
    when 'uploaded'
    	current_user.uploaded_documents
    else
      Document
    end
  end

end