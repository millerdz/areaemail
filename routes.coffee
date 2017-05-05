fogbugz = require('./fogbugz')

module.exports = (app) ->
  
  app.get '/', (req, res) ->
    console.log 'Received GET'
    return res.send 'Oh, hi! There\'s not much to see here, you\'re better off checking out <a href=\'https://glitch.com/#!/project/relieved-porch\'>https://glitch.com/#!/project/relieved-porch</a> for how to use this.'
    
  app.post '/update', (req, res) ->
    if !req.body.eventtype
      console.log 'Received incomplete POST: ' + JSON.stringify(req.body)
      return res.send(
        'status': 'error'
        'message': 'missing \'eventtype\' in body')
    else if req.body.eventtype == process.env.EVENT_TYPE
      if req.query.secret is process.env.SECRET
        if req.body.emailfrom && req.body.emailto
          console.log 'Received body CaseOpened event: ' + JSON.stringify(req.body)
          console.log 'Received query CaseOpened event: ' + JSON.stringify(req.query)

          ixbug = req.body.casenumber
          ixArea = process.env.UNDECIDED
          return_msg = ''

          if 'state: massachusetts' in req.body.emailbodytext or 'state: massachusetts' in req.body.emailbodyhtml
            ixArea = process.env.EAST
            console.log "assigning to area: #{ixArea}"
            fogbugz.update(ixbug, ixArea).then (response) ->
              console.log 'fogbugz response: ', response
              fogbugz.sendSuccess res, "Moved to area #{ixArea}"
          else if 'state: colorado' in req.body.emailbodytext or 'state: colorado' in req.body.emailbodyhtml
            ixArea = process.env.WEST
            console.log "assigning to area: #{ixArea}"
            fogbugz.update(ixbug, ixArea).then (response) ->
              console.log 'fogbugz response: ', response
              fogbugz.sendSuccess res, "Moved to area #{ixArea}"
        
        else
          res.status 200
          res.send 'Missing emailfrom and emailto.'
      else
        res.status 401
        res.send 'Secret does not match.'
    else
      res.status 400
      res.send 'eventtype is not #{process.env.EVENT_TYPE}'
