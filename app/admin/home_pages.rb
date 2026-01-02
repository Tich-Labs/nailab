# frozen_string_literal: true

if defined?(ActiveAdmin)
  ActiveAdmin.register HomePage do
  menu false

  permit_params :hero_title, :hero_image_url, :cta_1_text, :cta_1_url, :cta_2_text, :cta_2_url,
                :stat_1_label, :stat_1_value, :stat_2_label, :stat_2_value, :stat_3_label, :stat_3_value,
                :about_title, :about_image_url, :about_button_text, :about_button_url, :support_title,
                :connect_title, :connect_description, :connect_cta_1_text, :connect_cta_1_url,
                :connect_cta_2_text, :connect_cta_2_url, :impact_title,
                :hero_subtitle, :about_body,
                focus_areas_attributes: %i[id title description _destroy],
                support_features_attributes: %i[id title description _destroy],
                testimonials_attributes: %i[id quote name title company image_url company_url _destroy],
                impact_logos_attributes: %i[id image_url alt_text link_url _destroy],
                stakeholder_blocks_attributes: %i[id role title body cta_url cta_label _destroy]

  index do
    selectable_column
    id_column
    column :hero_title
    column :about_title
    column :support_title
    column :connect_title
    column :impact_title
    actions
  end

  show do
    attributes_table do
      row :hero_title
      row :hero_subtitle do |hp|
        hp.hero_subtitle&.body&.to_s&.html_safe
      end
      row :hero_image_url
      row :cta_1_text
      row :cta_1_url
      row :cta_2_text
      row :cta_2_url
      row :stat_1_label
      row :stat_1_value
      row :stat_2_label
      row :stat_2_value
      row :stat_3_label
      row :stat_3_value
      row :about_title
      row :about_body do |hp|
        hp.about_body&.body&.to_s&.html_safe
      end
      row :about_image_url
      row :about_button_text
      row :about_button_url
      row :support_title
      row :connect_title
      row :connect_description
      row :connect_cta_1_text
      row :connect_cta_1_url
      row :connect_cta_2_text
      row :connect_cta_2_url
      row :impact_title
    end

    panel "Focus Areas" do
      table_for resource.focus_areas do
        column :title
        column :description
      end
    end

    panel "Support Features" do
      table_for resource.support_features do
        column :title
        column :description
      end
    end

    panel "Stakeholder Blocks" do
      table_for resource.stakeholder_blocks do
        column :role
        column :title
        column :body
        column :cta_url
        column :cta_label
      end
    end

    panel "Testimonials" do
      table_for resource.testimonials do
        column :quote
        column :name
        column :title
        column :company
        column :image_url
        column :company_url
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Hero Section" do
      f.input :hero_title
      f.input :hero_subtitle, as: :action_text
      f.input :hero_image_url
      f.input :cta_1_text
      f.input :cta_1_url
      f.input :cta_2_text
      f.input :cta_2_url
    end

    f.inputs "Stats" do
      f.input :stat_1_label
      f.input :stat_1_value
      f.input :stat_2_label
      f.input :stat_2_value
      f.input :stat_3_label
      f.input :stat_3_value
    end

    f.inputs "About Section" do
      f.input :about_title
      f.input :about_body, as: :action_text
      f.input :about_image_url
      f.input :about_button_text
      f.input :about_button_url
    end

    f.inputs "Support Section" do
      f.input :support_title
    end

    f.has_many :support_features, allow_destroy: true, new_record: true do |sf|
      sf.input :title
      sf.input :description
    end

    f.inputs "Connect Section" do
      f.input :connect_title
      f.input :connect_description
      f.input :connect_cta_1_text
      f.input :connect_cta_1_url
      f.input :connect_cta_2_text
      f.input :connect_cta_2_url
    end

    f.inputs "Impact Section" do
      f.input :impact_title
    end

    f.has_many :focus_areas, allow_destroy: true, new_record: true do |fa|
      fa.input :title
      fa.input :description
    end

    f.has_many :testimonials, allow_destroy: true, new_record: true do |t|
      t.input :quote
      t.input :name
      t.input :title
      t.input :company
      t.input :image_url
      t.input :company_url
    end

    f.has_many :impact_logos, allow_destroy: true, new_record: true do |il|
      il.input :image_url
      il.input :alt_text
      il.input :link_url
    end

    f.has_many :stakeholder_blocks, allow_destroy: true, new_record: true do |sb|
      sb.input :role
      sb.input :title
      sb.input :body
      sb.input :cta_url
      sb.input :cta_label
    end

    f.actions
  end
  end
end
