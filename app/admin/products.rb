ActiveAdmin.register Product do
  permit_params :title, :author, :description, :price, :sale_price, :on_sale, :image, category_ids: []

  controller do
    def scoped_collection
      super.includes(:categories).with_attached_image
    end
  end

  index do
    selectable_column
    id_column
    column(:cover) { |product| image_tag product.image.variant(:thumb), width: 50 if product.image.attached? }
    column :title
    column :author
    column(:price) { |product| number_to_currency(product.price) }
    column :on_sale
    column(:genres) { |product| product.categories.map(&:name).join(", ") }
    actions
  end

  filter :title
  filter :author
  filter :categories, label: "Genre"
  filter :on_sale
  filter :price

  show do
    attributes_table do
      row(:cover) { |product| image_tag product.image.variant(:large) if product.image.attached? }
      row :title
      row :author
      row :description
      row(:price) { |product| number_to_currency(product.price) }
      row :on_sale
      row(:sale_price) { |product| number_to_currency(product.sale_price) if product.sale_price }
      row(:genres) { |product| product.categories.map(&:name).join(", ") }
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Book details" do
      f.input :title
      f.input :author
      f.input :description
      f.input :price
      f.input :on_sale
      f.input :sale_price
      f.input :image, as: :file, label: "Cover",
                      hint: (image_tag(f.object.image.variant(:thumb)) if f.object.image.attached?)
    end
    f.inputs "Genres" do
      f.input :categories, as: :check_boxes, collection: Category.order(:name)
    end
    f.actions
  end
end