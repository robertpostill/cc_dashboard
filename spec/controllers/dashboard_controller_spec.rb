# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  before(:each) do
    @dashboard_controller = DashboardController.new
  end

  it "should play an audio file when the build is broken" do
    #mock out the private method get_cctray_feed_xml
#    mock_uri = mock(:uri)
#    mock_uri.should_receive(:port).and_return(80)
#    mock_uri.should_receive(:host).and_return("my_machine")
#    mock_uri.should_receive(:path).and_return("/")
#    URI.should_receive(:parse).with("http://my_machine/").and_return(mock_uri)

#    mock_http_connection = mock(:http)
#    mock_http_connection.should_receive(:open_timeout=)
#    mock_http_connection.should_receive(:read_timeout=)
    DashboardConfig.should_receive(:cctray_feed_open_timeout).and_return(60)
    DashboardConfig.should_receive(:cctray_feed_read_timeout).and_return(60)
canned_response =<<EOS
<Projects>
  <Project name="Centres" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="Sleeping" webUrl="http://waf.ci.dbg.westfield.com/projects/Centres" lastBuildStatus="Failure" lastBuildLabel="6843" category="" lastBuildTime="2010-03-25T14:02:58+11:00"/>
  <Project name="CommonPlugins" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="Sleeping" webUrl="http://waf.ci.dbg.westfield.com/projects/CommonPlugins" lastBuildStatus="Success" lastBuildLabel="6600" category="" lastBuildTime="2010-03-03T14:00:26+11:00"/>
  <Project name="Premium" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="Sleeping" webUrl="http://waf.ci.dbg.westfield.com/projects/Premium" lastBuildStatus="Success" lastBuildLabel="6848" category="" lastBuildTime="2010-03-25T18:03:23+11:00"/>
  <Project name="PremiumIntegration" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="Sleeping" webUrl="http://waf.ci.dbg.westfield.com/projects/PremiumIntegration" lastBuildStatus="Success" lastBuildLabel="6602" category="" lastBuildTime="2010-03-02T03:19:33+11:00"/>
  <Project name="WeAreFamily" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="Sleeping" webUrl="http://waf.ci.dbg.westfield.com/projects/WeAreFamily" lastBuildStatus="Success" lastBuildLabel="6536.1" category="" lastBuildTime="2010-02-25T12:12:58+11:00"/>
  <Project name="backoffice" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="Sleeping" webUrl="http://waf.ci.dbg.westfield.com/projects/backoffice" lastBuildStatus="Success" lastBuildLabel="1606" category="" lastBuildTime="2010-03-25T16:28:00+11:00"/>
  <Project name="contentstore" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="Sleeping" webUrl="http://waf.ci.dbg.westfield.com/projects/contentstore" lastBuildStatus="Success" lastBuildLabel="450" category="" lastBuildTime="2010-03-18T14:30:55+11:00"/>
  <Project name="premium-legacy" nextBuildTime="1970-01-01T00:00:00.000000-00:00" activity="Sleeping" webUrl="http://waf.ci.dbg.westfield.com/projects/premium-legacy" lastBuildStatus="Success" lastBuildLabel="6848" category="" lastBuildTime="2010-03-25T18:28:56+11:00"/>
</Projects>
EOS
    FakeWeb.register_uri(:get, "http://mymachine/fake.xml", :body => canned_response,
                                                    :status => ["200", "OK"])
    mock_response = mock(:response)
#    mock_http_connection.should_receive(:start).and_yield(mock_response)
 

#    Net::HTTP.should_receive(:new).with("mymachine", 80).and_return(mock_http_connection)
    # mock out controller
    mock_url_list = {"my_group_name" => "http://mymachine/fake.xml"}
    DashboardConfig.should_receive(:cctray_feed_urls).and_return(mock_url_list)



    get "index"
  end
end

