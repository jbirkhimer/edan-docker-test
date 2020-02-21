import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.client.solrj.response.UpdateResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrInputDocument;
import org.junit.Rule;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.containers.BindMode;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.output.Slf4jLogConsumer;
import org.testcontainers.containers.wait.strategy.Wait;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;

import static org.junit.Assert.assertEquals;

/**
 * @author jbirkhimer
 */
public class SimpleSolrTest {

    private static final Logger logger = LoggerFactory.getLogger(SimpleSolrTest.class);
    private static Slf4jLogConsumer logConsumer = new Slf4jLogConsumer(logger);

    // Add MYSQL_ROOT_HOST environment so that we can root login from anywhere for testing purposes
    @Rule
    public GenericContainer solrContainer = (GenericContainer) new GenericContainer("solr:6.6.1")
            .withFileSystemBind("src/test/resources/docker/edan2_search", "/opt/solr/server/solr/mycores/search", BindMode.READ_WRITE)
            .withExposedPorts(8983)
            .withPrivilegedMode(true)
            .withLogConsumer(logConsumer)
            .waitingFor(Wait.forHttp("/solr/search/admin/ping").forStatusCode(200));;

    @Test
    public void test_solrSearch() throws IOException, SolrServerException {
        int solrPort = solrContainer.getMappedPort(8983);
        String solrHost = solrContainer.getContainerIpAddress();

        //configure the solr client for docker solr
        SolrClient searchClient = new HttpSolrClient.Builder("http://"+solrHost+":"+solrPort+"/solr").build();

        //Uncomment to add some data from prod
        //loadSomeData(searchClient, "search");

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
