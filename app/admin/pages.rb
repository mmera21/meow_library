ActiveAdmin.register Page do
  permit_params :title, :content
  actions :all, except: %i[new destroy]
  config.filters = false

  index do
    column :title
    column :slug
    column :updated_at
    actions
  end

  form do |f|
    f.inputs "Page content" do
      f.input :title
      f.input :content, input_html: { rows: 12 }
    end
    f.actions
  end
end