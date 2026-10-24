package com.unla.hito2.controller;

import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.dto.ReporteVentaDto;
import com.unla.hito2.dto.UnidadDeVentaRankingDto;
import com.unla.hito2.entity.LiquidacionHaberes;
import com.unla.hito2.service.ContabilidadService;
import com.unla.hito2.service.FestivalService;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
@RequestMapping("/contabilidad")
@PreAuthorize("hasAnyRole('EMPLEADO', 'RESPONSABLE', 'ADMINISTRADOR')")
public class ContabilidadController {

    private final ContabilidadService contabilidadService;
    private FestivalService festivalService;

    public ContabilidadController(ContabilidadService contabilidadService, FestivalService festivalService) {
        this.contabilidadService = contabilidadService;
        this.festivalService = festivalService;
    }

    @GetMapping({ "/sueldo", "/liquidacion-sueldo" })
    @PreAuthorize("hasAnyRole('EMPLEADO','RESPONSABLE')")
    public String verLiquidacionSueldo(Authentication authentication, Model model) {
        if (authentication == null) {
            return "redirect:/login";
        }

        String username = authentication.getName();

        boolean esResponsable = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().contains("RESPONSABLE"));

        List<LiquidacionHaberes> liquidaciones;
        if (esResponsable) {
            liquidaciones = contabilidadService.obtenerLiquidacionesPorUnidadDeVenta(username);
        } else {
            liquidaciones = contabilidadService.obtenerLiquidacionesPorEmpleadoHistorico(username);
        }

        model.addAttribute("liquidaciones", liquidaciones);
        model.addAttribute("username", username);

        return "contabilidad/liquidacion-sueldo";
    }

    @GetMapping("/ranking")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ModelAndView rankingUnidadesVentaPorPedido(@RequestParam Long id) {
        ModelAndView vista = new ModelAndView("/contabilidad/ranking-unidades-por-pedido");
        List<UnidadDeVentaRankingDto> lista = contabilidadService.rankingUnidadesVentaPorPedido(id);
        FestivalDto festival = festivalService.traerFestivalPorId(id);
        vista.addObject("lista", lista);
        vista.addObject("festival", festival);

        return vista;
    }

    @GetMapping("/reporte-venta")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ModelAndView generarReporteVentaPorFestival(@RequestParam Long id) {
        ModelAndView vista = new ModelAndView("contabilidad/reporte-venta");

        try {
            ReporteVentaDto reporte = contabilidadService.generarReporteVentaPorFestival(id);
            vista.addObject("reporte", reporte);
        } catch (IllegalArgumentException e) {
            vista.addObject("error", "No existe un festival con el ID " + id + ".");
        }
        return vista;
    }
}