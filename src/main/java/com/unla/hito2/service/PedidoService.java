package com.unla.hito2.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import com.unla.hito2.dto.pedido.DetallePedidoDtoRequest;
import com.unla.hito2.dto.pedido.DetallePedidoDtoResponse;
import com.unla.hito2.dto.pedido.PedidoAltaDto;
import com.unla.hito2.dto.pedido.PedidoDtoRequest;
import com.unla.hito2.dto.pedido.PedidoDtoResponse;
import com.unla.hito2.dto.pedido.PlatoPedidoDto;
import com.unla.hito2.entity.DetallePedido;
import com.unla.hito2.entity.Pedido;
import com.unla.hito2.entity.Plato;
import com.unla.hito2.entity.UnidadDeVenta;

import com.unla.hito2.repository.PedidoRepository;
import com.unla.hito2.repository.PlatoRepository;
import com.unla.hito2.repository.StaffRepository;
import com.unla.hito2.repository.UnidadDeVentaRepository;

import jakarta.transaction.Transactional;

@Service
public class PedidoService {

    private PedidoRepository pedidoRepository;
    private UnidadDeVentaRepository unidadDeVentaRepository;
    private PlatoRepository platoRepository;
    private StaffRepository staffRepository;

    public PedidoService(PedidoRepository pedidoRepository, UnidadDeVentaRepository unidadDeVentaRepository,
            PlatoRepository platoRepository,StaffRepository staffRepository) {
        this.pedidoRepository = pedidoRepository;
        this.unidadDeVentaRepository = unidadDeVentaRepository;
        this.platoRepository = platoRepository;
        this.staffRepository =staffRepository;
    }

    @Transactional
    public PedidoDtoResponse altaPedido(PedidoDtoRequest dto,String username) {

        validarEmpleadoActivo(username);
        if (dto.getDetalles() == null || dto.getDetalles().isEmpty()) {
            throw new IllegalArgumentException("El pedido debe contener al menos un detalle");
        }

        UnidadDeVenta unidadDeVenta = unidadDeVentaRepository.findById(dto.getIdUnidadDeVenta())
                .orElseThrow(() -> {
                    return new IllegalArgumentException("Unidad de venta no econtrada");
                });

        Pedido pedidoNuevo = new Pedido();

        List<DetallePedido> listaDetalles = new ArrayList<>();

        pedidoNuevo.setUnidadDeVenta(unidadDeVenta);
        pedidoNuevo.setFechaHora(LocalDateTime.now());
        Map<Long, Integer> platosProcesados = new HashMap<>();

        // verificamos duplicados de detalles antes de hacer algo
        // si mas adelante queremos descuentos podemos hacer por total del pedido
        // y si necesitamos descuentos por producto en promocion podemos crear un
        // producto(plato) especifico para el momento

        for (DetallePedidoDtoRequest current : dto.getDetalles()) {

            long idPlato = current.getPlatoId();
            Integer cantidad = current.getCantidad();

            if (idPlato <= 0) {
                throw new IllegalArgumentException(
                        "El ID del plato no es valido");
            }
            if (cantidad < 0) {
                throw new IllegalArgumentException(
                        "La cantidad no puede ser negativa");
            }

            if (cantidad == 0) {
                continue;
            }

            if (platosProcesados.containsKey(current.getPlatoId())) {
                Integer value = platosProcesados.get(current.getPlatoId());
                platosProcesados.put(current.getPlatoId(), value + current.getCantidad());
            } else {
                platosProcesados.put(current.getPlatoId(), current.getCantidad());
            }
        }

        if (platosProcesados.isEmpty()) {
            throw new IllegalArgumentException(
                    "Debés seleccionar al menos un plato con cantidad mayor que cero.");
        }

        for (Map.Entry<Long, Integer> currentId : platosProcesados.entrySet()) {
            Long id = (currentId.getKey());
            Integer cantidad = currentId.getValue();

            Plato plato = platoRepository
                    .findByIdAndUnidadDeVenta_Id(id, unidadDeVenta.getId())
                    .orElseThrow(() -> new IllegalArgumentException(
                            "El plato con id -> " + id + " no existe o no pertenece al menu de la unidad de venta"));

            // aca mas adelante podemos poner validaciones de stock si las piden
            if (!plato.isActivo()) {
                throw new RuntimeException(
                        "El plato con id --> " + plato.getId() + " no se puede vender porque esta inactivo");
            }

            BigDecimal subtotal = plato.getPrecio().multiply(BigDecimal.valueOf(cantidad));

            DetallePedido detalle = new DetallePedido();

            detalle.setPlato(plato);
            detalle.setCantidad(cantidad);
            detalle.setPrecioUnitario(plato.getPrecio());
            detalle.setSubtotal(subtotal);

            // estas dos van juntas por que es bidireccional la relacion
            // consultar si hace falta sacarla en una funcion para evitar errores
            listaDetalles.add(detalle);
            detalle.setPedido(pedidoNuevo);

        }
        pedidoNuevo.setDetalles(listaDetalles);

        Pedido pedido = pedidoRepository.save(pedidoNuevo);

        List<DetallePedidoDtoResponse> dtosDetalles = new ArrayList<>();

        BigDecimal total = BigDecimal.ZERO;

        for (DetallePedido detalle : pedido.getDetalles()) {

            DetallePedidoDtoResponse detalleDto = detallepedidoToDetallePedidoDtoResponse(detalle);

            total = total.add(detalleDto.getSubtotal());

            dtosDetalles.add(detalleDto);
        }

        return new PedidoDtoResponse(pedido.getId(),
                pedido.getFechaHora(),
                dto.getIdUnidadDeVenta(),
                dtosDetalles,
                total);
    }

