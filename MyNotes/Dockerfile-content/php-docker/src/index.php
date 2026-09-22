<!DOCTYPE html>
<html>
<head>
    <title>PHP в Docker</title>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial; margin: 40px; line-height: 1.6; }
        .info { background: #f0f0f0; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Привет из PHP в Docker! 🐳</h1>
    <div class="info">
        <h3>Информация о PHP:</h3>
        <?php
        echo "<p>Версия PHP: " . phpversion() . "</p>";
        echo "<p>Загруженные расширения: " . implode(', ', get_loaded_extensions()) . "</p>";
        ?>
    </div>
</body>
</html>