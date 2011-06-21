This gem provides an easy way to access the hashblue API (https://api.hashblue.com) from ruby programs.  Currently the gem is limited to reading data from the API, but it is intended to add all API features shortly.  It also doesn't handle pagination, instead only returning the first 50 results.  This too should be rectified soon.

### Getting started

Using this gem is very straightforward.  First, you need to obtain an OAuth2 access token (see https://api.hashblue.com/doc/Authentication).  Then, create a new client:

    client = Hashblue::Client.new('oauth2-access-token')

Finally, use that client to start to navigate the API:

    contacts = client.account.contacts
    first_contact_messages = contacts.first.messages

You can also pass in query parameters to restrict the results:

    messages_abouts_pubs = client.messages(:q => 'pub')

And if there are additional pages of results, access them too:

    second_page = client.messages(:q => 'pub').next_page

It's possible to delete messages, and mark them as favourites:

    client.contacts.first.messages.first.delete!
    client.messages.first.favourite!
    client.messages.first.unfavourite!
