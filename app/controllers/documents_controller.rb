class DocumentsController < AuthenticatedController
  def index
    @documents = Document.all
    if not params[:title].blank?
      @documents = @documents.where('title ILIKE ?', "%#{params[:title]}%")
    end
    if not params[:body].blank?
      @documents = @documents.where("body ->> 'foo' ILIKE ?", "%#{params[:body][:foo]}%") unless params[:body][:foo].blank?
      @documents = @documents.where("body ->> 'bar' ILIKE ?", "%#{params[:body][:bar]}%") unless params[:body][:bar].blank?
    end
  end

  def new
    @document = Document.new(body: {}, type: params[:type])
  end

  def create
    @document = Document.new(title: params[:title], body: params[:body], type: params[:type])
    @document.user = current_user

    if @document.save
      redirect_to document_path(@document)
    else
      render :new
    end
  end

  def show
    find_document
  end

  def edit
    find_document
  end

  def update
    find_document
    @document.title = params[:title]
    @document.body = params[:body]

    if @document.save
      redirect_to document_path(@document)
    else
      render :edit
    end
  end

  def destroy
    find_document
    @document.destroy
  end

  private

  def find_document
    @document = Document.find(params[:id])
  end
end
