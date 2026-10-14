<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="BACKEND.clsReclamos"%>

<%
    String mensaje = "";
    String claseAlerta = "d-none";
    String tipoAlerta = "alert-info";

    String nombre = request.getParameter("pNombre");
    String telefono = request.getParameter("pTelefono");
    String direccion = request.getParameter("pDireccion");
    String tipoReclamo = request.getParameter("pTipoReclamo");
    String descripcion = request.getParameter("pDescripcion");
    String fechaIngreso = request.getParameter("pFechaIngreso");
    String boton = request.getParameter("pBoton");

    if (boton != null && boton.equals("Registrar Ticket")) {
        if (telefono != null && !telefono.trim().isEmpty() && nombre != null && !nombre.trim().isEmpty()) {
            
            clsReclamos reclamo = new clsReclamos();
            reclamo.setNombre(nombre);
            reclamo.setTelefono(telefono);
            reclamo.setDireccion(direccion);
            reclamo.setTipo_Reclamo(tipoReclamo);
            reclamo.setDescripcion(descripcion);
            reclamo.setFecha_Ingreso(fechaIngreso);
            reclamo.setEstado("PENDIENTE");

            int resp = reclamo.fncIngreso(reclamo);
            claseAlerta = "d-block";
            
            if (resp == 1) {
                mensaje = "Reclamo registrado exitosamente en el sistema.";
                tipoAlerta = "alert-success";
            } else {
                mensaje = "Error al registrar el ticket. Verifique si el teléfono o folio ya se encuentra en proceso.";
                tipoAlerta = "alert-danger";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mesa de Ayuda - Ingreso de Reclamos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f4f8; }
        .bg-tigo { background: linear-gradient(135deg, #002b66 0%, #004494 100%); }
        .card-custom { border-radius: 12px; border: none; box-shadow: 0 8px 24px rgba(0,0,0,0.06); }
        .btn-submit { background-color: #059669; border: none; }
        .btn-submit:hover { background-color: #047857; }
    </style>
</head>
<body>

<div class="container py-5" style="max-width: 820px;">

    <!-- Barra de Navegación -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <span class="fw-semibold text-muted">Módulo de Recepción</span>
        <a href="atencion.jsp" class="btn btn-outline-dark px-3 fw-semibold">
            Ir al Panel de Despacho (FIFO) →
        </a>
    </div>

    <% if (!mensaje.isEmpty()) { %>
        <div class="alert <%= tipoAlerta %> text-center fw-semibold shadow-sm mb-4" role="alert">
            <%= mensaje %>
        </div>
    <% } %>

    <div class="card card-custom">
        <div class="card-header bg-tigo text-white text-center py-4 rounded-top-4">
            <h4 class="mb-1 fw-bold text-uppercase tracking-wide">Registro de Reclamo Técnico</h4>
            <p class="mb-0 small text-white-50">Captura inicial de incidentes para atención al cliente</p>
        </div>

        <div class="card-body p-4 p-md-5">
            <form method="post" action="index.jsp">
                
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark small">Nombre Completo del Cliente</label>
                        <input type="text" name="pNombre" class="form-control" placeholder="Ej. Carlos Mendoza" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark small">Teléfono / Línea de Contacto</label>
                        <input type="text" name="pTelefono" class="form-control" placeholder="Ej. 5555-1234" required>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-bold text-dark small">Dirección de Instalación</label>
                        <input type="text" name="pDireccion" class="form-control" placeholder="Calle, zona, municipio" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark small">Tipo de Servicio Afectado</label>
                        <select name="pTipoReclamo" class="form-select" required>
                            <option value="">-- Seleccione categoría --</option>
                            <option value="Atención de planes de televisión">Planes de Televisión / Canales</option>
                            <option value="Problemas con la caja de recepción de cable">Falla en Caja Receptora / Decodificador</option>
                            <option value="Intermitencia de enlace de datos">Intermitencia de Red</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark small">Fecha de Reporte</label>
                        <input type="date" name="pFechaIngreso" class="form-control" required>
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-bold text-dark small">Descripción Detallada de la Falla</label>
                        <textarea name="pDescripcion" rows="3" class="form-control" placeholder="Describa el comportamiento anómalo o código de error..." required></textarea>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark small">Estado de Ingreso</label>
                        <input type="text" name="pEstado" value="PENDIENTE" readonly class="form-control bg-light text-muted">
                    </div>
                </div>

                <div class="d-grid mt-4">
                    <input type="submit" name="pBoton" value="Registrar Ticket" class="btn btn-submit btn-lg text-white fw-bold py-3">
                </div>

            </form>
        </div>
    </div>

</div>

</body>
</html>