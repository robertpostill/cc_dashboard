require 'rexml/document'
require 'net/http'
require 'uri'
require 'ostruct'

class DashboardController < ApplicationController

  def index
    @skin = params[:skin] || DashboardConfig.skin;
    @refresh = params[:refresh] || DashboardConfig.refresh_interval
    
    @activity_building = 0
    @status_failure    = 0
    @status_exception  = 0
    @status_success    = 0
    @status_unknown    = 0

    @projects = []
    DashboardConfig.cctray_feed_urls.each do |group_name, feed_url|
      doc = REXML::Document.new get_cctray_feed_xml(feed_url)
      doc.elements.each('Projects/Project') do |element|
        project = Project.new
        project.group_name = group_name
        project.populate_from_xml(element)
        @projects.push(project)

        case project.lastBuildStatus
        when 'Error' # 'Error' is our own status, not part of the cctray spec
          @status_exception += 1
        when 'Failure'
          @status_failure += 1
          play_sound
        when 'Exception'
          @status_exception += 1
        when 'Success'
          @status_success += 1
        when 'Unknown'
          @status_unknown += 1
        end

        @activity_building += 1 if project.activity == 'Building'
      end
    end

    if @activity_building > 0
      @status = 'building'
    elsif @status_failure > 0 || @status_exception > 0
      @status = 'sick'
    else
      @status = 'healthy'
    end

    @icon = "#{@status}.ico"

    @chuck_norris_fact = CHUCK_NORRIS_FACTS[rand(CHUCK_NORRIS_FACTS.length)]
  end
 
  private

  def get_cctray_feed_xml(feed_url)
    url = URI.parse(feed_url)
#    begin
      http = Net::HTTP.new(url.host, url.port)
      http.open_timeout = DashboardConfig.cctray_feed_open_timeout
      http.read_timeout = DashboardConfig.cctray_feed_read_timeout
      http.start do
        response = http.request_get(url.path)
        case response
          when Net::HTTPSuccess     then response.body
          when Net::HTTPRedirection then get_cctray_feed_xml(response['location'])
          else cctray_error_xml(feed_url, response.message)
        end
      end
#    rescue Exception => e
#      cctray_error_xml(feed_url, e.message)
#    end
  end

  def play_sound
    `afplay "/users/sliceofnice/hard shaker beat.wav"`
  end

  # To make the error handling logic simple put an error message inside a
  # cctray-formatted xml
  def cctray_error_xml(feed_url, message)
    error = <<EOF
<Projects>
  <Project name="#{message} [#{feed_url}]" activity="Error" lastBuildStatus="Error" lastBuildLabel="unknown" lastBuildTime="unknown" webUrl="#{feed_url}"/>
</Projects>
EOF
  end

end
