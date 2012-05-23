SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :home, 'Home', root_path, class:""
    primary.item :form, 'Upload', "#{page_path("form")}#skipstory"
    primary.item :about, 'About us', page_path("about_us")
  end
end
