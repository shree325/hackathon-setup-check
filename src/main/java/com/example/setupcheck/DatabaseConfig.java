package com.example.setupcheck;

import com.zaxxer.hikari.HikariDataSource;
import io.zonky.test.db.postgres.embedded.EmbeddedPostgres;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;
import java.io.IOException;

/** Starts a throwaway Postgres, the same way the hackathon app does. */
@Configuration
public class DatabaseConfig {

    @Bean(destroyMethod = "close")
    EmbeddedPostgres embeddedPostgres() throws IOException {
        return EmbeddedPostgres.builder().start();
    }

    @Bean
    DataSource dataSource(EmbeddedPostgres pg) {
        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl(pg.getJdbcUrl("postgres", "postgres"));
        ds.setUsername("postgres");
        return ds;
    }
}
