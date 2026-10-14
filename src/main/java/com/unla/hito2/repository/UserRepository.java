package com.unla.hito2.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.unla.hito2.entity.Usuario;

@Repository
public interface UserRepository extends JpaRepository<Usuario, Long> {
    @Query("SELECT u FROM Usuario u JOIN FETCH u.usuarioRoles WHERE u.username = (:username)")
    public abstract Usuario findByUsernameAndFetchUsuarioRolesEagerly(@Param("username") String username);
}
