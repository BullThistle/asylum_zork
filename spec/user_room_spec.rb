#!/usr/bin/env ruby

require 'spec_helper'

describe('UserRoom') do
  let(:room) { Room.create({
    name: 'Start',
    description: 'The First Room.',
    x_coordinate: 1,
    y_coordinate: 1,
    active: true,
    solution_item: 'key',
    north_exit: true,
    east_exit: false,
    south_exit: true,
    west_exit: true,
    first_impression: 'you have entered a spooky foyer'
    }) }
  let(:user_room) {UserRoom.create({
    user_id: nil,
    room_id: room.id,
    active: room.active,
    visited: false,
    }) }
  describe('.room') do
    it "returns the room template associated with the user_room" do
      expect(user_room.room).to eq(room)
    end
  end

  describe('.look') do
    it "returns the first impression if a user_room has not been visited" do
      expect(user_room.look).to eq("you have entered a spooky foyer")
    end

    it "returns the regular description if a user_room has been visited" do
      user_room.look
      expect(user_room.look).to eq('The First Room.')
    end
  end
end
