class Article < ActiveRecord::Base	
	
	include AASM #para q nuestro modelo pueda hacer uso de la maquina de estado q ofrece la gema
	belongs_to :user #para poder relacionar el articulo con el usuario que lo creo
	has_many :comments#NESTED RESOURCES
	has_many :has_categories
	has_many :categories, through: :has_categories
	
	#validacionessss
	validates :title, presence: true, uniqueness: true #presence true validara que el elemento no se pueda guardar vacio y uniquenes para que no se repita en la base de datos
	validates :body, presence: true, length: { minimum: 7 } #presence true verifica q title o body no este vacio y la longitud del campo
	#validates :username, format: { with: /regex/ } ejemplo de otro tipo de validacion, que especifica el formato de usuario

	before_save :set_visits_count #dado que no le añadimos un valor por defecto a visits_count, le añadimos este before_save, para asignarle un valor antes de guardarlo, este metodo lo especificamos en el private de abajo
	after_create :save_categories

	has_attached_file :cover, styles: { medium: "1280x720", thumb: "800x600"}
	#attached file q tiene un archivo adjunto, q es cover, el mismo campo agregado en la migracion. styles es para configuraciones, y especificamos las dos versiones de tamaños
	validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/#validacion para evitar ataques, y solo esperar un tipo de archivo en content type, como pdf, ejecutables, imagenes etc. con el tipo de archivo especificado, el usuario puede subir varios tipos de imagenes 
   
	scope :publicados, ->{ where(state: "published") } #ser independiente de el metodo de state machine
	scope :ultimos, ->{ order("created_at DESC") } #permite ordenar los articulos de manera descendiende, los ultimos q se crearon
	#scope :ultimos, ->{ order("created_at DESC").limit(10) } #permite ordenar los articulos de manera descendiende, los ultimos q se crearon
    #custom setter
	def categories=(value)
		@categories = value
	end

	def update_visits_count#con este metodo, va aumentando las visitas
		#self.save if self.visits_count.nil? #para evitar un error que dara si algun campo tenga visits count en nulo por defecto antes de que se creara la modificacion. esto hace que guarde el modelo,sin modificar nada, esto a su vez ejecutara el before_save :set_visits_count. si el contador de visitas esta en nulo guardalo. se comento esta linea porque ya todos los articulos con uso de esta linea, tienen datos
		self.update(visits_count: self.visits_count + 1)
	end

	aasm column: "state" do
		state :in_draft, initial: true
		state :published

		event :publish do 
			transitions from: :in_draft, to: :published
	 	end

	 	event :unpublish do
	 		transitions from: :published, to: :in_draft 

	 	end
	 end


	private

	def save_categories
		unless @categories.nil?
	 		@categories.each do |category_id|
	 		 HasCategory.create(category_id: category_id,article_id: self.id)
	 		end
		end
	end
	
	def set_visits_count
		self.visits_count ||= 0 #si este valor que estoy remarcando es nulo, asignale cero '0'. si no es nulo no asignes nada, dejalo como estaba
	end
end
#uniqueness verifica que no se introduzca un titulo igual a alguno que este en la base de datos, length es la longitud q debe de tener el cuerpo del campo
#otro ejemplo seria :username, formate: {with: /regex/ }
#