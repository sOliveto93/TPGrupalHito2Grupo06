package com.unla.hito2.controller;

import com.unla.hito2.Enum.CategoriaCocina;
import com.unla.hito2.Enum.Turno;
import com.unla.hito2.dto.EmpleadoDto;
import com.unla.hito2.dto.HistorialEmpleadoDto;
import com.unla.hito2.entity.UnidadDeVenta;
import com.unla.hito2.service.EmpleadoService;
import com.unla.hito2.service.UnidadDeVentaService;
import jakarta.validation.Valid;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/empleado")
@PreAuthorize("hasAnyRole('RESPONSABLE','EMPLEADO')")
public class EmpleadoController {

    private final EmpleadoService empleadoService;
    private final UnidadDeVentaService unidadDeVentaService;

    public EmpleadoController(EmpleadoService empleadoService, UnidadDeVentaService unidadDeVentaService) {
        this.empleadoService = empleadoService;
        this.unidadDeVentaService = unidadDeVentaService;
    }

    @PreAuthorize("hasRole('RESPONSABLE')")
    @GetMapping("/alta")
    public String mostrarFormularioAlta(
            @RequestParam Long idUnidad,
            Authentication authentication,
            Model model) throws Exception {

        UnidadDeVenta unidad = unidadDeVentaService.buscarPorId(idUnidad);

        if (!unidad.getResponsable().getUsuario().getUsername()
                .equals(authentication.getName())) {
            throw new org.springframework.security.access.AccessDeniedException(
                    "No tenés permiso para gestionar esta unidad de venta");
        }

        model.addAttribute("empleadoDto", new EmpleadoDto());
        model.addAttribute("categorias", CategoriaCocina.values());
        model.addAttribute("turnos", Turno.values());
        model.addAttribute("unidad", unidad);

        return "empleado/formulario";
    }

    @PreAuthorize("hasRole('RESPONSABLE')")
    @PostMapping("/alta")
    public String registrarEmpleado(
            @RequestParam Long idUnidad,
            @Valid @ModelAttribute("empleadoDto") EmpleadoDto dto,
            BindingResult result,
            Authentication authentication,
            Model model,
            RedirectAttributes redirectAttributes) {

        UnidadDeVenta unidad;

        try {
            unidad = unidadDeVentaService.buscarPorId(idUnidad);
        } catch (Exception e) {
            return "redirect:/empleado/lista";
        }

        if (!unidad.getResponsable().getUsuario().getUsername()
                .equals(authentication.getName())) {
            throw new org.springframework.security.access.AccessDeniedException(
                    "No tenés permiso para gestionar esta unidad de venta");
        }

        if (result.hasErrors()) {
            model.addAttribute("categorias", CategoriaCocina.values());
            model.addAttribute("turnos", Turno.values());
            model.addAttribute("unidad", unidad);
            return "empleado/formulario";
        }

        try {
            empleadoService.registrarEmpleado(dto, unidad);

            redirectAttributes.addFlashAttribute(
                    "exito",
                    "Empleado registrado con éxito. Se enviaron las credenciales por correo.");

            return "redirect:/empleado/lista?idUnidad=" + idUnidad;

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("categorias", CategoriaCocina.values());
            model.addAttribute("turnos", Turno.values());
            model.addAttribute("unidad", unidad);

            return "empleado/formulario";
        }
    }

    @PreAuthorize("hasRole('RESPONSABLE')")
    @GetMapping("/lista")
    public ModelAndView listarEmpleados(@RequestParam Long idUnidad, Authentication authentication) throws Exception {
        ModelAndView vista = new ModelAndView("empleado/lista");

        UnidadDeVenta unidad = unidadDeVentaService.buscarPorId(idUnidad);

        String username = authentication.getName();
        if (!unidad.getResponsable().getUsuario().getUsername().equals(username)) {
            throw new org.springframework.security.access.AccessDeniedException(
                    "No tenés permiso para consultar esta unidad de venta");
        }

        vista.addObject("unidad", unidad);
        vista.addObject("empleados", empleadoService.buscarEmpleadosPorUnidad(idUnidad));

        return vista;
    }

    @PreAuthorize("hasRole('EMPLEADO')")
    @GetMapping("/historial")
    public ModelAndView historial(Authentication authentication) {

        Long idStaff = empleadoService.verificarEmpleadoHistorial(
                authentication.getName());

        HistorialEmpleadoDto historial = empleadoService.buscarHistorialEmpleado(idStaff);

        ModelAndView vista = new ModelAndView("/empleado/historial");
        vista.addObject("historialEmpleado", historial);

        return vista;
    }

    @PreAuthorize("hasRole('RESPONSABLE')")
    @PostMapping("/desactivar")
    public String desactivarEmpleado(
            @RequestParam Long idEmpleado,
            @RequestParam Long idUnidad,
            Authentication authentication,
            RedirectAttributes redirectAttributes) throws Exception {

        UnidadDeVenta unidad = unidadDeVentaService.buscarPorId(idUnidad);

        if (!unidad.getResponsable().getUsuario().getUsername()
                .equals(authentication.getName())) {
            throw new org.springframework.security.access.AccessDeniedException(
                    "No tenés permiso para gestionar esta unidad de venta");
        }

        empleadoService.desactivarEmpleado(idEmpleado, idUnidad);

        redirectAttributes.addFlashAttribute(
                "exito", "Empleado desactivado con éxito.");

        return "redirect:/empleado/lista?idUnidad=" + idUnidad;
    }

    @PreAuthorize("hasRole('RESPONSABLE')")
    @PostMapping("/activar")
    public String activarEmpleado(
            @RequestParam Long idEmpleado,
            @RequestParam Long idUnidad,
            Authentication authentication,
            RedirectAttributes redirectAttributes) throws Exception {

        UnidadDeVenta unidad = unidadDeVentaService.buscarPorId(idUnidad);

        if (!unidad.getResponsable().getUsuario().getUsername()
                .equals(authentication.getName())) {
            throw new org.springframework.security.access.AccessDeniedException(
                    "No tenés permiso para gestionar esta unidad de venta");
        }

        empleadoService.activarEmpleado(idEmpleado, idUnidad);

        redirectAttributes.addFlashAttribute(
                "exito", "Empleado activado con éxito.");

        return "redirect:/empleado/lista?idUnidad=" + idUnidad;
    }
}