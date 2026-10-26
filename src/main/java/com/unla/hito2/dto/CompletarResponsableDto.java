package com.unla.hito2.dto;

import java.time.LocalDate;

import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class CompletarResponsableDto {

    @NotBlank(message = "El nombre es obligatorio.")
    private String nombre;

    @NotBlank(message = "El apellido es obligatorio.")
    private String apellido;

    @NotBlank(message = "El DNI es obligatorio.")
    @Size(min = 7, max = 8,
            message = "El DNI debe escribirse sin puntos ni espacios.")
    private String dni;

    @NotNull(message = "La fecha de nacimiento es obligatoria.")
    @Past(message = "La fecha de nacimiento debe ser anterior a hoy.")
    private LocalDate fechaNac;
}
