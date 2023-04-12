var datatable;

$(document).ready(function () {
    loadDataTable();
});

function loadDataTable() {
    datatable = $('#tablaData').DataTable({
        "ajax": {
            "url":"/Account/ListaData"
        },
        "columns": [
            { "data": "name", "width": "20%"},
            { "data": "currency", "width": "20%" },
            { "data": "amount", "width": "20%" },
        ]
    });
}