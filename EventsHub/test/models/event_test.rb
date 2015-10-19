require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  setup do
    @event = Event.new(
      Title: "New Event",
      Latitude: 15.123456,
      Longitude: 90.123456,
      Description: "A new event.",
      Category: "Party",
      Day: 15,
      Month: 6,
      Year: 2016,
      StartHour: 12,
      StartMinute: 30,
      EndHour: 12,
      EndMinute: 30
    )
  end
  
  test "should be valid" do
    assert @event.valid?
  end
  
  test "event title should be <= 80 chars and >= 3 chars" do
    @event.Title = "a" * 81
    assert_not @event.valid?
    @event.Title = "aa"
    assert_not @event.valid?
  end
  
  test "event description should <= 200 chars" do
    @event.Description = "a" * 201
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
  
  test "minutes should be < 60 and >= 0" do
    @event.StartMinute = -1
    assert_not @event.valid?
    @event.StartMinute = 60
    assert_not @event.valid?
    @event.StartMinute = 30
    @event.EndMinute = -1
    assert_not @event.valid?
    @event.EndMinute = 60
    assert_not @event.valid?
  end
  
  test "hours should be < 24 and >= 0" do
    @event.StartHour = -1
    assert_not @event.valid?
    @event.StartHour = 24
    assert_not @event.valid?
    @event.StartHour = 12
    @event.EndHour = -1
    assert_not @event.valid?
    @event.EndHour = 24
    assert_not @event.valid?
  end
  
  test "start time should be before end time" do
    @event.StartHour = 8
    @event.StartMinute = 30
    @event.EndHour = 7
    @event.EndMinute = 45
    assert_not @event.valid?
  end
  
end
