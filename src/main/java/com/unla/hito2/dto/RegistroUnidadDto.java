package com.unla.hito2.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RegistroUnidadDto  {

    //atributos de la unidad
    @NotNull
    private Long festivalId;
    private String codigo;
    @NotBlank(message = "El nombre comercial es obligatorio.")
    private String nombreComercial;
    @NotNull
    private Double superficie;
    @NotBlank
    private String tipoUnidad;

    //atributos de foodtruck
    private String patente;
    private Boolean requiereElectricidad;

    //atributos de puesto desarmable
    private Integer cantidadCarpas;
    private Integer tiempoMontajeMinutos;

    //atributos del responsable
    @NotBlank
    private String nombre;
    @NotBlank
    private String apellido;
    @NotBlank(message = "El DNI es obligatorio.")
    @Size(min=7, max = 8, message = "El DNI debe escribirse sin puntos ni espacios")
    private String dni;
    @NotNull
    private LocalDate fechaNac;
    private LocalDate fechaIngreso;
    @NotBlank
    @Email(message = "Debe ingresar un email válido.")
    private String email;
    @NotBlank
    @Size(min = 6, message = "La contraseña debe tener al menos 6 caracteres.")
    private String password;


}
