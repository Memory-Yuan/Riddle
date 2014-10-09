module ApplicationHelper
    def set_title(title = "")
        if title.empty?
            @page_title = "Riddle"
        else
            @page_title = "Riddle | #{title}"
        end
    end
end
