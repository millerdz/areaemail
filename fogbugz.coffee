request = require 'request'
FOGBUGZ_TOKEN = process.env.FOGBUGZ_TOKEN

module.exports =

  update: (ixbug, area) ->
    console.log 'fogbugz::update'
    return new Promise (resolve, reject) ->
      request
        method: 'POST'
        url: process.env.FOGBUGZ_URL
        body: JSON.stringify
          token: FOGBUGZ_TOKEN
          cmd: "edit"
          ixbug: ixbug
          ixArea: area
        (error, response, responseBody) ->
          console.log responseBody
          responseJson = JSON.parse responseBody
          if error
            reject Error 'case update failed'
          else
            console.log 'case updated', responseJson
            resolve responseJson
            
  sendSuccess: (res, msg) ->
    console.log '🌺 sendSuccess'
    #res.json( 'msg': msg )
    res.status 200
    res.send msg