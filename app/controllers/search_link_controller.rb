class SearchLinkController < ApplicationController
  def index
    @arr = params[:arr] || []
    @rank = params[:rank] || 'unrank'
  end

  def search_exact
    agent = Mechanize.new
    page = agent.get(params[:web_link])
    rank = search_google
    arr = page.links.map { |link| { link: link.href, active: true } if link.href =~ %r{^https?://} }.compact
    visited_arr = []
    i = 0
    # until arr == visited_arr
    #   begin
    #     page = agent.get(arr[i][:link])
    #     arr = arr.union page.links.map { |link|
    #                       { link: link.href, active: true } if link.href =~ %r{^https?://}
    #                     }.compact
    #     logger = Rails.logger
    #     logger.info arr[i]
    #   rescue StandardError
    #     arr[i][:active] = false
    #   ensure
    #     visited_arr.push(arr[i])
    #     i += 1
    #   end
    # end
    redirect_to search_link_index_path(arr: arr, rank: rank)
  end

  def search_google
    agent = Mechanize.new
    page = agent.get('http://google.com')
    google_form = page.form('f')
    google_form.q = params[:web_link]
    page = agent.submit(google_form, google_form.buttons.first)
    arr_link = page.links.map { |link| link.href[%r{(?<=/url\?q=).+?(?=&sa)}] }.compact
    rank = 0
    arr_link.each_with_index do |link, index|
      params[:web_link] = params[:web_link][0..-2] if params[:web_link][-1] == '/'
      link = link [0..-2] if link[-1] == '/'
      rank = index + 1 if link == params[:web_link]
    end
    debugger
    rank
  end
end
