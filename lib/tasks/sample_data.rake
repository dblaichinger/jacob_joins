namespace :db do
  desc "Fill database with sample data (WARNING: DELETES ALL DOCUMENTS FIRST)"
  task :populate => :environment do
    
    Ingredient.delete_all
    Recipe.delete_all

    NUMBER_OF_INGREDIENTS = 10
    NUMBER_OF_RECIPES = 100

    startTime = Time.now
    puts("------------------------------------------------")
    require 'benchmark'
    Benchmark.bm do |bench|
      bench.report("Create ingredients:"){ 
        @ingredients = []
        NUMBER_OF_INGREDIENTS.times do |counter|
          @ingredients << Ingredient.create(:name => "ingredient"+counter.to_s)
        end
      }

      bench.report("Create recipes:"){ 
        NUMBER_OF_RECIPES.times do |n|
          name  = "Testrecipe"+n.to_s
          portions = 1 + rand(5)
          duration = 10 + rand(50)
          city = "Salzburg"
          country = "Austria"
          latitude = 13.6
          longitude = 47.0

          chooseIngredients = []
          (3+rand(12)).times do 
            i = @ingredients[rand(@ingredients.length)]
            chooseIngredients << IngredientWithQuantity.new(:name => i.name, :quantity => (1+rand(9)))
          end

          steps = []
          (1+rand(4)).times do |counter|
            steps << Step.new(:description => "This is a description for step "+counter.to_s+" for recipe "+name)
          end

          Recipe.create!(:name => name,
                        :portions => portions,
                        :duration => duration,
                        :city => city,
                        :country => country,
                        :latitude => latitude,
                        :longitude => longitude,
                        :ingredients_with_quantities => chooseIngredients,
                        :steps => steps)
        end
      }
    end
    # Get current time
    endTime = Time.now
    timeSpent = endTime - startTime
    # Print the difference in time
    puts("------------------------------------------------")
    puts("Measurement with Time.now: "+timeSpent.to_s+" sec.")
    puts("------------------------------------------------")
    puts("Number of saved Ingredients: "+ NUMBER_OF_INGREDIENTS.to_s)
    puts("Number of saved Recipes: "+ NUMBER_OF_RECIPES.to_s)
  end
end

