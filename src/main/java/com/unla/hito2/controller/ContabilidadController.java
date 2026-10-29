package com.unla.hito2.controller;

import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.dto.ReporteVentaDto;
import com.unla.hito2.dto.UnidadDeVentaDto;
import com.unla.hito2.dto.UnidadDeVentaRankingDto;
import com.unla.hito2.entity.LiquidacionHaberes;
import com.unla.hito2.repository.LiquidacionRepository;
import com.unla.hito2.service.ContabilidadService;
import com.unla.hito2.service.EmailService;
import com.unla.hito2.service.FestivalService;
import com.unla.hito2.service.LiquidacionService;
import com.unla.hito2.service.PdfService;
import com.unla.hito2.service.UnidadDeVentaService;

import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.ByteArrayInputStream;
import java.util.List;

@Controller
@RequestMapping("/contabilidad")
@PreAuthorize("hasAnyRole('EMPLEADO', 'RESPONSABLE', 'ADMINISTRADOR')")
public class ContabilidadController {

    private final ContabilidadService contabilidadService;
    private final FestivalService festivalService;
    private final PdfService pdfService;
    private final LiquidacionRepository liquidacionRepository;
    private final LiquidacionService liquidacionService;
    private final UnidadDeVentaService unidadDeVentaService;
    private final EmailService emailService;

    public ContabilidadController(ContabilidadService contabilidadService, FestivalService festivalService,
            PdfService pdfService, LiquidacionRepository liquidacionRepository,
            LiquidacionService liquidacionService, UnidadDeVentaService unidadDeVentaService,
            EmailService emailService) {
        this.contabilidadService = contabilidadService;
        this.festivalService = festivalService;
        this.pdfService = pdfService;
        this.liquidacionRepository = liquidacionRepository;
        this.liquidacionService = liquidacionService;
        this.unidadDeVentaService = unidadDeVentaService;
        this.emailService = emailService;
    }

    @GetMapping({ "/sueldo", "/liquidacion-sueldo" })
    @PreAuthorize("hasAnyRole('EMPLEADO','RESPONSABLE','ADMINISTRADOR')")
    public String verLiquidacionSueldo(Authentication authentication, Model model,
            @RequestParam(required = false) Long idUnidad) {
        if (authentication == null) {
            return "redirect:/login";
        }

        String username = authentication.getName();

        boolean esAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().contains("ADMIN"));
        boolean esResponsable = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().contains("RESPONSABLE"));
        boolean esEmpleado = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().contains("EMPLEADO"));

        List<LiquidacionHaberes> liquidaciones;
        if (esAdmin) {
            liquidaciones = contabilidadService.obtenerTodasLasLiquidaciones();
            model.addAttribute("festivales", festivalService.traerTodos());
            model.addAttribute("empleados", new java.util.ArrayList<>());
        } else if (esResponsable) {
            if (idUnidad == null) {
                return "redirect:/";
            }

            List<UnidadDeVentaDto> unidades = unidadDeVentaService.buscarUnidadesActivasPorResponsable(username);

            UnidadDeVentaDto unidadSeleccionada = null;

            for (UnidadDeVentaDto unidad : unidades) {
                if (unidad.getId().equals(idUnidad)) {
                    unidadSeleccionada = unidad;
                    break;
                }
            }

            if (unidadSeleccionada == null) {
                throw new org.springframework.security.access.AccessDeniedException(
                        "No tenés acceso a esta unidad de venta.");
            }

            liquidaciones = contabilidadService
                    .obtenerLiquidacionesPorUnidadDeVenta(username, idUnidad);

            model.addAttribute("festivales",
                    java.util.List.of(unidadSeleccionada.getFestival()));
            model.addAttribute("empleados", unidadSeleccionada.getEmpleados());

        } else if (esEmpleado) {
            liquidaciones = contabilidadService.obtenerLiquidacionesPorEmpleadoHistorico(username);
            model.addAttribute("festivales", festivalService.traerTodos());
            model.addAttribute("empleados", new java.util.ArrayList<>());
        } else {
            liquidaciones = new java.util.ArrayList<>();
            model.addAttribute("festivales", festivalService.traerTodos());
            model.addAttribute("empleados", new java.util.ArrayList<>());
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

    @GetMapping("/liquidacion/{id}/pdf")
    @PreAuthorize("hasAnyRole('EMPLEADO','RESPONSABLE','ADMINISTRADOR')")
    public ResponseEntity<InputStreamResource> descargarLiquidacionPdf(@PathVariable Long id) {
        LiquidacionHaberes liquidacion = liquidacionRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Liquidación no encontrada"));

        ByteArrayInputStream bis = pdfService.generarReciboLiquidacion(liquidacion);

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "inline; filename=liquidacion-" + id + ".pdf");

        return ResponseEntity
                .ok()
                .headers(headers)
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(bis));
    }

    @PostMapping("/liquidacion/{id}/enviar-mail")
    @PreAuthorize("hasRole('EMPLEADO')")
    public String enviarLiquidacionPorMail(@PathVariable Long id, Authentication authentication,
            RedirectAttributes redirectAttributes) {
        try {
            if (authentication == null) {
                return "redirect:/login";
            }

            String username = authentication.getName();
            LiquidacionHaberes liquidacion = liquidacionRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Liquidación no encontrada"));

            if (liquidacion.getEmpleado() == null
                    || liquidacion.getEmpleado().getUsuario() == null
                    || !username.equals(liquidacion.getEmpleado().getUsuario().getUsername())) {
                throw new org.springframework.security.access.AccessDeniedException(
                        "No podés enviar esta liquidación por mail.");
            }

            java.io.ByteArrayInputStream bis = pdfService.generarReciboLiquidacion(liquidacion);
            byte[] pdfBytes = bis.readAllBytes();

            String emailDestino = liquidacion.getEmpleado().getUsuario().getEmail();
            String nombreEmpleado = (liquidacion.getEmpleado().getName() != null ? liquidacion.getEmpleado().getName() : "")
                    + " " + (liquidacion.getEmpleado().getApellido() != null ? liquidacion.getEmpleado().getApellido() : "");

            emailService.enviarLiquidacionPorMail(emailDestino, nombreEmpleado.trim(), pdfBytes, liquidacion.getId());
            redirectAttributes.addFlashAttribute("exito", "Liquidación enviada por mail correctamente");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/contabilidad/sueldo";
    }

    //sacar admin de aca
    @PostMapping("/liquidacion/generar")
    @PreAuthorize("hasAnyRole('RESPONSABLE','ADMINISTRADOR')")
    public String generarLiquidacion(@RequestParam Long staffId,
            @RequestParam Long festivalId,
            RedirectAttributes redirectAttributes) {
        try {
            liquidacionService.generarLiquidacion(staffId, festivalId);
            redirectAttributes.addFlashAttribute("exito", "Liquidación generada correctamente");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/contabilidad/sueldo";
    }
}
