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
      Address: "8888 University Dr.",
      StartDate: '2016-06-15',
      EndDate: '2016-06-15',
      StartTime: '12:30:00.000000',
      EndTime: '13:30:00.000000'
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
=begin
  test "event's starting day should be <= 31 and > 0" do
    @event.StartDate = @event.StartDate.change(day: 32)
    assert_not @event.valid?
    @event.StartDate = @event.StartDate.change(day: 0)
    assert_not @event.valid?
  end

  test "event's ending day should be <= 31 and > 0" do
    @event.EndDate = @event.EndDate.change(day: 32)
    assert_not @event.valid?
    @event.EndDate = @event.EndDate.change(day: 0)
    assert_not @event.valid?
  end

  test "event's starting month should be <= 12 and > 0" do
    @event.StartDate = @event.StartDate.change(month: 13)
    assert_not @event.valid?
    @event.StartDate = @event.StartDate.change(month: 0)
    assert_not @event.valid?
  end

  test "event's ending month should be <= 12 and > 0" do
    @event.EndDate = @event.EndDate.change(month: 13)
    assert_not @event.valid?
    @event.EndDate = @event.EndDate.change(month: 0)
    assert_not @event.valid?
  end
=end

  test "EndDay >= StartDay (when starting and ending month and year are the same)" do
    @event.StartDate = @event.StartDate.change(day: 2)
    @event.EndDate = @event.EndDate.change(day: 1)
    assert_not @event.valid?
  end

  test "EndMonth >= StartMonth (when starting and ending day and year are the same)" do
    @event.StartDate = @event.StartDate.change(month: 2)
    @event.EndDate = @event.EndDate.change(month: 1)
    assert_not @event.valid?
  end

  test "EndYear >= StartYear (when starting and ending day and month are the same)" do
    @event.StartDate = @event.StartDate.change(year: 2016)
    @event.EndDate = @event.EndDate.change(year: 2015)
    assert_not @event.valid?
  end

  test "StartDay > EndDay is valid when month or year is different" do
    @event.StartDate = @event.StartDate.change(month: 1, day: 2)
    @event.EndDate = @event.EndDate.change(month: 2, day: 1)
    assert @event.valid?

    @event.StartDate = @event.StartDate.change(year: 2020)
    @event.EndDate = @event.EndDate.change(month: 1, year: 2021)
    assert @event.valid?
  end

  test "StartMonth > EndMonth is valid when year is different" do
    @event.StartDate = @event.StartDate.change(month: 12, year: 2020)
    @event.EndDate = @event.EndDate.change(month: 1, year: 2021)
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
=begin
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
=end

  test "start time < end time when the dates are the same" do
    # dates are the same
    @event.StartTime = @event.StartTime.change(hour: 8, minute: 30)
    @event.EndTime = @event.EndTime.change(hour: 7, minute: 45)
    assert_not @event.valid?
    @event.StartTime = @event.StartTime.change(hour: 8, minute: 30)
    @event.EndTime = @event.EndTime.change(hour: 8, minute: 30)
    assert_not @event.valid?
    
    # dates are not the same
    @event.StartDate = @event.StartDate.change(day: 1)
    @event.EndDate = @event.EndDate.change(day: 2)
    assert @event.valid?, @event.errors.messages
    @event.StartTime = @event.StartTime.change(hour: 8, minute: 30)
    @event.EndTime = @event.EndTime.change(hour: 7, minute: 45)
    assert @event.valid?, @event.errors.messages
  end

end
