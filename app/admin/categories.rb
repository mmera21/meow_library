ActiveAdmin.register Category do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column("Books") { |category| category.products.count }
    actions
  end

  filter :name

  show do
    attributes_table do
      row :name
      row :created_at
    end

    panel "Books in this genre" do
      table_for category.products.order(:title) do
        column(:title) { |product| link_to product.title, admin_product_path(product) }
        column :author
      end
    end
  end
end