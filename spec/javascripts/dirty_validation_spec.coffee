describe "dirtyValidation", ->
  beforeEach ->
    loadFixtures "dirtyValidation.html"
    $("form").appendTo "body"
    $("form").dirtyValidation
      monitorEvent: "blur"

  afterEach ->
    $("form").dirtyValidation "destroy"
    $("form").remove()

  describe "Form", ->
    it "should have class dirtyform", ->
      expect($ "form").toHaveClass "dirtyform"

    it "should trigger event after validation", ->
      spyOnEvent $("form"), "validated.dirtyValidation"
      $("form").dirtyValidation "validate", $(":input", "form").first()
      expect("validated.dirtyValidation").toHaveBeenTriggeredOn $("form")

  describe "Optional input field without data type", ->
    beforeEach ->
      $("#user_lastname").val "Derpington"
      $("#user_lastname").blur()

    it "should have class changed", ->
      expect($ "#user_lastname").toHaveClass "changed"

    it "should not have class error", ->
      expect($ "#user_lastname").not.toHaveClass "error"

    it "should not have tooltip", ->
      expect($ ".ui-tooltip").not.toExist()

    describe "and resetted value", ->
      beforeEach ->
        $("#user_lastname").val ""
        $("#user_lastname").blur()

      it "should have class changed", ->
        expect($ "#user_lastname").toHaveClass "changed"

      it "should not have class error", ->
        expect($ "#user_lastname").not.toHaveClass "error"

    it "should not have tooltip", ->
      expect($ ".ui-tooltip").not.toExist()

  describe "Optional input field with data type", ->
    describe "email", ->
      it "should accept email address", ->
        $("#user_email").val "derp.herpington@jacobjoins.com"
        $("#user_email").blur()

        expect($ "#user_email").not.toHaveClass "error"
        expect($("#user_email").next()).not.toBe "label.error"

      it "should be marked as invalid", ->
        $("#user_email").val "derp.herpington@jacobjoins.42"
        $("#user_email").blur()

        expect($ "#user_email").toHaveClass "error"

    describe "numerical", ->
      it "should accept a number", ->
        $("#number").val "69"
        $("#number").blur()

        expect($ "#number").not.toHaveClass "error"

      it "should be marked as invalid", ->
        $("#number").val "sixty nine (iykwim)"
        $("#number").blur()

        expect($ "#number").toHaveClass "error"
      
  describe "Required input field without data type", ->
    beforeEach ->
      $("#user_firstname").val "the cake is a lie!"
      $("#user_firstname").blur()
    
    it "should accept any input", ->
      expect($ "#user_firstname").not.toHaveClass "error"

    it "should be marked as invalid if it was resetted", ->
      $("#user_firstname").val ""
      $("#user_firstname").blur()

      expect($ "#user_firstname").toHaveClass "error"

  describe "Required input field with data type", ->
    it "should accept a value of valid type", ->
      $("#age").val "69"
      $("#age").blur()

      expect($ "#age").not.toHaveClass "error"

    it "should be marked as invalid if the types doesn't match", ->
      $("#age").val "sixty nine (iykwim)"
      $("#age").blur()

      expect($ "#age").toHaveClass "error"

    it "should be marked as required if it was resetted", ->
      $("#age").val "the cake is a lie!"
      $("#age").blur()
      $("#age").val ""
      $("#age").blur()

      expect($ "#age").toHaveClass "error"