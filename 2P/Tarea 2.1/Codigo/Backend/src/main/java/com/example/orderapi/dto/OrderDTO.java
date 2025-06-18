package com.example.orderapi.dto;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderDTO {
    private Long id;
    private String nombreCliente;
    private String fechaPedido;
    private List<OrderDetailDTO> detalles = new ArrayList<>();

    // Constructors
    public OrderDTO() {}

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public String getFechaPedido() {
        return fechaPedido;
    }

    public void setFechaPedido(String fechaPedido) {
        this.fechaPedido = fechaPedido;
    }

    public List<OrderDetailDTO> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<OrderDetailDTO> detalles) {
        this.detalles = detalles;
    }
}