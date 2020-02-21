import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.client.solrj.response.UpdateResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrInputDocument;
import org.junit.ClassRule;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.containers.DockerComposeContainer;
import org.testcontainers.containers.output.Slf4jLogConsumer;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.assertEquals;

/**
 * @author jbirkhimer
 */
public class ExampleEdanDockerComposeTest {

    private static final Logger logger = LoggerFactory.getLogger(ExampleEdanDockerComposeTest.class);
    private static Slf4jLogConsumer logConsumer = new Slf4jLogConsumer(logger);

    private static final String DB_NAME = "edan_prod";
    private static final String USER = "edanUser";
    private static final String PWD = "edanPass";
    private static final int DATABASE_PORT = 3306;
    private static Map<String, String> envVars = new HashMap<>();

    static {
        envVars.put("MYSQL_ROOT_PASSWORD", "test");
        envVars.put("MYSQL_DATABASE", DB_NAME);
        envVars.put("MYSQL_USER", USER);
        envVars.put("MYSQL_PASSWORD", PWD);
    }

    @ClassRule
    public static DockerComposeContainer environment = new DockerComposeContainer(new File("src/test/resources/docker/docker-compose.yml"))
            .withTailChildContainers(true)
            .withEnv(envVars)

            .withLogConsumer("db_1", logConsumer)
            .withExposedService("db_1", DATABASE_PORT)

            .withLogConsumer("edan2_search_1", logConsumer) //use the service name in docker-compose.yml
            .withExposedService("edan2_search_1", 8983);


    @Test
    public void whenSelectQueryExecuted_thenResultsReturned() throws Exception {
        //get the hostname and port of docker db
        String serviceHost = environment.getServiceHost("db_1", DATABASE_PORT);
        int servicePort = environment.getServicePort("db_1", DATABASE_PORT);

        //build the jdbcUrl from docker host and port
        String jdbcUrl = "jdbc:mysql://" + serviceHost + ":" +servicePort + "/" + DB_NAME;

        ResultSet resultSet = performQuery(jdbcUrl, "SELECT * from edan_prod.CONTENT_OBJECTS where id = 'p1a-1469529601706-1470332475765-0'");
        resultSet.next();

        String result = resultSet.getString("title");

        logger.info("Found title: {} <-------------------", result);

        assertEquals("1913 Armory Show: The Story in Primary Sources", result);
    }

    private ResultSet performQuery(String jdbcUrl, String query) throws SQLException {
        Connection conn = DriverManager.getConnection(jdbcUrl, USER, PWD);
        return conn.createStatement().executeQuery(query);
    }

    @Test
    public void test_solrSearch() throws IOException, SolrServerException {
        //get the hostname and port of docker solr search
        String edan2_search_ServiceHost = environment.getServiceHost("edan2_search_1", 8983);
        int edan2_search_ServicePort = environment.getServicePort("edan2_search_1", 8983);

        //configure the solr client for docker solr
        SolrClient searchClient = new HttpSolrClient.Builder("http://"+edan2_search_ServiceHost+":"+edan2_search_ServicePort+"/solr").build();

        //Uncomment to add some data from prod
        //loadSomeData(searchClient, collection);

        //query for testing
        SolrQuery solrQuery = new SolrQuery();
        solrQuery.setQuery("*:*");

        //run the query against docker sole
        QueryResponse rsp = searchClient.query("search", solrQuery);

        long numfound = rsp.getResults().getNumFound();
        logger.info("solr numFound = {}", numfound);

        assertEquals("Record count does not match", 10, numfound);
    }

    /**
     * For loading some records from prod to docker solr
     * We could also use json files and load fresh data when bringing the container up
     *
     * @param searchClient
     * @param collection
     * @throws IOException
     * @throws SolrServerException
     */
    private void loadSomeData(SolrClient searchClient, String collection) throws IOException, SolrServerException {
        Collection<SolrInputDocument> docs = new ArrayList<>();

        //Use prod to get some records to populate docker solr
        SolrClient copySolrClient = new HttpSolrClient.Builder("http://lassb-service03.si.edu:9111/solr").build();

        //select query for records from prod
        SolrQuery solrQuery = new SolrQuery();
        solrQuery.setQuery("*:*");
        solrQuery.setRows(10);
        solrQuery.addFilterQuery("type:edanmdm");
        solrQuery.setSort("_last_time_updated", SolrQuery.ORDER.desc);

        //preform prod query
        QueryResponse rsp = copySolrClient.query(collection, solrQuery);

        //remove version
        rsp.getResults().forEach(doc -> doc.remove("_version_"));

        //convert prod SolrDocumentList to Collection<SolrInputDocument>
        rsp.getResults().forEach(doc -> docs.add(toSolrInputDocument(doc)));

        //Update docker solr
        UpdateResponse r = searchClient.add(collection, docs, 1000);
        logger.info("Solr commit {}", r);
    }

    public static SolrInputDocument toSolrInputDocument(SolrDocument d) {
        SolrInputDocument doc = new SolrInputDocument();
        d.forEach(field -> doc.addField(field.getKey(), field.getValue()));
        return doc;
    }

}
