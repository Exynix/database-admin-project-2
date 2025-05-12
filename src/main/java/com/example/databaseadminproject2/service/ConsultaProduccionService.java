package com.example.databaseadminproject2.service;

import com.example.databaseadminproject2.dto.ProduccionDataDTO;
import com.example.databaseadminproject2.ProduccionDataRowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct; // Use javax.annotation.PostConstruct for older versions

import java.sql.Types;
import java.util.List;
import java.util.Map;

@Service
public class ConsultaProduccionService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private SimpleJdbcCall consultaProduccionPorAnioCall;

    // Initialize SimpleJdbcCall after the bean is constructed
    @PostConstruct
    private void init() {
        this.consultaProduccionPorAnioCall = new SimpleJdbcCall(jdbcTemplate)
                .withCatalogName("CONSULTAS") // Name of your Oracle package
                .withProcedureName("consultaProduccionPorAnio") // Name of your procedure
                .declareParameters(
                        // Declare input parameter for the year
                        new SqlParameter("p_anio", Types.NUMERIC), // Oracle NUMBER maps to JDBC NUMERIC

                        new SqlOutParameter("p_registros", Types.REF_CURSOR, new ProduccionDataRowMapper())
                );
    }

    // Method to call the Oracle procedure
    public List<ProduccionDataDTO> consultarPorAnio(Integer anio) {
        if (anio == null) {
            // Or throw an IllegalArgumentException
            return java.util.Collections.emptyList();
        }

        // Execute the procedure, passing the year as input
        Map<String, Object> executionResult = consultaProduccionPorAnioCall.execute(
                Map.of("p_anio", anio) // Map the input parameter name to its value
        );

        // Retrieve the list of DTOs from the output parameter
        @SuppressWarnings("unchecked") // Cast is safe due to RowMapper
        List<ProduccionDataDTO> produccionDataList = (List<ProduccionDataDTO>) executionResult.get("p_registros");

        // Return the list (will be null if no data found or error occurs - handle as needed)
        return produccionDataList;
    }
}
