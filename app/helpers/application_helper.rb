module ApplicationHelper
    def set_title(title = nil)
        if title.nil?
            @page_title = "Riddle"
        else
            @page_title = "Riddle | #{title}"
        end
    end
end
