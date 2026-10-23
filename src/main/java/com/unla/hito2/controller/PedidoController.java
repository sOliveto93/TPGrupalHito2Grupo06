package com.unla.hito2.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;


import com.unla.hito2.dto.pedido.PedidoAltaDto;
import com.unla.hito2.dto.pedido.PedidoDtoRequest;
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
                               Authentication authentication) {

        validarAccesoUnidad(id, authentication);

        ModelAndView vista = new ModelAndView("/unidad-venta/index");

        vista.addObject("listaPedidos", pedidoService.findAllByIdUnidadVenta(id));
        vista.addObject("idUnidadVenta", id);

        return vista;
    }

    @PreAuthorize("hasAnyRole('RESPONSABLE','EMPLEADO')")
    @PostMapping("/alta")
    public ModelAndView alta(PedidoDtoRequest dto,
                             Authentication authentication) throws Exception {

        validarAccesoUnidad(dto.getIdUnidadDeVenta(), authentication);

        try {
            pedidoService.altaPedido(dto);
        } catch (IllegalArgumentException e) {
            ModelAndView vista = mostrarFormulario(authentication);
            vista.addObject("error", e.getMessage());
            return vista;
        }

        return new ModelAndView(
                "redirect:/pedido/getPedidos-unidad-venta?id="
                        + dto.getIdUnidadDeVenta());
    }

    @GetMapping("/alta")
     @PreAuthorize("hasAnyRole('RESPONSABLE','EMPLEADO')")
    public ModelAndView mostrarFormulario(Authentication authentication) throws Exception {
        // admin no puede crear pedidos porque no tiene asociado una unidad de venta
        // consultar si queremos lo pueda hacer.

        String username = authentication.getName();

        boolean esResponsable = authentication.getAuthorities().stream()
                .anyMatch(authority -> authority.getAuthority().equals("ROLE_RESPONSABLE"));

        boolean esEmpleado = authentication.getAuthorities().stream()
                .anyMatch(authority -> authority.getAuthority().equals("ROLE_EMPLEADO"));

        PedidoAltaDto pedidoAlta;

        if (esResponsable) {
            pedidoAlta = pedidoService.prepararAltaPorResponsable(username);
        } else if (esEmpleado) {
            pedidoAlta = pedidoService.prepararAltaPorEmpleado(username);
        } else {
            throw new IllegalStateException("El usuario no tiene un rol habilitado para crear pedidos");
        }

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
