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
@Table (name = "foodtruck")
public class FoodTruck extends UnidadDeVenta {

   
    private String patente;
    private boolean requiereElectricidad;
}
