describe "dirtyValidation", ->
  beforeEach ->
    loadFixtures "dirtyValidation.html"
    $("form").appendTo "body"
    $("form").dirtyValidation()

  afterEach ->
    $("form").dirtyValidation "destroy"
    $("form").remove()

  describe "Form", ->
    it "should have class dirtyform", ->
      expect($ "form").toHaveClass "dirtyform"

    it "should mark all required fields if any field was filled in", ->
      $("#user_lastname").val "Derpington"
      $("#user_lastname").blur()

      expect($(".error:input", "form").size() is 4).toBeTruthy()

      $("label.error", "form").each ->
        expect($ this).toHaveText "This field is required."

    it "should not mark prefilled required fields if any field was filled in", ->
      $("#user_firstname").val "Derp"
      $("#user_lastname").val "Derpington"
      $("#user_lastname").blur()

      marked_required_fields = $(".error:input", "form").filter ->
        return $(this).val().length is 0 or $(this).val() is " "
      .size()

      expect(marked_required_fields is 3).toBeTruthy()

  describe "Optional input field without data type", ->
    beforeEach ->
      $("#user_lastname").val "Derpington"
      $("#user_lastname").blur()

    it "should have class changed", ->
      expect($ "#user_lastname").toHaveClass "changed"

    it "should not have class error", ->
      expect($ "#user_lastname").not.toHaveClass "error"

    it "should not have error label", ->
      expect($("#user_lastname").next()).not.toBe "label.error"

    describe "and resetted value", ->
      beforeEach ->
        $("#user_lastname").val ""
        $("#user_lastname").blur()

      it "should have class changed", ->
        expect($ "#user_lastname").toHaveClass "changed"

      it "should not have class error", ->
        expect($ "#user_lastname").not.toHaveClass "error"

      it "should not have error label", ->
        expect($("#user_lastname").next()).not.toBe "label.error"

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
        expect($("#user_email").next()).toBe "label.error"
        expect($("#user_email").next()).toHaveText "It has to be a valid email address."

    describe "numerical", ->
      it "should accept a number", ->
        $("#number").val "69"
        $("#number").blur()

        expect($ "#number").not.toHaveClass "error"
        expect($("#number").next()).not.toBe "label.error"

      it "should be marked as invalid", ->
        $("#number").val "sixty nine (iykwim)"
        $("#number").blur()

        expect($ "#number").toHaveClass "error"
        expect($("#number").next()).toBe "label.error"
        expect($("#number").next()).toHaveText "It has to be a number."
      
  describe "Required input field without data type", ->
    it "should accept any input", ->
      $("#user_firstname").val "the cake is a lie!"
      $("#user_firstname").blur()

      expect($ "#user_firstname").not.toHaveClass "error"
      expect($("#user_firstname").next()).not.toBe "label.error"

    it "should be marked as invalid if it was resetted", ->
      $("#user_firstname").val "the cake is a lie!"
      $("#user_firstname").blur()
      $("#user_firstname").val ""
      $("#user_firstname").blur()

      expect($ "#user_firstname").toHaveClass "error"
      expect($("#user_firstname").next()).toBe "label.error"
      expect($("#user_firstname").next()).toHaveText "This field is required."

  describe "Required input field with data type", ->
    it "should accept a value of valid type", ->
      $("#age").val "69"
      $("#age").blur()

      expect($ "#age").not.toHaveClass "error"
      expect($("#age").next()).not.toBe "label.error"

    it "should be marked as invalid if the types doesn't match", ->
      $("#age").val "sixty nine (iykwim)"
      $("#age").blur()

      expect($ "#age").toHaveClass "error"
      expect($("#age").next()).toBe "label.error"
      expect($("#age").next()).toHaveText "It has to be a number."

    it "should be marked as required if it was resetted", ->
      $("#age").val "the cake is a lie!"
      $("#age").blur()
      $("#age").val ""
      $("#age").blur()

      expect($ "#age").toHaveClass "error"
      expect($("#age").next()).toBe "label.error"
      expect($("#age").next()).toHaveText "This field is required."