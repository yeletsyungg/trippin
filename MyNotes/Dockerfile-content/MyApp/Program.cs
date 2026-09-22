var app = WebApplication.Create(args);
app.MapGet("/", () => "Hello from Docker! Привет из Docker!");
app.Run("http://*:80");