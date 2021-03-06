class Recipient < ActiveRecord::Base
  belongs_to :delivery_person
  belongs_to :post_office

def self.assign_random_post_office
  counter = PostOffice.count
  shuffle_array = [*1..counter]
      Recipient.find_each  do |recipient|
        recipient.post_office_id = shuffle_array.sample
        recipient.save
      end
end

def self.set_delivery_person
  DeliveryPerson.select do |delivery_person|
    Recipient.find do |recipient|
     delivery_person.post_office_id == recipient.post_office_id
       recipient.delivery_person_id = delivery_person.id
       recipient.save
     end
  end
end

def self.change_avail(recipient)
  Recipient.find_by(name: recipient).tap do |recipient|
    recipient.available = true
    recipient.save
  end
end


def self.package_count(name)
  num = 0
  Recipient.find do |recipient|
    if recipient.name == name
      if recipient.deliveries_received != nil
         num = recipient.deliveries_received
         num+=1
        recipient.deliveries_received = num
        recipient.save
      else
        num = 0
        num+=1
        recipient.deliveries_received = num
        recipient.save
      end
    end
  end
end

def self.receive_delivery(recipient)
  name = recipient
  delivery_person = Array.new
  Recipient.find do |recipient_list|
    name_of_deliverer = DeliveryPerson.find(recipient_list.delivery_person_id)["name"]
    delivery_person << name_of_deliverer
   end
   puts "Thanks for the delivery #{delivery_person.join}!"
   Recipient.package_count(name)
end


end
