# Web Service for FogBugz Web Hooks to Move Cases to Areas by Email Content

## To Setup:

1. Configure the .env file with:
- FOGBUGZ_URL: Your FogBugz URL using the [JSON API](http://help.fogcreek.com/10853/using-json-with-the-fogbugz-api) endpoint
- FOGBUGZ_TOKEN: the [API token](http://help.fogcreek.com/8447/how-to-get-a-fogbugz-xml-api-token) for FogBugz
- And more. See .env for variables.

2. In the FogBugz Webhook configuration:
- Set the URL to https://curse-shaker.glitch.me/update?secret=your_secret
- Set the Hook Type to: POST
- Choose your event type as CaseAssigned then set a Filter (e.g. ProjectName = "Webhook test" AssignedToID="45") value so you don't process unrelated web hooks.

## To Test

2. With curl set your 'casenumber' parameter below to an existing case number in your FogBugz account:
curl -H "Content-Type: application/json" -X POST -d '{"eventtype":"CaseEdited","casenumber":"693", "assignedtoid":"45"}' http://curse-shaker.glitch.me/update?secret=your_secret


