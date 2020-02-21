# EDAN Docker Testing Example

## Get Hostname and Ports:

> org.testcontainers generates random ports mapped to the host.

when using `GenericContainer`:

```$java
int solrPort = solrContainer.getMappedPort(8983);
```

when using `MariaDBContainer`:
```$java
String jdbcUrl = mariaDBContainer.getJdbcUrl();
```

when using `DockerComposeContainer`:

```$java
int edan2_search_ServicePort = environment.getServicePort("edan2_search_1", 8983);
```

> NOTE: Making an Abstract base class that can be used to provide a way to provide common functions like getting ports of the running containers.

## Solr:

Solr search docker is preloaded with random records from prod. There is a method for loading records commented out that can be modified to add records however you like.

Solr is running in standalone mode but cloud mode can also be accomplished if needed. See the edan-docker repo for an example on how to achieve this.

> NOTE: It may be necessary to set permissions on the solr data dir if there are problems with solr starting up


## MariaDb:
The database uses sql init scripts to create the tables and insert rows. The sql init scripts can be modified to add test data as needed.

 
## Running docker-compse.yml standalone:

This can be done as you normally would from cli. Running standalone you can also run searches and populate records. Be sure to commit any changes to data dir's.