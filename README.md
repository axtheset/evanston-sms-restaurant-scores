A demo application to demonstrate the capabilities of the CivicData.com API.  This application enables a user to text the name of a restaurant in Evanston, IL and receive a reply with the most recent health score.

To test this application live text a restaurant name in Evanston, IL to (847) 892-4858.

Evanston, IL has published their restaurant inspection data in accordance with the [Local Inspector Value-Entry Specification (LIVES)](http://www.yelp.com/healthscores).  For any city that publishes their restaurant inspection data to [CivicData.com](http://civicdata.com) this app can be deployed by simply changing the businesses_resource_id and inspections_resource_id to reflect their resources.

The source of the data for this app is located here: [Evanston, IL - LIVES](http://www.civicdata.com/en/organization/evanston-9adef673-0141).

### Built with

* [Sinatra](http://www.sinatrarb.com/) has taken the stage...
* [Twilio](https://www.twilio.com/), it just doesn't get any easier for SMS.
* [HTTParty](https://github.com/jnunemaker/httparty) makes http fun again!
* [CivicData.com](http://www.civicdata.com/en/home) API.