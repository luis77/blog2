class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
         has_many :articles#referencia a articulos, para saber que usuario creo el articulo
         has_many :comments#NESTED RESOURCES- un usuario tiene muchos comentarios

         include PermissionsConcern #esta haciendo uso del concern
         
         def avatar
			# get the email from URL-parameters or what have you and make lowercase
			email_address = self.email.downcase

			# create the md5 hash
			hash = Digest::MD5.hexdigest(email_address)

			# compile URL which can be used in <img src="RIGHT_HERE"...
			image_src = "http://www.gravatar.com/avatar/#{hash}"
		end
end
