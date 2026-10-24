package com.unla.hito2.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.data.domain.Page;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;

import com.unla.hito2.dto.pedido.PedidoAltaDto;
import com.unla.hito2.dto.pedido.PedidoDtoRequest;
import com.unla.hito2.dto.pedido.PedidoDtoResponse;
import com.unla.hito2.entity.UnidadDeVenta;
import com.unla.hito2.service.PedidoService;
import com.unla.hito2.service.UnidadDeVentaService;

@Controller
@RequestMapping("/pedido")
public class PedidoController {

    private PedidoService pedidoService;
    private final UnidadDeVentaService unidadDeVentaService;

    public PedidoController(PedidoService pedidoService,
            UnidadDeVentaService unidadDeVentaService) {
        this.pedidoService = pedidoService;
        this.unidadDeVentaService = unidadDeVentaService;
    }

    @GetMapping("/getPedidos-unidad-venta")
    public ModelAndView getAll(@RequestParam("id") Long id,
            @RequestParam(defaultValue = "0") int pagina,
            Authentication authentication) {

        validarAccesoUnidad(id, authentication);

        Page<PedidoDtoResponse> pedidos = pedidoService.findAllByIdUnidadVenta(id, pagina);

        ModelAndView vista = new ModelAndView("/unidad-venta/index");

        vista.addObject("listaPedidos", pedidos.getContent());
        vista.addObject("idUnidadVenta", id);
        vista.addObject("paginaActual", pedidos.getNumber());
        vista.addObject("totalPaginas", pedidos.getTotalPages());

        return vista;
    }

    @PreAuthorize("hasRole('EMPLEADO')")
    @PostMapping("/alta")
    public ModelAndView alta(
            PedidoDtoRequest dto,
            Authentication authentication) throws Exception {

        validarAccesoUnidad(dto.getIdUnidadDeVenta(), authentication);

        String username = authentication.getName();

        if (!pedidoService.empleadoActivo(username)) {
            return new ModelAndView("redirect:/403");
        }
        try {
            pedidoService.altaPedido(dto, username);
        } catch (IllegalArgumentException e) {
            ModelAndView vista = mostrarFormulario(authentication);
            vista.addObject("error", e.getMessage());
            return vista;
        }

        return mostrarFormulario(authentication);
    }

    @GetMapping("/alta")
    @PreAuthorize("hasRole('EMPLEADO')")
    public ModelAndView mostrarFormulario(Authentication authentication) throws Exception {

        String username = authentication.getName();

        if (!pedidoService.empleadoActivo(username)) {
            return new ModelAndView("redirect:/403");
        }

        PedidoAltaDto pedidoAlta = pedidoService.prepararAltaPorEmpleado(username);

        ModelAndView vista = new ModelAndView("pedido/alta");
        vista.addObject("pedidoAlta", pedidoAlta);

        return vista;
    }

    private void validarAccesoUnidad(Long id, Authentication authentication) {
        boolean esAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMINISTRADOR"));

        if (esAdmin) {
            return;
        }

        boolean esResponsable = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_RESPONSABLE"));

        boolean esEmpleado = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_EMPLEADO"));

        UnidadDeVenta unidad;

        try {
            if (esResponsable) {
                unidad = unidadDeVentaService.buscarPorResponsable(
                        authentication.getName());
            } else if (esEmpleado) {
                unidad = unidadDeVentaService.buscarPorEmpleado(
                        authentication.getName());
            } else {
                throw new AccessDeniedException("Rol no habilitado.");
            }
        } catch (Exception e) {
            throw new AccessDeniedException(
                    "No tenés una unidad de venta habilitada.", e);
        }

        if (!unidad.getId().equals(id)) {
            throw new AccessDeniedException(
                    "No podés consultar los pedidos de otra unidad.");
        }
    }

}
