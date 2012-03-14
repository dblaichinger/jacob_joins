describe "placeHolder", ->
  beforeEach ->
    loadFixtures "placeHolder.html"
    $("#wrapper").appendTo "body"

    $("#first_name").placeHolder
    	text: "Chuck"

    $("#last_name").placeHolder
      text: "Testa"

  afterEach ->
    $("#wrapper").remove()

  describe "Input element", ->
    it "should have the plugin-assigned placeholders", ->
      expect($("#first_name").val() is "Chuck").toBeTruthy()
      expect($("#last_name").val() is "Testa").toBeTruthy()

    it "should remove placeholder if it gets the focus", ->
      $("#first_name").focus()
      expect($("#first_name").val() is "").toBeTruthy()

    it "should have placeholder if it loses the focus", ->
      $("#first_name").focus()
      $("#last_name").focus()
      expect($("#first_name").val() is "Chuck").toBeTruthy()
      expect($("#last_name").val() is "").toBeTruthy()