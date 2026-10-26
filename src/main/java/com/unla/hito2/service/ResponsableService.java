package com.unla.hito2.service;

import com.unla.hito2.repository.StaffRepository;
import org.springframework.stereotype.Service;
import com.unla.hito2.dto.CompletarResponsableDto;
import com.unla.hito2.entity.Staff;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.Period;

@Service
public class ResponsableService {

    private final StaffRepository staffRepository;

    public ResponsableService(StaffRepository staffRepository) {
        this.staffRepository = staffRepository;
    }

    @Transactional
    public void completarDatos(String username, CompletarResponsableDto dto) {

        Staff responsable = staffRepository.findByUsuario_Username(username)
                .orElseThrow(() -> new IllegalArgumentException(
                        "No se encontró el responsable."));

        boolean perfilCompleto =
                responsable.getName() != null && !responsable.getName().isBlank()
                        && responsable.getApellido() != null && !responsable.getApellido().isBlank()
                        && responsable.getDni() != null && !responsable.getDni().isBlank()
                        && responsable.getFechaNac() != null;

        if (perfilCompleto) {
            throw new IllegalArgumentException(
                    "Tus datos personales ya están completos.");
        }

        if (!dto.getDni().matches("^\\d{7,8}$")) {
            throw new IllegalArgumentException(
                    "El DNI debe contener entre 7 y 8 dígitos.");
        }

        if (!dto.getDni().equals(responsable.getDni())
                && staffRepository.existsByDni(dto.getDni())) {
            throw new IllegalArgumentException(
                    "Ya existe una persona registrada con ese DNI.");
        }

        int edad = Period.between(
                dto.getFechaNac(), LocalDate.now()).getYears();

        if (edad < 18) {
            throw new IllegalArgumentException(
                    "El responsable debe ser mayor de edad.");
        }

        if (responsable.getFechaIngreso() != null
                && responsable.getFechaIngreso().isBefore(dto.getFechaNac())) {
            throw new IllegalArgumentException(
                    "La fecha de nacimiento no puede ser posterior a la de ingreso.");
        }

        responsable.setName(dto.getNombre().trim());
        responsable.setApellido(dto.getApellido().trim());
        responsable.setDni(dto.getDni());
        responsable.setFechaNac(dto.getFechaNac());

        staffRepository.save(responsable);
    }

    @Transactional(readOnly = true)
    public CompletarResponsableDto obtenerDatos(String username) {
        Staff responsable = staffRepository.findByUsuario_Username(username)
                .orElseThrow(() -> new IllegalArgumentException(
                        "No se encontró el responsable."));

        CompletarResponsableDto dto = new CompletarResponsableDto();
        dto.setNombre(responsable.getName());
        dto.setApellido(responsable.getApellido());
        dto.setDni(responsable.getDni());
        dto.setFechaNac(responsable.getFechaNac());

        return dto;
    }

}
