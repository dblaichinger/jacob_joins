namespace :db do
  desc "Fill database with sample data (WARNING: DELETES ALL DOCUMENTS FIRST)"
  task :populate => :environment do
    
    Ingredient.delete_all
    Recipe.delete_all

    NUMBER_OF_INGREDIENTS = 1000
    NUMBER_OF_RECIPES = 100000

    require 'benchmark'
    include Benchmark

    puts("------------------------------------------------")
    startTime = Time.now
    Benchmark.benchmark(CAPTION, 7, nil, ">total:") do |x|
      ti = x.report("ingred.:"){ 
        @ingredients = []
        NUMBER_OF_INGREDIENTS.times do |counter|
          @ingredients << Ingredient.create(:name => "ingredient"+counter.to_s)
        end
      }

      tr = x.report("recipes:"){ 
        NUMBER_OF_RECIPES.times do |n|
          name  = "Testrecipe"+n.to_s
          portions = 4
          duration = 30
          city = "Salzburg"
          country = "Austria"
          latitude = 13.055363
          longitude = 47.811886

          chooseIngredients = []
          ingredient_ids = []
          (3+rand(12)).times do 
            i = @ingredients.sample
            chooseIngredients << IngredientWithQuantity.new(:name => i.name, :quantity => 2)
            ingredient_ids << i._id
          end

          steps = []
          (1+rand(4)).times do |counter|
            steps << Step.new(:description => "This is a description for step "+counter.to_s+" for recipe "+name)
          end
     
          r = Recipe.create(:name => name,
                        :portions => portions,
                        :duration => duration,
                        :city => city,
                        :country => country,
                        :latitude => latitude,
                        :longitude => longitude,
                        :ingredients_with_quantities => chooseIngredients,
                        :steps => steps,
                        :ingredient_ids => ingredient_ids)
          ingredient_ids.each do |id|
            recipe_arr = [r._id]
            Ingredient.find(id).recipe_ids << r._id
          end
        end
      }
      [ti+tr]
    end
    endTime = Time.now
    timeSpent = endTime - startTime
    puts("------------------------------------------------")
    puts("Measurement with Time.now: "+timeSpent.to_s+" sec.")
    puts("------------------------------------------------")
    puts("Number of saved Ingredients: "+ NUMBER_OF_INGREDIENTS.to_s)
    puts("Number of saved Recipes: "+ NUMBER_OF_RECIPES.to_s)   
  end
end
