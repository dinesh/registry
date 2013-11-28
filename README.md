Registry
========
A single page application build with sinatra and angular.js for managing companies. It uses AWS s3 for managing owner's assets.

### Usage

``` bash
bundle install
foreman start
# check localhost:3000
```

### Platform Install

```
heroku config:add AWS_BUCKET=...
heroku config:add AWS_ACCESS_KEY=...
heroku config:add AWS_SECRET_KEY=..
git push heroku master
```

### BACKEND API

##### LIST of companies
``` bash
$] curl -s http://techregistry.herokuapp.com/companies
```
```bash
[
  {
    "stamp": null,
    "phone": "206-266-1000",
    "country": "United States",
    "city": "Seattle, WA",
    "address": "1200 12th Ave. South, Ste. 1200",
    "email": "fake@amazone.com",
    "name": "Amazon Inc",
    "id": 1
  },
  {
    "stamp": null,
    "phone": "650-253-0000",
    "country": "United States",
    "city": "Mountain View, CA",
    "address": "1600 Amphitheatre Parkway",
    "email": "fake@google.com",
    "name": "Google Inc",
    "id": 2
  }
]
```

##### CREATE a company
``` bash
$] curl -F "name=Google" \ 
        -F "email=fake@google.com" \
        -F "address=MountainView,CA" \
        -F "phone=0192019012" \
        -F "city=MountainView" \
        -F "country=US" http://techregistry.herokuapp.com/companies
```
#### DELETE a company and owners
```bash
$] curl -i -X DELETE http://techregistry.herokuapp.com//companies/2

```



