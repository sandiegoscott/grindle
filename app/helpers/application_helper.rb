# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Acl9Helpers

  access_control :show_settings? do
    allow :admin
    allow :inspector
  end

  def get_states
    @us_states = [
        ["TX"],
        ["AL"],
        ["AK"],
        ["AZ" ],
        ["AR" ],
        ["CA" ],
        ["CO" ],
        ["CT" ],
        ["DE" ],
        ["FL" ],
        ["GA" ],
        ["HI" ],
        ["ID" ],
        ["IL" ],
        ["IN" ],
        ["IA" ],
        ["KS" ],
        ["KY" ],
        ["LA" ],
        ["ME" ],
        ["MD" ],
        ["MA" ],
        ["MI" ],
        ["MN" ],
        ["MS" ],
        ["MO" ],
        ["MT" ],
        ["NE" ],
        ["NV" ],
        ["NH" ],
        ["NJ" ],
        ["NM" ],
        ["NY" ],
        ["NC" ],
        ["ND" ],
        ["OH" ],
        ["OK" ],
        ["OR" ],
        ["PA" ],
        ["RI" ],
        ["SC" ],
        ["SD" ],
        ["TN" ],
        ["UT" ],
        ["VT" ],
        ["VA" ],
        ["WA" ],
        ["WV" ],
        ["WI" ],
        ["WY" ]
      ]
  end

  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0)", :class => "remove_child")
  end

  def add_child_link(name, association)
    link_to(name, "javascript:void(0)", :class => "add_child", :"data-association" => association)
  end

  def new_child_fields_template(form_builder, association, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:form_builder_local] ||= :f

    content_tag(:div, :id => "#{association}_fields_template", :style => "display: none") do
      form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
        render(:partial => options[:partial], :locals => {options[:form_builder_local] => f})
      end
    end
  end
end

