package com.example.setupcheck;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(properties = "spring.jms.template.receive-timeout=10s")
@AutoConfigureMockMvc
class SetupCheckTest {

    @Autowired
    MockMvc mvc;

    @Autowired
    JmsTemplate jms;

    @Test
    void javaSpringAndPostgresWork() throws Exception {
        mvc.perform(get("/api/check"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("Setup works"));
    }

    @Test
    void messageBrokerWorks() {
        jms.convertAndSend("setup-check", "ping");
        org.junit.jupiter.api.Assertions.assertEquals("ping", jms.receiveAndConvert("setup-check"));
    }
}
