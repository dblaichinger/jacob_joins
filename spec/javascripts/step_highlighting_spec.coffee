describe "stepHighlighting", ->
  beforeEach ->
    loadFixtures "stepHighlighting.html"
    $("form").appendTo "body"
    $("form").stepHighlighting()

    this.event = $.Event "click"

  afterEach ->
    $("form").stepHighlighting "destroy"
    $("#dynamicContainer").remove()

  describe "Step", ->
    beforeEach ->
      $(".part-1").trigger this.event

    it "should be active if step was clicked", ->
      expect($ ".part-1").toHaveClass "active"

    it "should mark next step if it was clicked", ->
      expect($ ".part-2").toHaveClass "next"

    it "should mark next step if last step was clicked", ->
      $(".part-3").trigger this.event
      expect($(".next").size() is 0).toBeTruthy()

    it "should toggle classes if other step was clicked", ->
      $(".part-2").trigger this.event
      expect($(".part-1.active").size() is 0).toBeTruthy()
      expect($(".part-2.next").size() is 0).toBeTruthy()
      expect($ ".part-2").toHaveClass "active"
      expect($ ".part-3").toHaveClass "next"
