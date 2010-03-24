# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  before(:each) do
    @dashboard_controller = DashboardController.new
  end

  it "should play an audio file when the build is broken" do
    #mock out the private method get_cctray_feed_xml
    mock_uri = mock(:uri)
    mock_uri.should_receive(:port).and_return(80)
    mock_uri.should_receive(:host).and_return("my_machine")
    mock_uri.should_receive(:path).and_return("/")
    URI.should_receive(:parse).with("my_url").and_return(mock_uri)

    mock_http_connection = mock(:http)
    mock_http_connection.should_receive(:open_timeout=)
    mock_http_connection.should_receive(:read_timeout=)

    mock_response = mock(:response)
    mock_http_connection.should_receive(:request_get).and_return(mock_response)
    DashboardConfig.should_receive(:cctray_feed_open_timeout)
    DashboardConfig.should_receive(:cctray_feed_read_timeout)

    mock_return = Net::HTTPSuccess.new
    mock_http_connection.should_receive(:start).and_yield(:mock_return)
 

    Net::HTTP.should_receive(:new).with("my_machine", 80).and_return(mock_http_connection)
    # mock out controller
    mock_url_list = {"my_group_name" => "my_url"}
    DashboardConfig.should_receive(:cctray_feed_urls).and_return(mock_url_list)



    get "index"
  end
end

