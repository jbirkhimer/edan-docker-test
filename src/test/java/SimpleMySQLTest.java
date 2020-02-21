import org.junit.Rule;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.containers.output.Slf4jLogConsumer;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.Assert.assertEquals;

/**
 * @author jbirkhimer
 */
public class SimpleMySQLTest {

    private static final Logger logger = LoggerFactory.getLogger(SimpleMySQLTest.class);
    private static Slf4jLogConsumer logConsumer = new Slf4jLogConsumer(logger);
    private static final String DB_NAME = "edan_prod";
    private static final String USER = "edanUser";
    private static final String PWD = "edanPass";

    // Add MYSQL_ROOT_HOST environment so that we can root login from anywhere for testing purposes
    @Rule
    public MySQLContainer mySQLContainer = (MySQLContainer) new MySQLContainer("mysql:5.7")
            .withDatabaseName(DB_NAME)
            .withUsername(USER)
            .withPassword(PWD)
            //init script to create and populate dB with test data
            .withInitScript("docker/mysql-init/edan_prod_CONTENT_CONFIG.sql")
            .withInitScript("docker/mysql-init/edan_prod_CONTENT_OBJECTS.sql")
            .withInitScript("docker/mysql-init/edan_prod_CONTENT_OBJECTS_AWS.sql")
            .withInitScript("docker/mysql-init/edan_prod_CONTENT_PROPERTIES.sql")
            .withInitScript("docker/mysql-init/edan_prod_CONTENT_REPO.sql")
            .withInitScript("docker/mysql-init/edan_prod_CONTENT_VERSIONS.sql")
            .withEnv("MYSQL_ROOT_HOST", "%")
            .withLogConsumer(logConsumer);;

    @Test
    public void whenSelectQueryExecuted_thenResultsReturned() throws Exception {
        mySQLContainer.followOutput(logConsumer);

        ResultSet resultSet = performQuery(mySQLContainer, "SELECT * from edan_prod.CONTENT_OBJECTS where id = 'p1a-1469529601706-1470332475765-0'");
        resultSet.next();
        String result = resultSet.getString("title");
        logger.info("Found title: {} <-------------------", result);

        assertEquals("1913 Armory Show: The Story in Primary Sources", result);
    }

    private ResultSet performQuery(MySQLContainer mySQLContainer, String query) throws SQLException {
        String jdbcUrl = mySQLContainer.getJdbcUrl();
        String username = mySQLContainer.getUsername();
        String password = mySQLContainer.getPassword();
        Connection conn = DriverManager.getConnection(jdbcUrl, username, password);
        return conn.createStatement().executeQuery(query);
    }

}
