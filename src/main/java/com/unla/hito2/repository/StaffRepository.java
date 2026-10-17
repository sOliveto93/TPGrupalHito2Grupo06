package com.unla.hito2.repository;

import com.unla.hito2.entity.Staff;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StaffRepository extends JpaRepository<Staff, Long> {
    public boolean existsByDni(String dni);
}
