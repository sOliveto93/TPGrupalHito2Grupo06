package com.unla.hito2.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.unla.hito2.dto.PerfilDto;
import com.unla.hito2.entity.Staff;
import com.unla.hito2.entity.Usuario;
import com.unla.hito2.Enum.Rol;
import com.unla.hito2.entity.UsuarioRol;
import com.unla.hito2.repository.StaffRepository;
import com.unla.hito2.repository.UserRepository;

import java.time.LocalDate;


@Service("userService")
public class UserService implements UserDetailsService {

	private UserRepository userRepository;
	private StaffRepository staffRepository;

	public UserService(UserRepository userRepository, StaffRepository staffRepository) {
		this.userRepository = userRepository;
		this.staffRepository = staffRepository;
	}

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		com.unla.hito2.entity.Usuario user = userRepository.findByUsernameAndFetchUsuarioRolesEagerly(username);
		if (user == null) {
			throw new UsernameNotFoundException("Usuario o contraseña incorrectos para: " + username);
		}
		return buildUser(user, buildGrantedAuthorities(user.getUsuarioRoles()));
	}

	private User buildUser(com.unla.hito2.entity.Usuario user, List<GrantedAuthority> grantedAuthorities) {
		return new User(user.getUsername(), user.getPassword(), user.isEnabled(),
						true, true, true, //accountNonExpired, credentialsNonExpired, accountNonLocked,
						grantedAuthorities);
	}

	private List<GrantedAuthority> buildGrantedAuthorities(Set<UsuarioRol> userRoles) {
		Set<GrantedAuthority> grantedAuthorities = new HashSet<>();
		for(UsuarioRol userRole: userRoles) {
			grantedAuthorities.add(new SimpleGrantedAuthority(userRole.getRol().toString()));
		}
		return new ArrayList<>(grantedAuthorities);
	}

	/**
	 * Devuelve un PerfilDto precompletado con los datos del staff asociados
	 * al usuario indicado (campos vacíos si aún no se cargaron).
	 */
	@Transactional(readOnly = true)
	public PerfilDto obtenerPerfil(Long idUsuario) {

		Usuario usuario = userRepository.findById(idUsuario)
				.orElseThrow(() -> new IllegalArgumentException(
						"No se encontró el usuario."));

		Staff staff = usuario.getStaff();

		PerfilDto dto = new PerfilDto();
		if (staff != null) {
			dto.setNombre(staff.getName());
			dto.setApellido(staff.getApellido());
			dto.setDni(staff.getDni());
			dto.setFechaNacimiento(staff.getFechaNac());
		}
		return dto;
	}

	/**
	 * Actualiza los datos personales (nombre, apellido, DNI y fecha de
	 * nacimiento) del staff asociado al usuario. Valida que el DNI no
	 * pertenezca a otro usuario y que la persona sea mayor de edad.
	 */
	@Transactional
	public void actualizarPerfil(Long idUsuario, PerfilDto dto) {

		Usuario usuario = userRepository.findById(idUsuario)
				.orElseThrow(() -> new IllegalArgumentException(
						"No se encontró el usuario."));

		boolean esAdministrador = usuario.getUsuarioRoles().stream()
				.anyMatch(r -> r.getRol() == Rol.ROLE_ADMINISTRADOR);
		if (esAdministrador) {
			throw new IllegalArgumentException(
					"El administrador no posee datos personales.");
		}

		if (userRepository.existsByDniAndIdNot(dto.getDni(), idUsuario)) {
			throw new IllegalArgumentException(
					"Ya existe una persona registrada con ese DNI.");
		}

		if (dto.getFechaNacimiento().plusYears(18).isAfter(LocalDate.now())) {
			throw new IllegalArgumentException(
					"Debés ser mayor de edad (18 años).");
		}

		Staff staff = usuario.getStaff();
		if (staff == null) {
			staff = new Staff();
			staff.setUsuario(usuario);
			staff.setActivo(true);
			usuario.setStaff(staff);
		}

		staff.setName(dto.getNombre().trim());
		staff.setApellido(dto.getApellido().trim());
		staff.setDni(dto.getDni().trim());
		staff.setFechaNac(dto.getFechaNacimiento());
		staffRepository.save(staff);
	}
}
