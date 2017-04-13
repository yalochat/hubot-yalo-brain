# Description:
#   hubot-yalo-brain
#   Integrate MongoDB to persist data through mongoose.
#   Overwrite set and get methods. Now these return a Promise
#   instead of a value to handle async work.
#
# Dependencies:
#   "mongoose": "^4.0.0"
#
# Configuration:
#   MONGODB_URL
#
# Author:
#   Yalochat <eng@yalochat.com>

'use strict'
{EventEmitter} = require 'events'
mongoose = require 'mongoose'
Promise = global.Promise

class YaloBrain extends EventEmitter
  constructor: (robot) ->
  #Our own Brain, ignoring all methods on Hubot Brain.

module.exports = (robot) ->
  mongoUrl =  process.env.MONGODB_URL or
                'mongodb://localhost/hubot-yalo-brain'
  mongoose.connect mongoUrl
  mongoose.Promise = Promise

  mongoose.connection.on 'error', (error) ->
    throw error if error

  mongoose.connection.on 'open', ->
    robot.brain = new YaloBrain
    userDataSchema = mongoose.Schema
      key: String
      data: mongoose.Schema.Types.Mixed
        
    UserDataSchema = mongoose.model 'UserData', userDataSchema

    robot.brain.get = (key) ->
      return new Promise (resolve, reject)->
        UserDataSchema.findOne {key}, (error, result)->
          reject error if error
          reject 'not-found' if not result
          resolve result.data if result
                
    robot.brain.set = (key, data) ->
      return new Promise (resolve, reject)->
        UserDataSchema.findOne {key}, (error, userData)->
          userData = new UserDataSchema {key} if not userData
          userData.data =  data

          savePromise = userData.save()
          savePromise.then (result) ->
            resolve result
              
          savePromise.catch (reason) ->
            reject reason
            