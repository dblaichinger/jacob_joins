SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary| 
    primary.item :home, 'Home', root_path, class:""
    primary.item :story, 'Who is Jacob?', page_path("form")
    primary.item :about, 'About us', page_path("about_us")
    primary.item :form, 'Upload recipe', "#{page_path("form")}#skipstory"
    primary.item :search, 'Search', page_path("search")
    primary.item :contact, 'Contact', page_path("contact")


  end
end
