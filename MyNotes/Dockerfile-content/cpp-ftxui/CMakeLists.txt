cmake_minimum_required(VERSION 3.10)
project(ftxui_demo)
# Указываем стандарт C++17 (FTXUI требует C++17)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# Подключаем FetchContent для загрузки FTXUI
include(FetchContent)
FetchContent_Declare(ftxui
  GIT_REPOSITORY https://github.com/ArthurSonzogni/FTXUI.git
  GIT_TAG v5.0.0  # можно использовать последний тег
)
FetchContent_MakeAvailable(ftxui)
# Создаём исполняемый файл
add_executable(ftxui_demo main.cpp)
# Линкуем библиотеки FTXUI
target_link_libraries(ftxui_demo PRIVATE
  ftxui::component
  ftxui::dom
  ftxui::screen
)