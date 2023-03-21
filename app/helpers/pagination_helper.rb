module PaginationHelper

  def pagination_range page, total_pages
    range_start = page < 5 ? 1 : page - 5
    range_end = page + 5 > total_pages ? total_pages : page + 5
    (range_start..range_end)
  end

  def first_disabled? page
    page == 1 && 'disabled'
  end

  def page_disabled? page, page_number
    page == page_number && 'disabled'
  end

  def last_disabled? page, total_pages
    page == total_pages && 'disabled'
  end

  def pagination_url page_number
    movies_search_path(request.query_parameters.merge(page: page_number))
  end

end
