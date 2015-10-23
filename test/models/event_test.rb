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
      StartDay: 15,
      StartMonth: 6,
      StartYear: 2016,
      EndDay: 15,
      EndMonth: 6,
      EndYear: 2016,
      StartHour: 12,
      StartMinute: 30,
      EndHour: 13,
      EndMinute: 30
    )
  end
  
  
  #
  # valid test
  #
  test "should be valid" do
    assert @event.valid?
  end
  
  
  #
  # string based tests
  #
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
  
  
  #
  # date tests
  #
  test "event's starting day should be <= 31 and > 0" do
    @event.StartDay = 32
    assert_not @event.valid?
    @event.StartDay = 0
    assert_not @event.valid?
  end
  
  test "event's ending day should be <= 31 and > 0" do
    @event.EndDay = 32
    assert_not @event.valid?
    @event.EndDay = 0
    assert_not @event.valid?
  end
  
  test "event's starting month should be <= 12 and > 0" do
    @event.StartMonth = 13
    assert_not @event.valid?
    @event.StartMonth = 0
    assert_not @event.valid?
  end
  
  test "event's ending month should be <= 12 and > 0" do
    @event.EndMonth = 13
    assert_not @event.valid?
    @event.EndMonth = 0
    assert_not @event.valid?
  end
  
  test "EndDay >= StartDay (when starting and ending month and year are the same)" do
    @event.StartDay = 2
    @event.EndDay = 1
    assert_not @event.valid?
  end
  
  test "EndMonth >= StartMonth (when starting and ending day and year are the same)" do
    @event.StartMonth = 2
    @event.EndMonth = 1
    assert_not @event.valid?
  end
  
  test "EndYear >= StartYear (when starting and ending day and month are the same)" do
    @event.StartYear = 2016
    @event.EndYear = 2015
    assert_not @event.valid?
  end
  
  test "StartDay > EndDay is valid when month or year is different" do
    @event.StartDay = 2
    @event.EndDay = 1
    @event.StartMonth = 1
    @event.EndMonth = 2
    assert @event.valid?
    
    @event.EndMonth = 1
    @event.StartYear = 2020
    @event.EndYear = 2021
    assert @event.valid?
  end
  
  test "StartMonth > EndMonth is valid when year is different" do
    @event.StartMonth = 12
    @event.EndMonth = 1
    @event.StartYear = 2020
    @event.EndYear = 2021
    assert @event.valid?
  end
  
  
  #
  # position tests
  #
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
  
  
  #
  # time tests
  #
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
  
  
  test "start time < end time when the dates are the same" do
    # dates are the same
    @event.StartHour = 8
    @event.StartMinute = 30
    @event.EndHour = 7
    @event.EndMinute = 45
    assert_not @event.valid?
    @event.StartHour = 8
    @event.StartMinute = 30
    @event.EndHour = 8
    @event.EndMinute = 30
    assert_not @event.valid?
    
    # dates are not the same
    @event.StartDay = 1
    @event.EndDay = 2
    assert @event.valid?
    @event.StartHour = 8
    @event.StartMinute = 30
    @event.EndHour = 7
    @event.EndMinute = 45
    assert @event.valid?
  end

end
