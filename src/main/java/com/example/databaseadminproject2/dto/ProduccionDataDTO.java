package com.example.databaseadminproject2.dto;

public class ProduccionDataDTO {
    private Long id;
    private String nombreProducto; // Maps to NOMBRE_PRODUCTO from the join
    private Double costoProduccion; // Maps to COSTO_PRODUCCION
    private Double copVentas;       // Maps to COP_VENTAS
    private Long productoidProducto; // Maps to PRODUCTOID_PRODUCTO
    private Long regionid;          // Maps to REGIONID
    private Long periodoid;         // Maps to PERIODODID (or year if applicable)

    public ProduccionDataDTO() {
    }

    public ProduccionDataDTO(
            Long id,
            String nombreProducto,
            Double costoProduccion,
            Double copVentas,
            Long productoidProducto,
            Long regionid,
            Long periodoid) {
        this.id = id;
        this.nombreProducto = nombreProducto;
        this.costoProduccion = costoProduccion;
        this.copVentas = copVentas;
        this.productoidProducto = productoidProducto;
        this.regionid = regionid;
        this.periodoid = periodoid;
    }

    // --- Getters and Setters ---

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombreProducto() {
        return nombreProducto;
    }

    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
    }

    public Double getCostoProduccion() {
        return costoProduccion;
    }

    public void setCostoProduccion(Double costoProduccion) {
        this.costoProduccion = costoProduccion;
    }

    public Double getCopVentas() {
        return copVentas;
    }

    public void setCopVentas(Double copVentas) {
        this.copVentas = copVentas;
    }

    public Long getProductoidProducto() {
        return productoidProducto;
    }

    public void setProductoidProducto(Long productoidProducto) {
        this.productoidProducto = productoidProducto;
    }

    public Long getRegionid() {
        return regionid;
    }

    public void setRegionid(Long regionid) {
        this.regionid = regionid;
    }

    public Long getPeriodoid() {
        return periodoid;
    }

    public void setPeriodoid(Long periodoid) {
        this.periodoid = periodoid;
    }

    // toString method for logging/debugging
    @Override
    public String toString() {
        return "ProduccionDataDTO{" +
                "id=" + id +
                ", nombreProducto='" + nombreProducto + '\'' +
                ", costoProduccion=" + costoProduccion +
                ", copVentas=" + copVentas +
                ", productoidProducto=" + productoidProducto +
                ", regionid=" + regionid +
                ", periodoid=" + periodoid +
                '}';
    }
}
