class Category < ActiveRecord::Base
	has_many :has_categories
	has_many :articles, through: :has_categories
	validates :name, presence: true, uniqueness: true, length: { minimum: 2 }  #presence true validara que el elemento no se pueda guardar vacio y uniquenes para que no se repita en la base de datos

end
