#= require spec_helper

describe 'ejs templates', ->
  it "loads templates", ->
    ($ 'body').html JST['templates/hello'](name: 'Meppit')
    ($ 'body h1').text().should.equal 'Hello Meppit js tests!'
