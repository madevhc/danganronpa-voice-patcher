# Danganronpa Voice Patcher (Trigger Happy Havoc)

<div align="center">

[![Windows](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-blue?style=for-the-badge&logo=windows)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=for-the-badge&logo=powershell)](https://microsoft.com/powershell)

**Danganronpa Voice Patcher** es una suite de herramientas desarrolladas para modificar el idioma del doblaje de voz (**Japonés ↔ Inglés**) en ranuras de guardado específicas de *Danganronpa: Trigger Happy Havoc* (PC/Steam). 

Garantiza la seguridad absoluta de tus datos mediante **backups automáticos verificados por Hash SHA-256**, recálculo de checksums del contenedor VFS y escrituras atómicas.

</div>

---

## Ediciones Disponibles

El parcheador viene en dos ediciones para adaptarse a tu estilo de uso:

| Edición | Tipo | Descripción | Captura / Estilo |
| :--- | :--- | :--- | :--- |
| **Junko Edition** | **GUI (WPF)** | Interfaz gráfica moderna con tema oscuro, tarjetas visuales de slots, soporte trilingüe y logs integrados. | ![Junko GUI](/screenshots/GUI-img.png) |
| **Celestia Edition** | **CLI (Consola ANSI)** | Interfaz de consola elegante, con colores TrueColor (RGB ANSI), tablas formateadas y banners ASCII estilizados. | ![Celeste CLI](/screenshots/CLI-img-1.png) |

---

## Características Principales

* **Seguridad e Integridad de Partidas:**
  * **Backups Verificados:** Genera automáticamente respaldos `.bak_YYYYMMDD_HHMMSS_fff` comprobando tamaño y Hash SHA-256 antes de escribir.
  * **Recálculo de Checksum:** Recomputa el checksum interno del contenedor VFS para evitar que el juego detecte los guardados como corruptos.
  * **Escritura Atómica con Auto-Restauración:** Escribe primero en un archivo temporal; si la verificación posterior falla, restaura la copia de seguridad de inmediato.

* **Detección Activa del Juego:** Revisa si el ejecutable de Danganronpa está en ejecución para evitar conflictos con Steam Cloud o sobreescrituras accidental.

* **Zero Dependencias:** No requiere instalación. Empaquetado en scripts ejecutables `.bat` que auto-decodifican y ejecutan PowerShell de forma transparente mediante `certutil`.

---

## Capturas de Pantalla

### Junko Edition (GUI)
| Interfaz |
| :---: |
| ![Junko Main](/screenshots/GUI-img.png) |

> 💡 *Soporta selección multilenguaje dinámica (Español, Inglés y Japonés).*

### Celestia Edition (CLI)
| Menú principal | Selección de Acciones |
| :---: | :---: |
| ![Celestia Table](/screenshots/CLI-img-1.png) | ![Celeste Action](/screenshots/CLI-img-2.png) |

---

## Requisitos del Sistema

| Componente | Requisito Mínimo |
| :--- | :--- |
| **Sistema Operativo** | Windows 10 / 11 (64-bit) |
| **Entorno** | Windows PowerShell 5.1+ (Incluido por defecto en Windows) |
| **Juego** | *Danganronpa: Trigger Happy Havoc* (Versión PC / Steam) |

---

## Instalación y Uso

1. Descarga la versión de tu preferencia desde la sección de [**Releases**](../../releases):
   * `DanganronpaVoicePatcher_MAdev_Multilang.bat` (GUI)
   * `DanganronpaVoicePatcher_MAdev_CLI.bat` (CLI)
2. Haz doble clic en el archivo `.bat` deseado para ejecutarlo.

### Pasos Generales:
1. **Detección de Guardado:** El programa cargará por defecto la ruta estándar:
   `%USERPROFILE%\Documents\My Games\Danganronpa\savedata.vfs`
2. **Seleccionar Slot:** Elige el slot (`data0001.bin`, `data0002.bin`, etc.) que deseas modificar.
3. **Aplicar Cambio:** Cambia la voz a **Japonés** o **Inglés**.

> [!WARNING]
> **Steam Cloud:** Después de realizar modificaciones, asegúrate de comprobar que Steam Cloud no restaure tus archivos antiguos al iniciar el juego.

---

## Estructura de Archivos y Backups

Los respaldos se almacenan junto al archivo original con una marca de tiempo precisa:

```
Documents/My Games/Danganronpa/
 ├── savedata.vfs
 ├── savedata.vfs.bak_20261031_103000_123   <-- Copia de seguridad verificada por SHA-256
 └── ...
```

---

## Autoría

Desarrollado por **MA_Dev**.

## Licencia

Este proyecto está bajo la Licencia **MIT**. Consulta el archivo [LICENSE](LICENSE) para más detalles.
