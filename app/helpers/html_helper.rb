module HtmlHelper
  # crea un enlace dentro de un <LI>, si la ruta del enlace es el actual URL entonces le agrega la clase 'active' al <LI>
  def nav_link(link_text, link_path)
    # based on https://stackoverflow.com/a/7756320
    class_name = current_page?(link_path) ? 'active' : nil

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end
     
  # genera el icono y las listas de enlaces, tanto para el menu de escritorio como el de escritorio, que en mobilize son distintas
  # utiliza el helper nav_link
  def nav_mobile_menu(items)
    nav_mobile = link_to raw('<i class="material-icons">menu</i>'), "#", data: {activates: "mobile-nav"}, class: "button-collapse"
    nav_mobile += content_tag :ul, class: "right hide-on-med-and-down" do
      items.collect {
        |item| 
        concat( nav_link( item[:text], item[:path]) ) 
       }
    end
    nav_mobile += content_tag :ul, class: "side-nav", id: 'mobile-nav' do
      items.collect {
        |item| 
        concat( nav_link( item[:text], item[:path]) ) 
       }
    end    
  end
end
