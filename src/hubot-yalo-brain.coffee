'use strict'

mongoose = require 'mongoose'

module.exports = (robot) ->
    mongoUrl =  process.env.MONGODB_URL or
                'mongodb://localhost/hubot-yalo-brain'
    mongoose.connect mongoUrl
    mongoose.Promise = global.Promise

    robot.hear /Hi (.*)/i, (response) ->
        robot.brain.set 'testkey', response.match[1], (error, result) ->
            console.log result

        robot.brain.get 'testkey', (error, result) ->
            console.log result


    mongoose.connection.on 'open', ->        
        userDataSchema = mongoose.Schema
            key: String
            data: mongoose.Schema.Types.Mixed
        
        UserDataSchema = mongoose.model 'UserData', userDataSchema

        robot.brain.get = (key, reply) ->
            UserDataSchema.findOne {key}, (error, result)->
                if reply
                    reply error, result
                
        robot.brain.set = (key, data, reply) ->
            robot.brain.get key, (error, userData) ->
                if not userData
                    userData = new UserDataSchema {key}
                userData.data =  data

                savePromise = userData.save()
                savePromise.then (result) ->
                    if reply
                        reply null, result