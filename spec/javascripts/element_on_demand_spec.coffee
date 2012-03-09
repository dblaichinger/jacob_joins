describe "elementOnDemand", ->
  beforeEach ->
    # loadFixtures('elementOnDemand.html');
    $("<div id='dynamicContainer'><p class='dynamicElement'><input name='recipe[ingredients_strings][][quantity]' type='text' /><input id='ingredient' name='recipe[ingredients_strings][][ingredient]' type='text' /></p></div>").appendTo "body"

    this.event = $.Event "keydown"
    this.event.which = 9

  afterEach ->
    $("#dynamicContainer").elementOnDemand "destroy"
    $("#dynamicContainer").remove()

  describe "NewElement", ->
    beforeEach ->
      this.container = $("#dynamicContainer")
      this.container.elementOnDemand()

    it "should be added if tab was pressed", ->
      $("#ingredient").trigger this.event
      expect(this.container.children(".dynamicElement").size() is 2).toBeTruthy()

    it "should be added if the button was clicked", ->
      $("#add").trigger "click"
      expect(this.container.children(".dynamicElement").size() is 2).toBeTruthy

  describe "Options", ->
    it "should not bind the keydown event", ->
      container = $("#dynamicContainer")
      container.elementOnDemand
        onKeyDown: false

      $("#ingredient").trigger this.event
      expect(container.children(".dynamicElement").size() is 1).toBeTruthy()

  describe "ElementAttribute", ->
    beforeEach ->
      $("#dynamicContainer").elementOnDemand()
      $("#add").trigger "click"

    it "should change the ids of the children", ->
      expect($("input[id]").last().prop "id" is "ingredient_2").toBeTruthy
      expect($("input[id]").size() is 2).toBeTruthy
      expect($(".dynamicElement > input:first-child").last().prop "id" is "").toBeTruthy