    private DetallePedidoDtoResponse detallepedidoToDetallePedidoDtoResponse(DetallePedido detalle) {

        DetallePedidoDtoResponse dto = new DetallePedidoDtoResponse();

        dto.setPlatoId(detalle.getPlato().getId());
        dto.setNombrePlato(detalle.getPlato().getNombre());
        dto.setCantidad(detalle.getCantidad());
        dto.setPrecioUnitario(detalle.getPrecioUnitario());
        dto.setSubtotal(detalle.getSubtotal());

        return dto;
    }

    @Transactional
    public Page<PedidoDtoResponse> findAllByIdUnidadVenta(Long id, int numeroPagina) {

        int tamanioPagina = 10;

        Pageable pageable = PageRequest.of(
                numeroPagina,
                tamanioPagina,
                Sort.by(Sort.Order.desc("id")));

        Page<Pedido> paginaPedidos = pedidoRepository.findAllByUnidadDeVenta_Id(id, pageable);

        System.out.println("Unidad consultada: " + id);
        System.out.println("Total de pedidos: " + paginaPedidos.getTotalElements());
        System.out.println("Pedidos en esta página: " + paginaPedidos.getNumberOfElements());

        for (Pedido pedido : paginaPedidos.getContent()) {
            System.out.println(
                    "Pedido ID: " + pedido.getId()
                            + " | Fecha: " + pedido.getFechaHora()
                            + " | Unidad: " + pedido.getUnidadDeVenta().getId());
        }

        List<PedidoDtoResponse> lista = new ArrayList<>();

        for (Pedido pedido : paginaPedidos.getContent()) {
            lista.add(pedidoToDto(pedido));
        }

        return new PageImpl<>(lista, pageable, paginaPedidos.getTotalElements());

    }

    private PedidoDtoResponse pedidoToDto(Pedido pedido) {
        List<DetallePedidoDtoResponse> detallesDto = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;

        for (DetallePedido detalle : pedido.getDetalles()) {

            DetallePedidoDtoResponse detalleDto = detallepedidoToDetallePedidoDtoResponse(detalle);

            detallesDto.add(detalleDto);
            total = total.add(detalle.getSubtotal());
        }

        return new PedidoDtoResponse(
                pedido.getId(),
                pedido.getFechaHora(),
                pedido.getUnidadDeVenta().getId(),
                detallesDto,
                total);
    }

    @Transactional
    public PedidoAltaDto prepararAltaPorEmpleado(String username) {
        validarEmpleadoActivo(username);
        UnidadDeVenta unidad = unidadDeVentaRepository
                .findByEmpleados_Usuario_Username(username)
                .orElseThrow(() -> new IllegalArgumentException(
                        "No se encontró una unidad de venta para el empleado: " + username));

        PedidoAltaDto dto = new PedidoAltaDto();

        dto.setIdUnidadDeVenta(unidad.getId());
        dto.setNombreUnidadDeVenta(unidad.getNombreComercial());

        List<PlatoPedidoDto> platosDto = platosToDto(unidad.getPlatos());

        dto.setPlatos(platosDto);

        return dto;
    }
//no lo usamos mas restringi el acceso solo a empleado
    @Transactional
    public PedidoAltaDto prepararAltaPorResponsable(String username) {

        UnidadDeVenta unidad = unidadDeVentaRepository
                .findByResponsable_Usuario_Username(username)
                .orElseThrow(() -> new IllegalArgumentException(
                        "No se encontró una unidad de venta para el responsable: " + username));

        PedidoAltaDto dto = new PedidoAltaDto();
        dto.setIdUnidadDeVenta(unidad.getId());
        dto.setNombreUnidadDeVenta(unidad.getNombreComercial());

        List<PlatoPedidoDto> platosDto = platosToDto(unidad.getPlatos());

        dto.setPlatos(platosDto);

        return dto;
    }
//hacemos esta doble validacion por las dudas si alguien usa los metodos desde otro servicio
    public boolean empleadoActivo(String username) {
    return staffRepository.existsByUsuario_UsernameAndActivoTrue(username);
}
    private void validarEmpleadoActivo(String username) {
        if (!staffRepository.existsByUsuario_UsernameAndActivoTrue(username)) {
            throw new AccessDeniedException(
                    "El empleado está inactivo y no puede crear pedidos.");
        }
    }

    private List<PlatoPedidoDto> platosToDto(Set<Plato> platos) {
        List<PlatoPedidoDto> platosDto = new ArrayList<>();

        for (Plato plato : platos) {
            if (plato.isActivo()) {
                PlatoPedidoDto platoDto = new PlatoPedidoDto();
                platoDto.setId(plato.getId());
                platoDto.setNombre(plato.getNombre());
                platoDto.setPrecio(plato.getPrecio());
                platosDto.add(platoDto);
            }
        }
        return platosDto;

    }
}
