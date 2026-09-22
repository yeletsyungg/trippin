#include <FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Button.H>

int main(int argc, char **argv) {
    // Создаём окно размером 300x180 пикселей
    Fl_Window *window = new Fl_Window(300, 180, "Привет из Docker!");
    // Создаём кнопку и размещаем её в окне
    Fl_Button *button = new Fl_Button(80, 60, 140, 40, "Нажми меня!");
    // Завершаем добавление виджетов в окно
    window->end();
    // Показываем окно
    window->show(argc, argv);
    // Запускаем главный цикл обработки событий
    return Fl::run();
}