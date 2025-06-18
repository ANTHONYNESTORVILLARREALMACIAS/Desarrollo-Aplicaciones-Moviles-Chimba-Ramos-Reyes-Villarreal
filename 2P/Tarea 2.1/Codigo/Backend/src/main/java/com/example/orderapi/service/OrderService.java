package com.example.orderapi.service;

import com.example.orderapi.dto.OrderDTO;
import com.example.orderapi.dto.OrderDetailDTO;
import com.example.orderapi.model.Order;
import com.example.orderapi.model.OrderDetail;
import com.example.orderapi.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderService {
    @Autowired
    private OrderRepository orderRepository;

    public List<OrderDTO> findAll() {
        return orderRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public OrderDTO findById(Long id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));
        return convertToDTO(order);
    }

    public OrderDTO save(OrderDTO orderDTO) {
        Order order = convertToEntity(orderDTO);
        // Asegúrate de que el ID sea null para objetos nuevos
        if (orderDTO.getId() == null || orderDTO.getId() == 0) {
            order.setId(null); // Garantiza que ID sea null para que la DB asigne uno
        }
        order = orderRepository.save(order);
        return convertToDTO(order);
    }

    public OrderDTO addDetail(Long orderId, OrderDetailDTO detailDTO) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));

        OrderDetail detail = new OrderDetail();
        detail.setNombreProducto(detailDTO.getNombreProducto());
        detail.setCantidad(detailDTO.getCantidad());
        detail.setPrecioUnitario(detailDTO.getPrecioUnitario());

        order.addDetail(detail);
        order = orderRepository.save(order);
        return convertToDTO(order);
    }

    private OrderDTO convertToDTO(Order order) {
        OrderDTO dto = new OrderDTO();
        dto.setId(order.getId());
        dto.setNombreCliente(order.getNombreCliente());
        dto.setFechaPedido(order.getFechaPedido());
        dto.setDetalles(order.getDetalles().stream()
                .map(this::convertToDetailDTO)
                .collect(Collectors.toList()));
        return dto;
    }

    private OrderDetailDTO convertToDetailDTO(OrderDetail detail) {
        OrderDetailDTO dto = new OrderDetailDTO();
        dto.setId(detail.getId());
        dto.setNombreProducto(detail.getNombreProducto());
        dto.setCantidad(detail.getCantidad());
        dto.setPrecioUnitario(detail.getPrecioUnitario());
        return dto;
    }

    private Order convertToEntity(OrderDTO dto) {
        Order order = new Order();
        order.setId(dto.getId());
        order.setNombreCliente(dto.getNombreCliente());
        order.setFechaPedido(dto.getFechaPedido());

        if (dto.getDetalles() != null) {
            dto.getDetalles().forEach(detailDTO -> {
                OrderDetail detail = new OrderDetail();
                detail.setNombreProducto(detailDTO.getNombreProducto());
                detail.setCantidad(detailDTO.getCantidad());
                detail.setPrecioUnitario(detailDTO.getPrecioUnitario());
                order.addDetail(detail);
            });
        }

        return order;
    }

    public void deleteOrder(Long id) {
        orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));
        orderRepository.deleteById(id);
    }

    public OrderDTO updateDetail(Long orderId, OrderDetailDTO detailDTO) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));

        // Buscar el detalle a actualizar
        OrderDetail detailToUpdate = order.getDetalles().stream()
                .filter(detail -> detail.getId().equals(detailDTO.getId()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Detalle no encontrado"));

        // Actualizar los campos
        detailToUpdate.setNombreProducto(detailDTO.getNombreProducto());
        detailToUpdate.setCantidad(detailDTO.getCantidad());
        detailToUpdate.setPrecioUnitario(detailDTO.getPrecioUnitario());

        // Guardar el pedido actualizado
        order = orderRepository.save(order);
        return convertToDTO(order);
    }

    public void deleteDetail(Long orderId, Long detailId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));

        // Buscar el detalle a eliminar
        OrderDetail detailToDelete = order.getDetalles().stream()
                .filter(detail -> detail.getId().equals(detailId))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Detalle no encontrado"));

        // Eliminar el detalle
        order.getDetalles().remove(detailToDelete);
        orderRepository.save(order);
    }
}