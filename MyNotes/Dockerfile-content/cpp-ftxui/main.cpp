#include <functional>
#include <iostream>
#include <string>
#include <vector>
#include <ftxui/component/captured_mouse.hpp>
#include <ftxui/component/component.hpp>
#include <ftxui/component/component_options.hpp>
#include <ftxui/component/screen_interactive.hpp>

int main() {
  using namespace ftxui;
  auto screen = ScreenInteractive::TerminalOutput();
  std::vector<std::string> entries = {
      "Файл",
      "Правка",
      "Вид",
      "Справка",
  };
  int selected = 0;
  MenuOption option;
  option.on_enter = screen.ExitLoopClosure();
  auto menu = Menu(&entries, &selected, option);
  screen.Loop(menu);
  std::cout << "You chose point: " << selected + 1 << std::endl;
  return 0;
}