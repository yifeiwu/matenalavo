#Mate Na Lavo - A Free Classifieds Ad Platform 

**The goal of the application is to allow users to post ads and to be able to query relevant ones**

##Main Features

1. Allows free posting of ads with picture upload
2. Index and allow searching of ads uploaded from additional local sources

###Built with 

* Bootstrap
* JQuery
* PostgreSQL
* Rails 4
* Heroku

###Featured Gems
* Filterrific(Filtering and sorting)
* Kaminari(Pagination)
* pg-search(Full Text Searching)
* Nokogiri(For ad aggregation)
* Carrierwave/Cloudinary(Pic uploads and hosting)

####A live demo of this project can be seen here https://matenalavo.herokuapp.com/

####Known limitations
Need intelligent parsing of ads from local sources. 

####Misc Notes
rake delete:old_records to remove posts older than 60 days





