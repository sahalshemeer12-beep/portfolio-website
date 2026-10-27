param([int]$Port = 3000)

$csharp = @"
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

public class FastTcpServer {
    private TcpListener listener;
    private string rootPath;

    public static void StartServer(string root, int port) {
        var server = new FastTcpServer();
        server.rootPath = root;
        server.listener = new TcpListener(IPAddress.Any, port);
        server.listener.Start();
        Console.WriteLine("Server running on port " + port);

        var listenThread = new Thread(new ThreadStart(() => {
            while (true) {
                try {
                    var client = server.listener.AcceptTcpClient();
                    ThreadPool.QueueUserWorkItem(new WaitCallback(server.HandleClient), client);
                } catch { break; }
            }
        }));
        listenThread.IsBackground = true;
        listenThread.Start();
    }

    private void HandleClient(object state) {
        var client = (TcpClient)state;
        try {
            using (var stream = client.GetStream()) {
                stream.ReadTimeout = 5000;
                stream.WriteTimeout = 10000;
                byte[] buffer = new byte[4096];
                int read = stream.Read(buffer, 0, buffer.Length);
                if (read <= 0) return;

                string request = Encoding.UTF8.GetString(buffer, 0, read);
                string[] lines = request.Split(new[] { "\r\n", "\n" }, StringSplitOptions.None);
                if (lines.Length == 0) return;

                string[] reqTokens = lines[0].Split(' ');
                if (reqTokens.Length < 2) return;

                string rawPath = reqTokens[1].TrimStart('/');
                if (rawPath.Contains("?")) {
                    rawPath = rawPath.Substring(0, rawPath.IndexOf('?'));
                }
                if (string.IsNullOrEmpty(rawPath)) rawPath = "index.html";

                string decoded = Uri.UnescapeDataString(rawPath).Replace('/', Path.DirectorySeparatorChar);
                string filePath = Path.Combine(rootPath, decoded);

                if (File.Exists(filePath)) {
                    string ext = Path.GetExtension(filePath).ToLowerInvariant();
                    string contentType = "application/octet-stream";
                    if (ext == ".html") contentType = "text/html; charset=utf-8";
                    else if (ext == ".jpg" || ext == ".jpeg") contentType = "image/jpeg";
                    else if (ext == ".png") contentType = "image/png";
                    else if (ext == ".webp") contentType = "image/webp";
                    else if (ext == ".js") contentType = "application/javascript; charset=utf-8";
                    else if (ext == ".css") contentType = "text/css; charset=utf-8";

                    byte[] data = File.ReadAllBytes(filePath);
                    string header = "HTTP/1.1 200 OK\r\n" +
                                   "Content-Type: " + contentType + "\r\n" +
                                   "Content-Length: " + data.Length + "\r\n" +
                                   "Access-Control-Allow-Origin: *\r\n" +
                                   "Connection: close\r\n\r\n";
                    byte[] headerBytes = Encoding.UTF8.GetBytes(header);
                    stream.Write(headerBytes, 0, headerBytes.Length);
                    stream.Write(data, 0, data.Length);
                } else {
                    string notFound = "HTTP/1.1 404 Not Found\r\nContent-Length: 9\r\nConnection: close\r\n\r\nNot Found";
                    byte[] notFoundBytes = Encoding.UTF8.GetBytes(notFound);
                    stream.Write(notFoundBytes, 0, notFoundBytes.Length);
                }
            }
        } catch { }
        finally {
            try { client.Close(); } catch { }
        }
    }
}
"@

Add-Type -TypeDefinition $csharp -Language CSharp
[FastTcpServer]::StartServer($PSScriptRoot, $Port)

while ($true) {
    Start-Sleep -Seconds 3600
}
