package com.unla.hito2.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity 
@Table (name = "puesto_desarmable")
public class PuestoDesarmable extends UnidadDeVenta{
    
    private int cantidadCarpas;
    private int tiempoMontajeMinutos;
}
