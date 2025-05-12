package com.example.databaseadminproject2;

import com.example.databaseadminproject2.dto.ProduccionDataDTO;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ProduccionDataRowMapper implements RowMapper<ProduccionDataDTO> {

    @Override
    public ProduccionDataDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
        // Map columns from the ResultSet to your DTO fields.
        // Use the column names *exactly* as defined in your Oracle SELECT statement or their aliases.
        return new ProduccionDataDTO(
                rs.getLong("ID"),
                rs.getString("NOMBRE_PRODUCTO"),
                rs.getDouble("COSTO_PRODUCCION"),
                rs.getDouble("COP_VENTAS"),
                rs.getLong("PRODUCTOID_PRODUCTO"),
                rs.getLong("REGIONID"),
                rs.getLong("periodoid")
        );
    }
}
