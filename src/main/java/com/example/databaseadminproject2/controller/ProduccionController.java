package com.example.databaseadminproject2.controller;

import com.example.databaseadminproject2.dto.ProduccionDataDTO;
import com.example.databaseadminproject2.service.ConsultaProduccionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity; // Use for more control over response

import java.util.List;

@RestController
@RequestMapping("/api/produccion") // Base path for this controller's endpoints
public class ProduccionController {

    @Autowired
    private ConsultaProduccionService consultaProduccionService;

    // Endpoint to get production data by year
    // Example: GET /api/produccion/por-anio/2023
    @GetMapping("/por-anio/{anio}")
    public ResponseEntity<List<ProduccionDataDTO>> getProduccionByAnio(@PathVariable Integer anio) {
        // Call the service layer to get data from the database
        List<ProduccionDataDTO> produccionData = consultaProduccionService.consultarPorAnio(anio);

        if (produccionData == null || produccionData.isEmpty()) {
            // Return 404 Not Found or 204 No Content if no data is found
            return ResponseEntity.noContent().build(); // 204 No Content
            // Or return ResponseEntity.notFound().build(); // 404 Not Found
        } else {
            // Return the list of data with a 200 OK status
            return ResponseEntity.ok(produccionData);
        }
    }
}
