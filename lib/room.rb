#!/usr/bin/env ruby

class Room < ActiveRecord::Base
  has_one :item

  def title_name
    words = self.name.split("-").each do |word|
      word.capitalize!
    end
    words.join(" ")
  end

  def note
    Note.find_by(room_name: self.name)
  end

  def move(direction)
    direction.downcase!
    if ((direction == "north") | (direction == 'n')) & north_exit
      return Room.find_by_coordinates(self.x_coordinate, self.y_coordinate + 1)
    elsif ((direction == "east") | (direction == 'e')) & east_exit
      return Room.find_by_coordinates(self.x_coordinate + 1, self.y_coordinate)
    elsif ((direction == "south") | (direction == 's')) & south_exit
      return Room.find_by_coordinates(self.x_coordinate, self.y_coordinate - 1)
    elsif ((direction == "west") | (direction == 'w')) & west_exit
      return Room.find_by_coordinates(self.x_coordinate - 1, self.y_coordinate)
    else
      return nil
    end
  end

  def look
    if !self.visited
      self.update({visited: true})
      return self.first_impression
    else
      return self.description
    end
  end

  def take(item_name)
    if self.item
      if Item.recognize(item_name) == self.item
        return self.item.update({room_id: nil, in_inventory: true})
      end
    end
    return false
  end

  def use(item_name)
    if self.solution_item
      use_item = Item.recognize(item_name)
      if use_item
        if (use_item == Item.find_by(name: self.solution_item)) & use_item.in_inventory
          success_room = Room.where("name = ? AND active = ?", self.name, false).first
          self.update({active: false})
          success_room.update({active: true})
          use_item.update({in_inventory: false})
          return success_room
        end
      end
    end
  end

  def read
    if self.note
      return self.note.note_text
    else
      return nil
    end
  end

  def self.find_by_coordinates(x, y)
    results = Room.where("x_coordinate = ? AND y_coordinate = ? AND active = ?", x, y, true)
    if results.length > 0
      return results.first
    else
      return nil
    end
  end
end
