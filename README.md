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
$] curl -d "{\"company\":{\"name\":\"Google\",\"email\":\"fake@google.com\",\"address\":\"MountainView, CA\",\"phone\":\"789 123 1239\",\"city\":\"MountainView\",\"country\":\"US\"}}" http://techregistry.herokuapp.com/companies
```
``` bash
{
  "stamp": null,
  "phone": "789 123 1239",
  "country": "US",
  "city": "MountainView",
  "address": "MountainView, CA",
  "email": "fake@google.com",
  "name": "Google",
  "id": 15
}
```
#### Update a company
``` bash
$] curl -X PUT -d "{\"company\":{\"country\":\"United States\"}}" http://techregistry.herokuapp.com/companies/15
```
``` bash
{
  "stamp": null,
  "phone": "789 123 1239",
  "country": "United States",
  "city": "MountainView",
  "address": "MountainView, CA",
  "email": "fake@google.com",
  "name": "Google",
  "id": 15
}
```

#### DELETE a company and owners
```bash
$] curl -i -X DELETE http://techregistry.herokuapp.com/companies/15
```
``` bash
HTTP/1.1 200 OK
Content-Type: text/html;charset=utf-8
Content-Length: 16
Connection: keep-alive
Server: thin 1.6.1 codename Death Proof

{"success":"ok"}
```
