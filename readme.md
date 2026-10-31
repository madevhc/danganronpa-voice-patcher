<div align="center">

  # 🎮 Save Audio Switcher CLI / PowerShell

  [![PowerShell](https://img.shields.io/badge/PowerShell-v5.1+-blue.svg?style=for-the-badge&logo=powershell&logoColor=white)](https://microsoft.com/powershell)
  [![Batch Script](https://img.shields.io/badge/Batch-Windows_CMD-informational.svg?style=for-the-badge&logo=windows&logoColor=white)](https://en.wikipedia.org/wiki/Batch_file)
  [![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
  [![Platform](https://img.shields.io/badge/Platform-Windows-0078D6.svg?style=for-the-badge&logo=windows)](https://www.microsoft.com)

  **Herramienta automatizada en Script para alternar al instante entre doblaje Japonés (JP) e Inglés (EN) en tus archivos de guardado.**

  [Características](#-características) •
  [Vista Previa](#-demostración-y-capturas) •
  [Instalación](#-instalación) •
  [Uso](#-modo-de-uso) •
  [Copias de Seguridad](#-sistema-de-copias-de-seguridad)

</div>

---

## 📸 Demostración y Capturas

<div align="center">

| Menú Principal del Script | Proceso de Cambio & Backup |
| :---: | :---: |
| <img src="docs/screenshots/main-menu.png" alt="Menú Principal" width="400"/> | <img src="docs/screenshots/backup-process.png" alt="Proceso de Backup" width="400"/> |

</div>

> 💡 **Nota:** Coloca tus imágenes en una carpeta llamada `docs/screenshots/` dentro del repositorio o reemplaza los enlaces anteriores por las URL de tus capturas.

---

## ✨ Características

- ⚡ **Zero Dependencias:** Funciona de forma nativa en Windows mediante **Batch (`.bat`)** o **PowerShell (`.ps1`)**. No requiere instalar intérpretes externos.
- 🔄 **Cambio Automático de Audio:** Modifica los valores hexadecimales / datos en los slots de guardado para alternar entre `JP` y `EN`.
- 🛡️ **Copia de Seguridad Automática:** Duplica el archivo de guardado original con marca de tiempo (`TIMESTAMP`) antes de aplicar cualquier modificación.
- 🎯 **Gestión por Slots:** Detecta y permite seleccionar ranuras específicas de guardado (`Slot 1`, `Slot 2`, etc.).
- ⏪ **Opción de Restauración rápida:** Restaura de manera inmediata el último backup guardado si deseas revertir los cambios.

---

## 🛠️ Requisitos Previos

| Requisito | Versión Mínima | Detalles |
| :--- | :--- | :--- |
| **Sistema Operativo** | Windows 10 / 11 | Compatibilidad nativa |
| **PowerShell** | 5.1+ | Incluido por defecto en Windows |
| **Permisos** | Usuario estándar | No requiere permisos de Administrador |

---

## 🚀 Instalación

1. Ve a la sección de **[Releases](../../releases)** del repositorio.
2. Descarga el paquete `.zip` que contiene los scripts (`.bat` / `.ps1`).
3. Extrae el contenido en la carpeta donde tengas instalados los datos de guardado o en una carpeta de tu preferencia.

O clona directamente el repositorio:

```cmd
git clone https://github.com/tu-usuario/save-audio-switcher.git
cd save-audio-switcher
```

---

## 📖 Modo de Uso

### Método 1: Usando el Ejecutable `.bat` (Recomendado)

> [!TIP]
> Haz doble clic sobre `launcher.bat` para abrir el menú interactivo en consola.

```cmd
:: Simplemente ejecuta el archivo .bat
launcher.bat
```

1. Selecciona el número de slot que deseas modificar (`1-5`).
2. Elige el idioma de voz deseado:
   - `[1]` Japonés (JP)
   - `[2]` Inglés (EN)
3. El script creará la copia de seguridad e informará cuando el proceso haya finalizado.

### Método 2: Desde PowerShell (`.ps1`)

Si prefieres ejecutar directamente el script de PowerShell:

```powershell
# Si recibes un aviso de política de ejecución, habilítala temporalmente:
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Ejecuta el script
.\SaveAudioSwitcher.ps1 -Slot 1 -Audio JP
```

---

## 🛡️ Sistema de Copias de Seguridad

El script garantiza que tus partidas **nunca se corrompan o pierdan**. 

```text
📁 TuProyecto/
 ├── 📜 launcher.bat
 ├── 📜 SaveAudioSwitcher.ps1
 ├── 📁 backups/  <-- Creado automáticamente
 │    ├── 📄 SaveData_Slot1_20261031_102500.bak
 │    └── 📄 SaveData_Slot2_20261031_102612.bak
 └── 📄 SaveData.dat  <-- Archivo modificado
```

> [!CAUTION]
> **No borres la carpeta `backups/`** si deseas conservar la capacidad de revertir tus partidas a su estado original antes de las modificaciones.

---

## 🤝 Contribuciones

Si deseas mejorar el script o añadir compatibilidad para otros juegos:

1. Haz un **Fork** de este repositorio.
2. Crea una rama con tu mejora (`git checkout -b feature/NuevoJuego`).
3. Haz **Commit** de tus cambios (`git commit -m 'Añade soporte para Juego X'`).
4. Haz **Push** a la rama (`git push origin feature/NuevoJuego`).
5. Abre un **Pull Request**.

---

## 📝 Licencia

Este proyecto está bajo la Licencia **MIT**. Consulta el archivo [LICENSE](LICENSE) para más detalles.

<div align="center">

¡Creado con ❤️ para la comunidad de jugadores!

</div>