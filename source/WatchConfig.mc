import Toybox.Lang;

// Simulador: npm run dev del front escucha en el puerto 3001.
// Reloj fisico: cambiar esta URL por https://<dominio>/api/watch
// antes de hacer sideload. El reloj rechaza HTTP.
(:glance)
function watchUrl() as String {
    return "https://www.alertasudestada.com.ar/api/watch";
}
