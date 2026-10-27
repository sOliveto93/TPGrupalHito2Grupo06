package com.unla.hito2.dto;


import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class HistorialEmpleadoDto {

    private EmpleadoDto empleado;
    private List<UnidadHistorialDto> historial;
}
