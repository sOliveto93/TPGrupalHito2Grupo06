package com.unla.hito2.repository;

import com.unla.hito2.entity.Staff;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StaffRepository extends JpaRepository<Staff, Long> {
    public boolean existsByDni(String dni);

    boolean existsByUsuario_UsernameAndActivoTrue(String username);

    Optional<Staff> findByUsuario_Username(String username);
}
