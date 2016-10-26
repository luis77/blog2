class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy, :show]
  before_action :set_article#NESTED RESOURCES- obtenemos el id con este metodo definido en private
  before_action :authenticate_user!

  # GET /comments
  # GET /comments.json    rutas comentadas no las utilizare en este caso
  #def index
  #  @comments = Comment.all
 # end

  # GET /comments/1
  # GET /comments/1.json
  #def show
  #end

  # GET /comments/new
  #def new
  #  @comment = Comment.new
  #end

  # GET /comments/1/edit
  #def edit
  #end
  def show
    
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = current_user.comments.new(comment_params)#NESTED RESOURCES- construimos a traves de una asosiacion
    @comment.article = @article#NESTED RESOURCE- antes de guardar el comentario decimos que el articulo es el mismo de la url
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.article, notice: 'Comment was successfully created.' }#NESTED RESOURCES- redirigir al usuario en la creacion del comentario al article del comentario
        format.json { render :show, status: :created, location: @comment.article }#AJAXse le agrega el .article para hacer uso de ajax
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment.article, notice: 'Comment was successfully updated.' }#NESTED RESOURCES- redirigimos
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @article, notice: 'Comment was successfully destroyed.' }#NESTED RESOURCES- redireccionamos
      format.json { head :no_content }
    end
  end

  private
    def set_article
      @article = Article.find(params[:article_id])# NESTED RESOURCE- metodo para obtener el id
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :article_id, :body)
    end
end
