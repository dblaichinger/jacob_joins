class IngredientsController < ApplicationController
  require 'benchmark'
  include Benchmark
  #respond_to :html, :json

  def names
    render :json => Ingredient.names_with(params[:term]).to_json
  end

  def search

    respond_to do |format|
      format.json {
        #puts params.inspect
        # Store ingredients which 
        @ingredients = params[:ingredients]
        #raise params[:ingredients].inspect
        @recipes = []
        #startTime = Time.now
        #puts("------------------------------------------------")
        Benchmark.benchmark(CAPTION, 7, nil, ">total:") do |x|
          
          @ingredients.each do |key, value|
            #Get all recipes which includes the ingredient
            @tq = x.report("Query:"){
              @query = Recipe.search_by_ingredient(value)
            }
            @tm = x.report("Recipe_match:"){
              if @recipes.empty?
                @recipes = @query.entries
              else
                @query.entries.each do |entry|
                  #If the same recipe was found, insert to the recipe an counter or increase counter
                  if @recipes.include?(entry)
                    #binding.pry
                    index = @recipes.index(entry)
                    if @recipes[index]["count"].nil?
                      @recipes[index]["count"] = 2
                    else
                      @recipes[index]["count"] += 1
                    end
                  # Else put the recipe as a new entry in the recipe array
                  else
                    @recipes << entry
                  end
                end              
              end
            }
          end
          @ts = x.report("Recipe_sort:"){
          #puts(@recipes.length)
          @recipe_match = []
          @recipes.each do |recipe|
            #Get all recipes which have a count attribute
            @recipe_match << recipe if recipe["count"] != nil
          end

          #Sort the array regarding the count number
          @recipe_match.sort! {|a,b| b["count"] <=> a["count"]}
          
          # If recipe_match contains less than 10 recipes, get some recipes without any count
          counter = 0
          while @recipe_match.length < 10
            @recipe_match << @recipes[counter]
            counter+=1
          end
          }
        [@tq+@tm+@ts]
        end

        #endTime = Time.now
        #timeSpent = endTime - startTime
        # Print the difference in time
        #puts("------------------------------------------------")
        #puts("Measurement with Time.now: "+timeSpent.to_s+" sec.")
        #puts("------------------------------------------------")

        #OLD VERSION, CAN BE DELETED AFTER I DID THE DOCU FOR BAKK

        # @ingredients = []
        # params[:ingredients].each do |key, value|
        #   query = Ingredient.search_by_name(value)
        #   @ingredients << query.entries
        # end
        # @ingredients = @ingredients.flatten

        #binding.pry

        #Compare recipe_ids with each other
        # raise "bla"
        # if @ingredients.length > 1
        #   @recipe_match = []
        #   counter = 0
        #   #Loop through every ingredient and get the recipe_ids
        #   @ingredients.each do |ingredient|
        #     ingredient.recipe_ids.each do |id|
              
        #       #Loop through all other recipes and compare
        #       compare_counter = counter+1
        #       @ingredients[compare_counter].recipe_ids.each do |compare_id|
        #         if id == compare_id
        #           @recipe_match << id
        #           raise @recipe_match.inspect
        #         end
        #       end
        #     end
        #     counter+=1
        #   end
        # end

        # @recipes = []
        # @ingredients.each do |ingredient|
        #   @recipes << Recipe.find(ingredient.recipe_ids[0])
        # end


        render :json => {:ingredients => @ingredients, :recipes => @recipe_match.take(10)}
      }
      format.html
    end
  end
end
