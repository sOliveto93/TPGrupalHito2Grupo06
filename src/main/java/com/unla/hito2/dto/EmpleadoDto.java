package com.unla.hito2.dto;

import com.unla.hito2.Enum.CategoriaCocina;
import com.unla.hito2.Enum.Turno;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EmpleadoDto {
    private Long id;
    private boolean activo;
    @NotBlank
    private String name;
    @NotBlank
    private String apellido;
    @NotBlank(message = "El DNI es obligatorio")
    @Pattern(regexp = "^[0-9]{7,8}$", message = "El DNI debe contener solo números y tener 7 u 8 dígitos")
    private String dni;
    @NotNull
    private LocalDate fechaNac;
    @NotNull
    private LocalDate fechaIngreso;
    @NotBlank
    private String tipoEmpleado;
    // atributos de usuario
    @NotBlank(message = "El correo electrónico es obligatorio")
    @Email(message = "El correo electrónico no tiene un formato válido")
    private String email;

    // atributos de cajero
    private Turno turno;

    // atributos de cocinero
    private CategoriaCocina categoria;
    
}
