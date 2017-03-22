
## MongoDB

- JSON with schema
- [Select and where support](https://specify.io/how-tos/find-documents-in-mongodb-using-the-mongo-shell)
- [Replication via replica sets](https://docs.mongodb.com/manual/replication/). Each replica set member may act in the role of primary or secondary replica at any time. All writes and reads are done on the primary replica by default. Secondary replicas maintain a copy of the data of the primary using built-in replication. When a primary replica fails, the replica set automatically conducts an election process to determine which secondary should become the primary. Secondaries can optionally serve read operations, but that data is only eventually consistent by default.
- [Grid File System](https://en.wikipedia.org/wiki/Grid_File_System)
- Capped collections/fixed size collections
- [] group by/aggregation
- [where with operators](https://www.codeproject.com/articles/1087008/mongo-db-tutorial-and-mapping-of-sql-and-mongo-db)
- [Data types](https://www.codeproject.com/articles/1089786/mongodb-tutorial-day)
- [explain - for query explanation](https://www.codeproject.com/articles/1091645/mongodb-tutorial-day-performance-indexing)
- [Indexes can be: unique, sparse (allow nulls), partial, TTL Indexes](https://www.codeproject.com/articles/1091645/mongodb-tutorial-day-performance-indexing)
- [async replication]()
- [All read preference modes except primary may return stale data because secondaries replicate operations from the primary with some delay. Ensure that your application can tolerate stale data if you choose to use a non-primary mode.](https://docs.mongodb.com/manual/core/read-preference/)
## AWS DynamoDB

- [limited type checking](https://www.trustradius.com/reviews/amazon-dynamodb-2015-10-08-19-24-05)
- [64KB limit on row size and 1MB limit on querying](https://www.trustradius.com/reviews/amazon-dynamodb-2016-08-18-15-51-58)
- [Secondary indexes are not supported](https://www.trustradius.com/reviews/amazon-dynamodb-2016-08-18-15-51-58)
- [can't store empty strings](https://www.g2crowd.com/survey_responses/dynamodb-review-220581)
- [counting the number of items can be expensive](https://www.g2crowd.com/survey_responses/dynamodb-review-103848)
- [primary key - hash or hash range](https://www.slideshare.net/HirokazuTokuno/dynamo-32451865)
- [No Date types](https://www.slideshare.net/HirokazuTokuno/dynamo-32451865)


Couchbase

- [N1QL from version 4.5](https://developer.couchbase.com/documentation/server/4.5/getting-started/first-n1ql-query.html)
- [Operations on arrays](http://query.pub.couchbase.com/tutorial/#12)
- [Couchbase mobile and auto synch to server](https://www.g2crowd.com/survey_responses/couchbase-review-88037)
- 
## Notes

- [MongoDB Wikipedia](https://en.wikipedia.org/wiki/MongoDB)
- [MongoDB tutorial](https://www.codeproject.com/articles/1087008/mongo-db-tutorial-and-mapping-of-sql-and-mongo-db)
- [MongoDB replication](https://docs.mongodb.com/manual/replication/)
- [MongoDB Grid FS](https://en.wikipedia.org/wiki/Grid_File_System)
- [Dynamo DB](https://en.wikipedia.org/wiki/Amazon_DynamoDB)
- [DynamoDB reviews](https://www.trustradius.com/products/amazon-dynamodb/reviews)
- [DynnamoDB reviews](https://www.g2crowd.com/products/dynamodb/reviews)
- [simple comparison of multiple databases](https://kkovacs.eu/cassandra-vs-mongodb-vs-couchdb-vs-redis/)
- [Casandra vs. Mongo vs. Couchbase performance comparison](https://www.slideshare.net/renatko/couchbase-performance-benchmarking)
- [Couchbase reviews](https://www.g2crowd.com/products/couchbase/reviews)