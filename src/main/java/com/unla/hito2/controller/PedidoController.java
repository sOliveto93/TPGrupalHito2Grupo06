package com.unla.hito2.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.unla.hito2.dto.pedido.PedidoAltaDto;
import com.unla.hito2.dto.pedido.PedidoDtoRequest;
import com.unla.hito2.entity.UnidadDeVenta;
import com.unla.hito2.service.PedidoService;
import com.unla.hito2.service.UnidadDeVentaService;

@Controller
@RequestMapping("/pedido")
public class PedidoController {

    private PedidoService pedidoService;

    public PedidoController(PedidoService pedidoService) {
        this.pedidoService = pedidoService;
    }

    @GetMapping("/getPedidos-unidad-venta")
    public ModelAndView getAll(@RequestParam("id") Long id) {
        ModelAndView vista = new ModelAndView("/unidad-venta/index");

        vista.addObject("listaPedidos", pedidoService.findAllByIdUnidadVenta(id));
        vista.addObject("idUnidadVenta", id);

        return vista;
    }

    @PostMapping("/alta")
    public ModelAndView alta(PedidoDtoRequest dto) {
        pedidoService.altaPedido(dto);

        return new ModelAndView(
                "redirect:/pedido/getPedidos-unidad-venta?id="
                        + dto.getIdUnidadDeVenta());
    }

    @GetMapping("/alta")
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

}
