package com.example.setupcheck;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class CheckController {

    private final JdbcClient jdbc;

    public CheckController(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping("/api/check")
    Map<String, Object> check() {
        return Map.of("postgres", jdbc.sql("select version()").query(String.class).single(),
                "message", jdbc.sql("select message from greeting").query(String.class).single());
    }
}
