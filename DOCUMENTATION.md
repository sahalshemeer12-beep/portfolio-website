# Portfolio Website & Server Documentation

This document contains full instructions and details for running, accessing, and deploying the portfolio website and its high-performance local server.

---

## 1. Project Overview

- **Project Name:** Semaan — Creative Director & Designer Portfolio
- **Main Files:**
  - `index.html`: The main web application with high-performance canvas frame animation and dark-mode styling.
  - `ezgif-frame-001.jpg` to `ezgif-frame-240.jpg`: 240 sequential image frames used for the scroll/interactive animation.
  - `server.ps1`: Custom multi-threaded C# TCP server script for PowerShell.

---

## 2. Fast Local Server (`server.ps1`)

The server is built with a lightweight, multi-threaded C# socket engine running inside PowerShell. It binds to all network interfaces (`IPAddress.Any`), allowing both your computer and other devices on your Wi-Fi (such as mobile phones) to load the website.

### How to Run the Server
Open PowerShell in the project directory (`d:\portfolio website`) and execute:

```powershell
powershell -ExecutionPolicy Bypass -File .\server.ps1 -Port 3000
```

### Features of `server.ps1`:
- **Socket-Based (`TcpListener`):** Bypasses Windows HTTP.sys URL reservation restrictions.
- **Cross-Device Ready:** Listens on `0.0.0.0:3000` (accessible via localhost and local IP).
- **MIME Support:** Serves HTML, JPEG/JPG, PNG, WebP, JavaScript, and CSS.
- **CORS Enabled:** Includes `Access-Control-Allow-Origin: *` headers for asset loading.

---

## 3. How to View the Website

### On Your PC
- **URL:** [http://localhost:3000/](http://localhost:3000/) or [http://127.0.0.1:3000/](http://127.0.0.1:3000/)

### On Your Mobile Phone (Same Wi-Fi)
- **URL:** [http://192.168.1.126:3000/](http://192.168.1.126:3000/)

> **Troubleshooting Mobile Access:**  
> If the page does not open on your mobile phone, Windows Defender Firewall may be blocking inbound traffic on port 3000.  
> You can allow it by running this command in an **Administrator** PowerShell window:
> ```powershell
> New-NetFirewallRule -DisplayName "Portfolio Server Port 3000" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow
> ```

---

## 4. Free Open-Source Hosting (GitHub Pages)

To publish your website with a public link accessible from anywhere without Wi-Fi limits:

1. **Create a GitHub Account:** Go to [GitHub](https://github.com/).
2. **Create a New Repository:** Name it `portfolio` (or `<your-username>.github.io`).
3. **Upload Files:** Push or upload `index.html` and all frame images (`ezgif-frame-*.jpg`).
4. **Enable GitHub Pages:**
   - Go to your repository **Settings** > **Pages**.
   - Under **Build and deployment** > **Branch**, select `main` (or `master`) and click **Save**.
5. **Access Your Live Website:**  
   Your website will be live at:
   `https://<your-username>.github.io/<repository-name>/`

---

## 5. Mobile Open-Source Search Links

Quick links for discovering open-source software, projects, and apps on mobile:

- **[OpenAlternative](https://openalternative.co/):** Mobile-optimized directory for open-source alternatives to proprietary SaaS.
- **[GitHub Search](https://github.com/search):** Code and repository search across millions of open-source projects.
- **[AlternativeTo (Open Source)](https://alternativeto.net/platform/all/?license=opensource):** Crowd-sourced recommendations filtered for open source on Android/iOS/Web.
- **[F-Droid](https://f-droid.org/):** Dedicated repository and catalog for free and open-source Android apps.
