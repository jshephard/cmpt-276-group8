require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @report = Report.new(description: 'Hello, world!', event_id: Event.first.id, user_id: User.first.id)
  end

  test 'valid report can be saved' do
    assert @report.valid?
    assert @report.save
  end

  test 'non-existent event id' do
    @report.event_id = -1
    assert @report.invalid?
  end

  test 'non-existent user id' do
    @report.user_id = -1
    assert @report.invalid?
  end
end
