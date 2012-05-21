SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :home, 'Home', root_path
    primary.item :form, 'Upload', "#{page_path("form")}#skipstory"
  end
end
