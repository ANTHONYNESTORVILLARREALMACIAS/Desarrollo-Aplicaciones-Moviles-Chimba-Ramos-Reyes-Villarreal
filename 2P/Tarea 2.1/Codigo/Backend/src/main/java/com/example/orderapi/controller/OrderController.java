package com.example.orderapi.controller;

import com.example.orderapi.dto.OrderDTO;
import com.example.orderapi.dto.OrderDetailDTO;
import com.example.orderapi.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@RequestMapping("/api/pedidos")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping
    public ResponseEntity<List<OrderDTO>> getAllOrders() {
        return ResponseEntity.ok(orderService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<OrderDTO> getOrderById(@PathVariable Long id) {
        return ResponseEntity.ok(orderService.findById(id));
    }

    @PostMapping
    public ResponseEntity<OrderDTO> createOrder(@RequestBody OrderDTO orderDTO) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
        orderDTO.setFechaPedido(LocalDateTime.now().format(formatter));
        return ResponseEntity.ok(orderService.save(orderDTO));
    }

    @PostMapping("/{id}/detalles")
    public ResponseEntity<OrderDTO> addDetail(@PathVariable Long id, @RequestBody OrderDetailDTO detailDTO) {
        return ResponseEntity.ok(orderService.addDetail(id, detailDTO));
    }

    // Actualizar un pedido
    @PutMapping("/{id}")
    public ResponseEntity<OrderDTO> updateOrder(@PathVariable Long id, @RequestBody OrderDTO orderDTO) {
        orderDTO.setId(id); // Asegurar que el ID en el path sea el usado
        return ResponseEntity.ok(orderService.save(orderDTO));
    }

    // Eliminar un pedido
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteOrder(@PathVariable Long id) {
        orderService.deleteOrder(id);
        return ResponseEntity.noContent().build();
    }

    // Actualizar un detalle de pedido
    @PutMapping("/{orderId}/detalles/{detailId}")
    public ResponseEntity<OrderDTO> updateOrderDetail(
            @PathVariable Long orderId,
            @PathVariable Long detailId,
            @RequestBody OrderDetailDTO detailDTO) {
        detailDTO.setId(detailId);
        return ResponseEntity.ok(orderService.updateDetail(orderId, detailDTO));
    }

    // Eliminar un detalle de pedido
    @DeleteMapping("/{orderId}/detalles/{detailId}")
    public ResponseEntity<Void> deleteOrderDetail(
            @PathVariable Long orderId,
            @PathVariable Long detailId) {
        orderService.deleteDetail(orderId, detailId);
        return ResponseEntity.noContent().build();
    }
}