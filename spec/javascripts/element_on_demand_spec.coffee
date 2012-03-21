describe "elementOnDemand", ->
  beforeEach ->
    loadFixtures "elementOnDemand.html"
    $("#dynamicContainer").appendTo "body"

    this.event = $.Event "keydown"
    this.event.which = 9

  afterEach ->
    $("#dynamicContainer").elementOnDemand "destroy"
    $("#dynamicContainer").remove()

  describe "Element", ->
    beforeEach ->
      this.container = $("#dynamicContainer")
      this.container.elementOnDemand()

    it "should be added if tab was pressed", ->
      $("#ingredient").trigger this.event
      expect(this.container.children(".dynamicElement").size() is 2).toBeTruthy()

    describe "Button", ->
      beforeEach ->
        $("#add").trigger "click"

      it "should add element", ->
        expect(this.container.children(".dynamicElement").size() is 2).toBeTruthy

      it "should change the ids of new children", ->
        expect($("input[id]").last().prop "id" is "ingredient_2").toBeTruthy
        expect($("input[id]").size() is 2).toBeTruthy
        expect($(".dynamicElement > input:first-child").last().prop "id" is "").toBeTruthy

      it "should change the name attribute of new children", ->
        expect($("input[name]").last().prop "name" is "recipe[ingredients_with_quantities_attributes][1][name]").toBeTruthy

      it "should remove last element", ->
        $("#remove").trigger "click"
        expect(this.container.children(".dynamicElement").size() is 1).toBeTruthy

      it "should not remove the last remaining element", ->
        $("#remove").trigger "click"
        $("#remove").trigger "click"
        expect(this.container.children(".dynamicElement").size() is 1).toBeTruthy

  describe "Options", ->
    it "should not bind the keydown event", ->
      container = $("#dynamicContainer")
      container.elementOnDemand
        onKeyDown: false

      $("#ingredient").trigger this.event
      expect(container.children(".dynamicElement").size() is 1).toBeTruthy()