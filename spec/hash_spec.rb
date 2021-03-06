require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Hash, "to_xml_attributes" do
  before do
    @hash = { :one => "ONE", "two" => "TWO" }
  end

  it "should turn the hash into xml attributes" do
    attrs = @hash.to_xml_attributes
    attrs.should match(/one="ONE"/m)
    attrs.should match(/two="TWO"/m)
  end

  it 'should preserve _ in hash keys' do
    attrs = {
      :some_long_attribute => "with short value",
      :crash               => :burn,
      :merb                => "uses extlib"
    }.to_xml_attributes

    attrs.should =~ /some_long_attribute="with short value"/
    attrs.should =~ /merb="uses extlib"/
    attrs.should =~ /crash="burn"/
  end
end


describe Hash, 'to_params' do
  {
    { "foo" => "bar", "baz" => "bat" } => "foo=bar&baz=bat",
    { "foo" => [ "bar", "baz" ] } => "foo[]=bar&foo[]=baz",
    { "foo" => [ {"bar" => "1"}, {"bar" => 2} ] } => "foo[][bar]=1&foo[][bar]=2",
    { "foo" => { "bar" => [ {"baz" => 1}, {"baz" => "2"}  ] } } => "foo[bar][][baz]=1&foo[bar][][baz]=2",
    { "foo" => {"1" => "bar", "2" => "baz"} } => "foo[1]=bar&foo[2]=baz"
  }.each do |hash, params|
    it "should covert hash: #{hash.inspect} to params: #{params.inspect}" do
      hash.to_params.split('&').sort.should == params.split('&').sort
    end
  end

  it 'should not leave a trailing &' do
    { :name => 'Bob', :address => { :street => '111 Ruby Ave.', :city => 'Ruby Central', :phones => ['111-111-1111', '222-222-2222'] } }.to_params.should_not match(/&$/)
  end
  
  it 'should URL encode unsafe characters' do
    {:q => "?&\" +"}.to_params.should == "q=%3F%26%22%20%2B"
  end
  
end