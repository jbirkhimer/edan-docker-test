import org.junit.Rule;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.containers.MariaDBContainer;
import org.testcontainers.containers.output.Slf4jLogConsumer;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.Assert.assertEquals;

/**
 * @author jbirkhimer
 */
public class SimpleMariaDbTest {

    private static final Logger logger = LoggerFactory.getLogger(SimpleMariaDbTest.class);
    private static Slf4jLogConsumer logConsumer = new Slf4jLogConsumer(logger);
    private static final String DB_NAME = "edan_prod";
    private static final String USER = "edanUser";
    private static final String PWD = "edanPass";

    // Add MYSQL_ROOT_HOST environment so that we can root login from anywhere for testing purposes
    @Rule
    public MariaDBContainer mariaDBContainer = (MariaDBContainer) new MariaDBContainer("mariadb:10.1.44")
            .withDatabaseName(DB_NAME)
            .withUsername(USER)
            .withPassword(PWD)
            //init script to create and populate dB with test data
//            .withInitScript("docker/mysql-init/init_CONTENT_CONFIG.sql")
            .withInitScript("docker/mysql-init/init_CONTENT_OBJECTS.sql")
//            .withInitScript("docker/mysql-init/init_CONTENT_OBJECTS_AWS.sql")
//            .withInitScript("docker/mysql-init/init_CONTENT_PROPERTIES.sql")
//            .withInitScript("docker/mysql-init/init_CONTENT_REPO.sql")
//            .withInitScript("docker/mysql-init/init_CONTENT_VERSIONS.sql")
            .withEnv("MYSQL_ROOT_HOST", "%")
            .withLogConsumer(logConsumer);;

    @Test
    public void whenSelectQueryExecuted_thenResultsReturned() throws Exception {
        mariaDBContainer.followOutput(logConsumer);

        ResultSet resultSet = performQuery(mariaDBContainer, "SELECT * from edan_prod.CONTENT_OBJECTS where id = 'p1a-1469529601706-1470332475765-0'");
        resultSet.next();
        String result = resultSet.getString("title");
        logger.info("Found title: {} <-------------------", result);

        assertEquals("1913 Armory Show: The Story in Primary Sources", result);
    }

    private ResultSet performQuery(MariaDBContainer mariaDBContainer, String query) throws SQLException {
        String jdbcUrl = mariaDBContainer.getJdbcUrl();
        String username = mariaDBContainer.getUsername();
        String password = mariaDBContainer.getPassword();
        Connection conn = DriverManager.getConnection(jdbcUrl, username, password);
        return conn.createStatement().executeQuery(query);
    }

}
