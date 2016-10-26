class AddCoverToArticles < ActiveRecord::Migration
  def change
  	add_attachment :articles, :cover #add_attachemnt es adjunto, articles es la referencia, y cover es el nombre del campo que queremos crear
  end
end
