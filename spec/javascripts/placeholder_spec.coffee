describe "placeHolder", ->
  beforeEach ->
    loadFixtures "placeHolder.html"
    $("#wrapper").appendTo "body"

    $("input[placeholder]").placeholder()

  afterEach ->
    $("#wrapper").remove()

  describe "Input element", ->
    it "should have the plugin-assigned placeholders", ->
      expect($("#first_name").prop("placeholder") is "Chuck").toBeTruthy()
      expect($("#last_name").prop("placeholder") is "Testa").toBeTruthy()