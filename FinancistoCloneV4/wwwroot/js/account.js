function deleteAccount(id) {
    Swal.fire({
        title: '¿Estás seguro?',
        text: "¡Esta cuenta se eliminará de tus cuentas!",
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        cancelButtonText: '<i class="fas fa-times-circle"></i> Cancelar',
        confirmButtonText: '<i class="fas fa-check-circle"></i> Sí, Eliminar!'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: "/account/delete?id=" + id,
                type: "get"
            });
            Swal.fire({
                title: 'Eliminado!',
                text: 'Esta cuenta se eliminó de tus cuentas',
                icon: 'success',
                confirmButtonText: 'Ok'
            }).then((result) => {
                if (result.isConfirmed) {
                    location.reload();
                }
            })
        }
    })
}

function loginCorrect() {
    Swal.fire({
        title: '¡Bienvenido!',
        text: 'Inicio de sesión exitoso',
        icon: 'success',
        confirmButtonColor: '#3085d6',
        confirmButtonText: 'Aceptar'
    })
}


