
##### Versioning for data
I have added versioning support for database models on top of Sequel::Model. Please checkout registry/versioned.rb and specs.

##### You do not need to add authentication to your web service, but propose a protocol / method and justify your choice.
I will prefer to use https protocol and bcrypt cryptographic function to store user's password. Since registry app is a rack based app, I would like to use warden as authentication middleware which is well documented and flexible. 



##### How can you make the service redundant? What considerations should you do?

The most important thing to have high availaibity is to remove any single point of failure and bottlenecks in the stack. I can use a load balancer(HA proxy) with failover mechanism and run multiple thin servers. This way I can handle traffic spikes and provides a good measure of elasticity. At database layer I can add atleast one master/slave combination to split reads/writes.  I can use aws-s3 For faster access of assets.
