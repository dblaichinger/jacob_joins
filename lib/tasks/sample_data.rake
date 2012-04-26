namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    
    NUMBER_OF_INGREDIENTS = 10
    NUMBER_OF_RECIPES = 10

    # Create test ingredients
    ingredients = []
    NUMBER_OF_INGREDIENTS.times do |counter|
      ingredients << "ingrendient"+counter.to_s
    end

    # Get current time
    startTime = Time.now
    puts("------------------------------------------------")
    require 'benchmark'
    Benchmark.bm do |bench|
      bench.report{ 
        # Create new ingredients_with_quantities, which is the embedded object of Recipe
        ingredients_with_quantities = []
        #Rake::Task['db:reset'].invoke
        ingredients.each do |i|
          ingredients_with_quantities << IngredientWithQuantity.new(:name => i, :quantity => (1+rand(9)))
          Ingredient.create(:name => i) if Ingredient.where(:name => i).count == 0
        end

        #Create new steps, which is also embedded in Recipe
        steps = []
        5.times do |counter|
          steps << Step.new(:description => "This is a description for step "+counter.to_s)
        end

        NUMBER_OF_RECIPES.times do |n|
          name  = "Testrecipe"+n.to_s
          portions = 1 + rand(5)
          duration = 10 + rand(50)
          city = "Salzburg"
          country = "Austria"
          latitude = 13.6
          longitude = 47.0

          chooseIngredients = []
          (1+rand(NUMBER_OF_INGREDIENTS)).times do 
            chooseIngredients << ingredients_with_quantities[rand(ingredients.length)]
          end

          chooseSteps = []
          (1+rand(4)).times do |counter|
            chooseSteps << steps[counter]
          end

          Recipe.create!(:name => name,
                        :portions => portions,
                        :duration => duration,
                        :city => city,
                        :country => country,
                        :latitude => latitude,
                        :longitude => longitude,
                        :ingredients_with_quantities => chooseIngredients,
                        :steps => chooseSteps)
        end
      }
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
end

