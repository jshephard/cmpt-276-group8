require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  setup do
    @event = Event.new(Title: "New Event", Latitude: 15.123456, Longitude: 90.123456, Description: "A new event.", Category: "Party", Day: 15, Month: 6, Year: 2016 )
  end
  
  test "should be valid" do
    assert @event.valid?
  end
  
  test "event title should be <= 20 chars and > 0 chars" do
    @event.Title = "a" * 21
    assert_not @event.valid?
    @event.Title = ""
    assert_not @event.valid?
  end
  
  test "event description should <= 140 chars" do
    @event.Description = "a" * 141
    assert_not @event.valid?
  end
  
  test "event day should be <= 31 and > 0" do
    @event.Day = 32
    assert_not @event.valid?
    @event.Day = 0
    assert_not @event.valid?
  end
  
  test "event month should be <= 12 and > 0" do
    @event.Month = 13
    assert_not @event.valid?
    @event.Month = 0
    assert_not @event.valid?
  end
  
  test "latitude should be <= 90 and >= -90" do
    @event.Latitude = -91
    assert_not @event.valid?
    @event.Latitude = 91
    assert_not @event.valid?
  end
  
  test "longitude should be <= 180 and >= -180" do
    @event.Longitude = -181
    assert_not @event.valid?
    @event.Longitude = 181
    assert_not @event.valid?
  end
  
end
