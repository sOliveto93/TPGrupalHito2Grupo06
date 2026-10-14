package com.unla.hito2.entity;

import com.unla.hito2.Enum.Turno;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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
@Table (name = "cajero")
public class Cajero extends Staff{
    
    @Enumerated (EnumType.STRING)
    private Turno turno;
    
}
