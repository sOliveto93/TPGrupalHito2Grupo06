package com.unla.hito2.controller;

import com.unla.hito2.Enum.CategoriaCocina;
import com.unla.hito2.Enum.Turno;
import com.unla.hito2.dto.EmpleadoDto;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/empleado")
@PreAuthorize("hasRole('RESPONSABLE')")
public class EmpleadoController {

    private final EmpleadoService empleadoService;
    private final UnidadDeVentaService unidadDeVentaService;

    public EmpleadoController(EmpleadoService empleadoService, UnidadDeVentaService unidadDeVentaService) {
        this.empleadoService = empleadoService;
        this.unidadDeVentaService = unidadDeVentaService;
    }

    @GetMapping("/alta")
    public String mostrarFormularioAlta(Model model) {
        model.addAttribute("empleadoDto", new EmpleadoDto());

        model.addAttribute("categorias", CategoriaCocina.values());
        model.addAttribute("turnos", Turno.values());

        return "empleado/formulario";
    }
    @PostMapping("/alta")
    public String registrarEmpleado(@Valid @ModelAttribute("empleadoDto") EmpleadoDto dto,
                                    BindingResult result,
                                    Authentication authentication,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {


        if (result.hasErrors()) {
            model.addAttribute("categorias", CategoriaCocina.values());
            model.addAttribute("turnos", Turno.values());
            return "empleado/formulario";
        }

        try {
            // 2. Obtener la Unidad de Venta del Responsable autenticado
            String username = authentication.getName();
            UnidadDeVenta unidadDeVenta = unidadDeVentaService.buscarPorResponsable(username);

            // 3. Ejecutar el servicio de alta (persistencia + envío de email)
            empleadoService.registrarEmpleado(dto, unidadDeVenta);

            redirectAttributes.addFlashAttribute("exito", "Empleado registrado con éxito. Se enviaron las credenciales por correo.");
            return "redirect:/empleado/alta";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("categorias", CategoriaCocina.values());
            model.addAttribute("turnos", Turno.values());
            return "empleado/formulario";
        }
    }
}