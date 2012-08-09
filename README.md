## Nginx configuration for routing urls

### scripts

####  test_routes
`test_routes.rb` grabs the urls from an xls spreadsheet and fires them against a specfied domain. It then grabs the headers and outputs the response codes.

##### Dependancies

```sh
gem install rest-client spreadsheet trollop 
```
 
#### filter_spreadsheets
grabs all the urls that do not contain the following:

- itemId/topicId
- /help 
- staticpage 
- diol 
- /home

Also has been used to grab atom ids 
- /bdotg\/action\/[A-Z0-9\.]*?$/ 

