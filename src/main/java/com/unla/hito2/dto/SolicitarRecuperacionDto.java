package com.unla.hito2.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class SolicitarRecuperacionDto {

    @NotBlank(message = "El email es obligatorio.")
    @Email(message = "Ingresá un email válido.")
    private String email;

}
