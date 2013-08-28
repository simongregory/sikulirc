require "rexml/document"
require "uri"

module Sikulirc
  class RemoteScreen
    include Command
    include REXML

    def initialize(server, port="9000")
      @serv = URI("http://#{server}:#{port}/script.do")
    end

    def app_focus(app)
      execute_command(@serv, 'app_focus', :app => app)
    end

    def page_down
      execute_command(@serv, "page_down")
    end

    def set_min_similarity(similarity = 0.7)
      execute_command(@serv, 'set_min_similarity', :similarity => similarity)
    end

    def click(psc, timeout = 10)
      execute_command(@serv, "click", :psc => psc, :timeout => timeout) { |xml_dump| process_result(xml_dump, psc) }
    end

    def click_offset(psc, x = 0, y = 0)
      execute_command(@serv, "click_offset", :psc => psc, :x => x, :y => y) { |xml_dump| process_result(xml_dump, psc) }
    end

    def mouse_move_absolute(x = 0, y = 0)
      execute_command(@serv, "mouse_move_absolute", :x => x, :y => y)
    end

    def mouse_move(psc, x = 0, y = 0)
      execute_command(@serv, "mouse_move", :psc => psc, :x => x, :y => y) { |xml_dump| process_result(xml_dump, psc) }
    end

    def mouse_move_delay(delay = 0.5)
      execute_command(@serv, "mouse_move_delay", :delay => delay)
    end


    def find(psc)
      execute_command(@serv, 'find', :psc => psc) { |xml_dump| process_result(xml_dump, psc) }
    end

    def type_in_field(psc, content)
      execute_command(@serv, 'type_in_field', :psc => psc, :content => content) { |xml_dump| process_result(xml_dump, psc) }
    end

    def wait(psc, timeout = 30)
      execute_command(@serv, "wait", :psc => psc, :timeout => timeout) { |xml_dump| process_result(xml_dump, psc) }
    end

    def double_click(psc)
      execute_command(@serv, "double_click", :psc => psc) { |xml_dump| process_result(xml_dump, psc) }
    end

    def double_click_offset(psc, x = 0, y = 0)
      execute_command(@serv, "double_click_offset", :psc => psc, :x => x, :y => y) { |xml_dump| process_result(xml_dump, psc) }
    end

    def click_screen
      execute_command(@serv, "click_screen")
    end

    def double_click_screen
      execute_command(@serv, "double_click_screen")
    end

    def press_tab
      execute_command(@serv, "press_tab")
    end

    def press_shift_tab
      execute_command(@serv, "press_shift_tab")
    end

    def press_f
      execute_command(@serv, "press_f")
    end

    def press_esc
      execute_command(@serv, "press_esc")
    end

    def press_space
      execute_command(@serv, "press_space")
    end

    def press_enter
      execute_command(@serv, "press_enter")
    end

    def press_left_arrow
      execute_command(@serv, "press_left_arrow")
    end

    def press_shift_left_arrow
      execute_command(@serv, "press_shift_left_arrow")
    end

    def press_right_arrow
      execute_command(@serv, "press_right_arrow")
    end

    def press_shift_right_arrow
      execute_command(@serv, "press_shift_right_arrow")
    end

    def press_up_arrow
      execute_command(@serv, "press_up_arrow")
    end

    def press_down_arrow
      execute_command(@serv, "press_down_arrow")
    end

    def press_home
      execute_command(@serv, "press_home")
    end

    def press_end
      execute_command(@serv, "press_end")
    end

    def press_page_up
      execute_command(@serv, "press_page_up")
    end

    def press_page_down
      execute_command(@serv, "press_page_down")
    end

    private

    def raise_exception(exception_message, psc)
      if exception_message.include? "FindFailed: can not find"
        raise Sikulirc::ImageNotFound, "The image '#{psc}' does not exist."
      else
        raise Sikulirc::CommandError, "Something is wrong with the command.\n\n#{exception_message}"
      end
    end

    def process_result(xml_dump, psc)
      doc = Document.new(xml_dump)
      if doc.elements["/script/status"].text == "FAIL"
        raise_exception(doc.elements["//message"].text, psc)
      end
    end

  end
end
