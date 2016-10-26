class ArticlesController < ApplicationController
	before_action :authenticate_user!, except: [:show,:index]#authenticate es un metodo helper que devise proporciona, autentica al usuario, excepto en el show y el index, el metodo valida
	#before_action :authenticate_user!, only: [:create,:new]#de igual forma sirve para autenticar usuarios como las dos lineas de abajo, con la excepcion de que este es un metodo de devise
	#before_action :validate_user, except: [:show,:index]#el metodo validate user se crea en la parte inferior, en el metodo private 
	#after_action :validate_user, except: [:show,:index] tambien se puede utilizar pero dependiendo del caso
	#GET/articles       a esta ruta se accede con el verbo get y el pad article
	before_action :set_article, except: [:index,:new,:create]#el metodo set article, evita que repitamos codigo, con el metodo que se encuentra especificado abajo, en private. excepto a estas que no mandamos ningun parametro, con esto evitamos colocar esta linea de codigo varias veces 	 #@article = Article.find(params[:id])
 
	before_action :authenticate_admin!, only: [:destroy,:publish]
	
#cada uno de los metodos como el del index, show, etc se les debe de crear su propia vista
	def index	#hace referencia al archivo index.html.erb en vista, articles. dada que esta es la accion que nos traera la lista de todos los articulos, se programara todo en la accion index
	#este seria como un SELECT * FROM articles en sql articles.all
	@articles = Article.paginate(page: params[:page],per_page:5).publicados.ultimos#metodo para paginar, y podemos colocarle nuestra relacion de busqueda scope
	#@articles = Article.publicados.ultimos #.published es una particularidad de la gema aasm y se cambio por publicados.ultimos que es un llamado del scope para realizar un orden o busquedas  
	#@articles = Article.where(state: "published")  #busqueda con condicion
	#@articles = Article.all   #dado que en article.rb solo porque esta heredando de ActiveRecord::Base ya tiene los metodos con los que se accedera a la base de datos 	
	end     #el metodo all del arriba nos permite traer todos los registros de la base de datos de este modelo ARTICLE
	#dado que empieza con un arroba, la tendremos tanto como en la vista como en el controlador. sin el arroba se quedan en el controlador
		

	#GET/articles/:id
		#cuando se genera una tabla, automaticamente se crea un campo llamado id q sera PK incrementable,ese es el campo por donde ruby on rails busca los registros
	def show

	#@article = Article.find(params[:id])#params es un hash que tiene todos los parametros que se mandaron al servidor web. busca el elemento  LINEA DE CODIGO REPETIDA, SOLO BASTA CON TENERLA EN EL METODO SET_ARTICLE 
	#where    BUSQUEDAS
	#Article.where(" body LIKE ? ","%hola%")
	#Article.where(" id = ? ",params[:id])#este solo devolvera un elemento
	#Article.where(" id = ? AND title = ?",params[:id],params[:title])#,multiples condiciones
	#Article.where(" id = ? OR title = ?",params[:id],params[:title])#,multiples condiciones
	#Article.where.not(" id = ?",params[:id])#busqueda de todos los articulos que el id sea diferente del que el usuario paso como parametros

		@article.update_visits_count#va aumentando el visits_count con la ayuda de un metodo en el modelo, llamado update_visits_count, y el set visits count, junto con el before_save
		@comment = Comment.new#NESTED RESOURCE inicializamos un nuevo comentario


	end

#las validaciones se colocan en el modelo de articles
	#GET/articles/new
	def new
		@article = Article.new #crea un nuevo articulo, pero no guarda en la base de datos, solamente lo guarda en memoria
		@category = Category.all
	end 

	#POST/articles
	def create
		# es como un INSERT INTO en sql
		#esta linea de codigo de abajo es por seguridad, trabaja junto con el metodo private, y es para evitar q el usuario sobreescriba algun dato q no tenga acceso
		#@article = Article.new(article_params)#de esta forma
		@article = current_user.articles.new(article_params)#IMPORTANTE trabaja junto con el article_params del metodo PRIVATE generado en la parte inferior de este articles_controller. se le pasan los strong params para proteger la applicacion ##se le agrego current_user para poder articles es un metodo que ahora current_user tiene, ya que se lo pusimos en models user.rb
		#articles es un metodo que ahora current_user tiene ya que en el modelo le colocamos has_many :articles

		@article.categories = params[:categories]
		#@article = Article.new(title: params[:article][:title],#title: pasamos como clave el campo de la base de datos q queremos guardar, y el parametro. primero accedemos a article y luego al campo
		#					   body: params[:article][:body])#los datos que mandamos en un formulario o por la url, se acceden por el metodo params
	
		#TAMBIEN SE PUEDE HACER DE ESTA FORMA, CON CREATE
		#@article = Article.create(title: params[:article][:title],
		#					   body: params[:article][:body])

		#validacion 
		if @article.save#para guardarlo en la base de datos #si el articulo pudo guardarse es q las validaciones pasaron 	
			redirect_to @article	#redirigir a la vista de ese articulo
		else
			render :new #si las validaciones no pasaron, vamos a hacer render a la accion new, osea redirige a la misma pagina
		end
 	end



 	def edit#este metodo trabajar con el update
 		#@article = Article.find(params[:id])LINEA DE CODIGO REPETIDA, SOLO BASTA CON TENERLA EN EL METODO SET_ARTICLE 
 	end

 	#PUT /articles/:id
 	def update
 	 #@article = Article.find(params[:id])LINEA DE CODIGO REPETIDA, SOLO BASTA CON TENERLA EN EL METODO SET_ARTICLE 
 	 	if @article.update(article_params)#IMPORTANTE trabaja junto con el article_params del metodo PRIVATE generado en la parte inferior de este articles_controller. se le pasan los strong params para proteger la applicacion
 	 		redirect_to @article#si el articulo pudo haber sido guardado redirigelo a article
 	 	else
 	 		render :edit#si algo salio mal,redirigirlo a edit
 	 	end
 		
 	end

	#DELETE /articles/:id
 	def destroy 	#Destroy elimina el objeto de la base de datos
 		#DELETE FORM articles
 		#article = Article.find(params[:id])
 		@article.destroy
 		redirect_to articles_path
 	end 

 	def publish
 		@article.publish! #cambia a publish	
 		redirect_to @article
 	end

	#esto es para hacer mas segura la pagina, y evitar que el usuario reedite algun campo que no tenga acceso
private #todo lo que este abajo del private, van a ser metodos privados de la clase ESTOS SON LOS STRONG PARAMS
	
	#se crea este article params para evitar que el usuario mande datos que no son permitidos, como la modificacion de tipo de usuario a la hora de registrarse, el visits coun, etc
 	def article_params #article_params es un nombre que generalmente es convencion
 		params.require(:article).permit(:title,:body,:cover,:categories,:markup_body)	#requerimos article, y luego pasamos un arreglo con campos que son permitidos para esta accion
 	#por ejemplo title y body, y no son permitidos visits_count ni ningun dato que sea sensible, ninguno que queramos que el usuario toque
 	end 

 	def set_article
 		@article = Article.find(params[:id])#con ayuda del before action :set_article de arriba,usamos esto para que no se repita el codigo con esta linea, hacemos refactor de el, y eliminamos las lineas q lo tengan varias veces
 	end

 	def validate_user
 		redirect_to new_user_session_path, notice: "Necesitas iniciar sesion" 
 	end

 		
 	
end