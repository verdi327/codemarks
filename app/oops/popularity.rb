module OOPs
  class LinkPopularity
    def self.calculate link
      return 0 if link.nil?
      link.clicks_count + link.codemarks_count
    end

    def self.calculate_scoped link, clicks, link_saves
      return 0 if link.nil?
      click_count = clicks[link.id].present? ? clicks[link.id].count : 0
      save_count = link_saves[link.id].present? ? link_saves[link.id].count : 0
      return click_count + save_count
    end
  end
end
