Helper = require 'hubot-test-helper'
Logger = require('bucker').createLogger {name: "hubot-yalo-brain"}
Promise = global.Promise
helper = new Helper('../src/hubot-yalo-brain.coffee')

describe 'Test Yalo Brain', ->
  @timeout 5000

  before  (done) ->
    @room = helper.createRoom()
    setTimeout ->
      Logger.info "Brain is prepared!"
      done()
    , 2000

  it 'Set on Brain', (done) ->
    Logger.info 'I want to save: key = alex, data = {key1: "value1"}'
    setPromise = @room.robot.brain.set 'alex', {key1: 'value1'}
    setPromise.then (data) ->
      Logger.info data
    done()
    
  it 'Get saved data', (done) ->
    Logger.info 'I want to get data of: key = alex'
    getPromise = @room.robot.brain.get 'alex'
    getPromise.then (data) ->
      Logger.info data
    done()

  it 'Get inexistent data', (done) ->
    Logger.info 'I want to get data of: key = no-key'
    getPromise = @room.robot.brain.get 'no-key'
    getPromise.catch (data) ->
      Logger.info data
        
    done()
  
  it 'Set on existent register', (done) ->
    Logger.info 'I want to save: key = alex, data = {key2: "value2"}'
    setPromise = @room.robot.brain.set 'alex', {key2: 'value2'}
    setPromise.then (data) ->
      Logger.info data
    done()

  it 'Get updated data', (done) ->
    Logger.info 'I want to get data of: key = alex'
    getPromise = @room.robot.brain.get 'alex'
    getPromise.then (data) ->
      Logger.info data
    done()
      
