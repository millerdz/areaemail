fogbugz = require('./fogbugz')

module.exports = (app) ->
  
  app.get '/', (req, res) ->
    console.log 'Received GET'
    return res.send 'Oh, hi! There\'s not much to see here, you\'re better off checking out <a href=\'https://glitch.com/#!/project/relieved-porch\'>https://glitch.com/#!/project/relieved-porch</a> for how to use this.'
    
  app.post '/update', (req, res) ->
    #console.log JSON.stringify(req.body)
    ixbug = 'not found'
    if req.body.casenumber
      ixbug = req.body.casenumber
      console.log 'case=' + ixbug, 'processing...'
    else
      res.status 400
      return res.send(
        'status': 'error'
        'message': 'missing \'casenumber\' in body')
    
    #console.log req.body.eventtype
    if !req.body.eventtype
      console.log 'Received incomplete POST: ' + JSON.stringify(req.body)
      res.status 400
      return res.send(
        'status': 'error'
        'message': 'missing \'eventtype\' in body')
    else if req.body.eventtype is process.env.EVENT_TYPE
      console.log 'case=' + ixbug, 'EventType matched.'
      if req.query.secret is process.env.SECRET
        console.log 'case=' + ixbug, 'Secret matched.'
        if req.body.emailfrom && req.body.emailto
          console.log 'case=' + ixbug, 'EmailFrom and EmailTo exist'
          #console.log 'Received body CaseOpened event: ' + JSON.stringify(req.body)
          #console.log 'Received query CaseOpened event: ' + JSON.stringify(req.query)
          
          ixArea = process.env.UNDECIDED
          #emailbodytext = JSON.stringify(req.body.emailbodytext)
          #emailbodyhtml
          emailbody = (JSON.stringify(req.body.emailbodytext).toLowerCase() + JSON.stringify(req.body.emailbodyhtml).toLowerCase()).toString()
          #console.log "Email body " + emailbody
          match = emailbody.indexOf "state: massachusetts", 0 
          match_co = emailbody.indexOf "state: colorado", 0 
          
          if match >= 0
            c#onsole.log "match Mass"
            #console.log 'emailbody index ' + emailbody.indexOf "state: massachusetts", 0
            ixArea = process.env.EAST
            console.log 'case=' + ixbug, 'moving to area:', ixArea
            fogbugz.update(ixbug, ixArea).then (response) ->
              #console.log 'fogbugz response: ', response
              fogbugz.sendSuccess res, 'case=' + ixbug + ': Moved to area: ' + ixArea
          else if match_co >= 0
            #console.log 'match colorado'
            #console.log 'emailbody index ' + emailbody.indexOf "state: colorado", 0
            ixArea = process.env.WEST
            console.log 'case=' + ixbug, 'moving to area:', ixArea
            fogbugz.update(ixbug, ixArea).then (response) ->
              #console.log 'fogbugz response: ', response
              fogbugz.sendSuccess res, 'case=' + ixbug + ': Moved to area: ' + ixArea
          else
            console.log 'case=' + ixbug, 'Error 400: \'state: value\' has no match in email. check the .env configuration'
            res.status 400
            res.send 'case=' + ixbug + ': \'state: VALUE\' has no match in email. check the .env configuration.'
        else
          console.log 'case=' + ixbug, 'Error 400: Missing emailfrom and/or emailto.'
          res.status 400
          res.send 'case=' + ixbug + ': Missing emailfrom and/or emailto.'
      else
        console.log 'case=' + ixbug, 'Error 400: Secret does not match'
        res.status 400
        res.send 'case=' + ixbug + ': Secret does not match.'
    else
      console.log 'case=' + ixbug, 'Error 400: eventtype doesn\'t match'
      res.status 400
      res.send 'case=' + ixbug + ': eventtype is not ' + process.env.EVENT_TYPE
