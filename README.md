# Web Service for FogBugz Web Hooks to Move Cases to Areas by Email Content

## To Setup:

1. Configure the .env file  (example below) with:
- FOGBUGZ_URL: Your FogBugz URL using the [JSON API](http://help.fogcreek.com/10853/using-json-with-the-fogbugz-api) endpoint
- FOGBUGZ_TOKEN: the [API token](http://help.fogcreek.com/8447/how-to-get-a-fogbugz-xml-api-token) for FogBugz
- ixArea values for your FogBugz Areas

2. In the FogBugz Webhook configuration:
- Set the URL to https://relieved-porch.glitch.me/update?secret=your_secret
- Set the Hook Type to: POST
- Choose your event type as CaseOpened then set a Filter (e.g. ProjectName = "Webhook test" and AreaID = "1") value so you don't process unrelated web hooks.

## To Test

2. With curl set your 'casenumber' parameter below to an existing case number in your FogBugz account:
curl -H "Content-Type: application/json" -X POST -d '{"eventtype":"CaseOpened","casenumber":"693", "emailfrom": "something", "emailto": "something", "emailbodyhtml": "state: massachusetts", "emailbodytext": "state: massachusetts",}' http://relieved-porch.glitch.me/update?secret=your_secret

## .env file content

Copy and paste into a .env file and edit as needed:

```
# Environment Config

# store your secrets and config variables in here
# only invited collaborators will be able to see your .env values

# API Token. 
# Try something from http://randomkeygen.com/ under "CodeIgniter Encryption Keys"
SECRET=YOUR_SECRET_TOKEN
#Production
#Get your FOGBUGZ_TOKEN from FogBugz account > Avatar > Options
FOGBUGZ_TOKEN=PUT_TOKEN_HERE
FOGBUGZ_URL=https://YOUR_ACCOUNT.fogbugz.com/f/api/0/jsonapi

#EventType from FogBugz. Could be CaseAssigned or anything other webhook event type. 
#Go to Gear icon > Webhooks for more eventtypes or here: http://help.fogcreek.com/10800/webhooks
EVENT_TYPE=CaseOpened
# ixArea values
UNDECIDED=ixArea_value
EAST=ixArea_value
WEST=ixArea_value
# note: .env is a shell file so there can't be spaces around '=
```

