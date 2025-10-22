class CreateMaterials < ActiveRecord::Migration[7.1]
  def change
    create_table :materials do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :type
      t.references :user, null: false, foreign_key: true
      t.references :author, polymorphic: true, null: false
      t.string :isbn
      t.integer :pages
      t.string :doi
      t.integer :duration_in_minutes

      t.timestamps
    end
    # Isso garante a unicidade e permite valores NULL (varias linhas com NULL nessas colunas são permitidas)
    add_index :materials, :isbn, unique: true, where: "isbn IS NOT NULL"
    add_index :materials, :doi, unique: true, where: "doi IS NOT NULL"
  end
end

# Vamos utilizar STI (Single Table Inheritance - Herança por Tabela Única). Isso significa que todas as subclasses de Material (Livro, Artigo, Vídeo, etc.) serão armazenadas na mesma tabela "materials", e o campo "type" será usado pelo Rails para distinguir entre essas subclasses.