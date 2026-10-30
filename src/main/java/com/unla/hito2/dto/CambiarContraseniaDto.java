package com.unla.hito2.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class CambiarContraseniaDto {

    @NotBlank(message = "La contraseña actual es obligatoria.")
    private String contraseniaActual;

    @NotBlank(message = "La nueva contraseña es obligatoria.")
    @Size(min = 6,
            message = "La nueva contraseña debe tener al menos 6 caracteres.")
    private String nuevaContrasenia;

    @NotBlank(message = "Debés confirmar la nueva contraseña.")
    private String confirmarContrasenia;

}
