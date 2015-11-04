require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @relation = Relaionship.new(user_id:1, friend_id:2, status:3)
  end
  
  test "relationship should be valid" do
    assert @relation.valid?
  end
  
  
  ### user_id and friend_id tests
  test "user_id should not be nil" do
    @relation.user_id = nil
    assert_not @relation.valid?
  end
  
  test "friend_id should not be nil" do
    @relation.friend_id = nil
    assert_not @relation.valid?
  end
  
  test "user_id and friend_id should be different" do
    @relation.friend_id = 1
    assert_not @relation.valid?
  end
  
  test "no same tuple duplicates allowed" do
    relation_dup = @relation.dup
    @relation.save
    assert_not relation_dup.valid?
  end
  
  
  ### status tests
  test "status should not be nil" do
    @relation.status = nil
    assert_not @relation.valid?
  end
  
  test "status should be >= 0 and < 4" do
    @relation.status = -1
    assert_not @relation.valid?
    @relation.status = 4
    assert_not @relation.valid?
  end
  
end
