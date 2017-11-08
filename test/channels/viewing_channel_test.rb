# frozen_string_literal: true

require_relative '../test_helper'

class ViewingChannelTest < ActionCable::Channel::TestCase
  before do
    ViewingChannel.any_instance.stubs(:current_user).returns(users(:researcher))
  end

  it 'should track the number of subscribing views and return them' do
    assert_broadcasts 'viewing:offers:1', 0
    subscribe model: 'offers', id: 1, view: 'show'
    assert_broadcasts 'viewing:offers:1', 1
    broadcasts('viewing:offers:1').last.must_equal '{"views":{"show":["1"]}}'

    # second tab gets opened on same view
    subscribe model: 'offers', id: 1, view: 'show'
    broadcasts('viewing:offers:1').last.must_equal(
      '{"views":{"show":["1","1"]}}'
    )

    # one tab changes view internally
    perform :change_view,
            last: { 'model' => 'offers', 'id' => 1, 'view' => 'show' },
            next: { 'model' => 'offers', 'id' => 1, 'view' => 'edit' }
    broadcasts('viewing:offers:1').last.must_equal(
      '{"views":{"edit":["1"],"show":["1"]}}'
    )

    # changes view externally (from one model instance to another)
    assert_broadcasts 'viewing:cities:2', 0
    perform :change_view,
            last: { 'model' => 'offers', 'id' => 1, 'view' => 'edit' },
            next: { 'model' => 'cities', 'id' => 2, 'view' => 'show' }
    broadcasts('viewing:offers:1').last.must_equal(
      '{"views":{"edit":[],"show":["1"]}}'
    )
    broadcasts('viewing:cities:2').last.must_equal(
      '{"views":{"edit":[],"show":["1"]}}'
    )

    # show tab gets closed
    subscription.unsubscribe_from_channel
    broadcasts('viewing:offers:1').last.must_equal(
      '{"views":{"edit":[],"show":[]}}'
    )
    broadcasts('viewing:cities:2').last.must_equal(
      '{"views":{"edit":[],"show":["1"]}}'
    )
  end
end
