#= require spec_helper

describe 'sample', ->
  it 'truth', ->
    expect(true).to.equal(true)

  it 'defines jquery', ->
    expect(jQuery).to.not.be.undefined
